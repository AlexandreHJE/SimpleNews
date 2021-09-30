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
    private var articlesListProvider: MoyaProvider<ArticlesListService>
    private var realm: Realm
    private var isRechable = BehaviorRelay<Bool>(value: false)
    private let articles = BehaviorRelay<[Article]>(value: [])
    private var fetchStatus: FetchStates = .none
    private let alertMessage = PublishSubject<AlertMessage>()
    
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
    }
    
    private func loadArticles() {
        guard let localItems = realm.objects(Article.self).sorted(byKeyPath: Article.CodingKeys.title.rawValue, ascending: false).array else {
            return
        }
        articles.accept(localItems)
    }
    
    private func fetchArticles() {
        if fetchStatus != .willFetch {
            return
        }
        
        fetchStatus = .fetching
        articlesListProvider.request(.init(), completion: { result in
            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    do {
                        let fetchedItems = try JSONDecoder().decode([Article].self, from: filteredResponse.data, keyPath: "results")

                        try? self.realm.write {
                            self.realm.add(fetchedItems, update: .modified)
                        }

                        let data = fetchedItems
                        self.articles.accept(data)

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

