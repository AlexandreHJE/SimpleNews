//
//  NetworkModule.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/26.
//

import Foundation
import Cleanse
import Alamofire

struct NetworkModule: Module {
    
    static func configure(binder: SingletonBinder) {
//        binder.bind(ServerTrustPolicyManager?.self)
//            .to(value: nil)
        
        binder.bind(SessionDelegate.self)
            .to(value: SessionDelegate())
        
        binder
            .bind()
            .to(factory: URLSession.init)
        
//        binder
//            .bind(Alamofire.SessionManager.self)
//            .to(factory: SessionManager.init)
    }
    
}

