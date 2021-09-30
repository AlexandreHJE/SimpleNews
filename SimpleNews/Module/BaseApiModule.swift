//
//  BaseApiModule.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/26.
//

import Foundation
import Cleanse

struct BaseApiURL: Tag {
    typealias Element = URL
}

struct BaseApiURLModule: Module {
    // 這段用來控制 App 要連到哪一個後端環境 (例如去 firebase)
    static func configure(binder: Binder<Unscoped>) {
        binder
            .bind(URL.self)
            .tagged(with: BaseApiURL.self)
            .to(value: URL(string: "https://mydomain-api-cofig")!)
    }
}

