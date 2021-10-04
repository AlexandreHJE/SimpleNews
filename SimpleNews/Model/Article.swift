//
//  Article.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/21.
//

import Foundation
import RealmSwift

struct NewsResults: Decodable {
    let articles: [Article]
    enum CodingKeys: String, CodingKey {
        case articles
    }
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        let articles = try value.decode([Article].self, forKey: .articles)
        self.articles = articles
    }
}

class Article: Object, Decodable {
    @objc dynamic var title: String = ""
    @objc dynamic var thumbnailUrl: String = ""
    
    override class func primaryKey() -> String? {
        return "thumbnailUrl"
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case thumbnailUrl = "urlToImage"
    }
    
    override init() {
        super.init()
    }
    
    convenience init(title: String, thumbnailUrl: String) {
        self.init()
        self.title = title
        self.thumbnailUrl = thumbnailUrl
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let title = try values.decode(String.self, forKey: .title)
        let thumbnailUrl = try values.decode(String.self, forKey: .thumbnailUrl)
        self.init(title: title, thumbnailUrl: thumbnailUrl)
        
    }
}
