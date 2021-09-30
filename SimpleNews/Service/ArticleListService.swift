//
//  ArticleListService.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/21.
//

import Moya

struct ArticlesListService: TargetType {
    //country=us&category=business
    private let parameters: [String: String] = [
        "country": "us",
        "category": "business",
        "apiKey": Constants.ApiKey.key,
    ]
    
    var baseURL: URL {
        return URL(string: Constants.Url.base)!
    }
    
    var path: String {
        return Constants.Path.path
    }
    
    var method: Method {
        return .get
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json; charset=utf-8"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var sampleData: Data {
        guard let path = Bundle.main.path(forResource: "articles", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            return "".data(using: String.Encoding.utf8)!
        }
        return data
    }
}
