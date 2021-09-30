//
//  Results+Ext.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/30.
//

import RealmSwift

extension Results {
    var array: [Element]? {
        return !isEmpty ? map { $0 } : nil
    }
}
