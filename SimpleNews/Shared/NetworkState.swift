//
//  NetworkState.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/30.
//

import Alamofire
import Foundation

struct NetworkState {
    var isInternetAvailable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
