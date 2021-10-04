//
//  ArticleListViewModel.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/30.
//

import Moya
import RealmSwift
import RxRelay
import RxSwift

final class ArticlesListViewModel {
    
    let dataMock = """
        {
          "status": "ok",
          "totalResults": 10901,
          "articles": [
            {
              "source": {
                "id": "the-verge",
                "name": "The Verge"
              },
              "author": "Sean O'Kane",
              "title": "Tesla sold 241,300 cars in the third quarter while other automakers saw big drops",
              "description": "Tesla sold 241,300 electric cars in the third quarter of 2021, up from 201,250 in the second quarter, and a record for the company. Tesla increased deliveries despite the lingering global chip shortage, which is crushing sales at major automakers.",
              "url": "https://www.theverge.com/2021/10/2/22704830/tesla-sold-241300-cars-third-quarter",
              "urlToImage": "https://cdn.vox-cdn.com/thumbor/K_bEH32Nktz7CKaS79jXcZk5hYU=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/13668774/tesla_model_3_0638.jpg",
              "publishedAt": "2021-10-02T16:05:40Z",
              "content": "Its third-quarter vehicle sales were higher than expected Photo by Sean OKane / The Verge Tesla has bucked the wider trend of declining sales brought on by the global chip shortage in the third qu… [+1329 chars]"
            },
            {
           "source":{
              "id":"usa-today",
              "name":"USA Today"
           },
           "author":"Charles Curtis",
           "title":"The 35 best movies streaming on Netflix (October 2021)",
           "description":"A look at what to watch this month.",
           "url":"https://ftw.usatoday.com/lists/netflix-october-2021-streaming-best-movies",
           "urlToImage":"https://ftw.usatoday.com/wp-content/uploads/sites/90/2021/10/LL_GD_LegallyBlonde_060818-e1633175852201.jpg?w=1024&h=576&crop=1",
           "publishedAt":"2021-10-02T16:00:11Z",
           "content":"It’s a new month! And you know what that means: It’s time to go through another round of some of the best movies on Netflix’s enormous catalog — from some classics to new offerings — to figure out wh… [+5878 chars]"
            }]
        }
        """.data(using: .utf8)
    
    private var articlesListProvider: MoyaProvider<ArticlesListService>
    private var realm: Realm
    private var isRechable = BehaviorRelay<Bool>(value: false)
    private let articles = BehaviorRelay<[Article]>(value: [])
    private var fetchStatus: FetchStates = .none
    private let alertMessage = PublishSubject<AlertMessage>()
    var articles1: [Article] = [] {
        didSet {
            print(articles1)
        }
    }
    
    public var onArticles: Observable<[Article]> {
        articles.asObservable()
    }

    init(articlesListProvider: MoyaProvider<ArticlesListService>, realm: Realm) {
        self.articlesListProvider = articlesListProvider
        self.realm = realm
        if NetworkState().isInternetAvailable {
            isRechable.accept(true)
        }
        loadArticles()
        fetchArticles()
    }
    
    private func loadArticles() {
        guard let localItems = realm.objects(Article.self).sorted(byKeyPath: Article.CodingKeys.title.rawValue, ascending: false).array else {
            fetchArticles()
            return
        }
        articles.accept(localItems)
    }
    
    private func fetchArticles() {
//        if fetchStatus != .willFetch {
//            return
//        }
        
        fetchStatus = .fetching
        articlesListProvider.request(.init(), completion: { result in
            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let aa = String(data: filteredResponse.data, encoding: .utf8)?.replacingOccurrences(of: "\r\n", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "") ?? ""
                        let fetchedItems = try decoder.decode([Article].self, from: self.dataMock!, keyPath: "articles")
                        self.articles1 = fetchedItems
                        try? self.realm.write {
                            self.realm.add(fetchedItems, update: .modified)
                        }

                        let data = fetchedItems
                        self.articles.accept(data)
                        print(data)

                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }

                } catch {
                    self.alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self.fetchStatus = .willFetch
                self.alertMessage.onNext(AlertMessage(title: "Failed", message: ""))
            }
        })
    }
}

