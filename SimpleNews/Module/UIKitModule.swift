//
//  UIKitModule.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/21.
//

import Foundation
import Cleanse

public struct UIKitModule: Module {
    public static func configure(binder: Binder<Unscoped>) {
        binder.include(module: UIScreen.Module.self)
        binder.include(module: UIWindow.Module.self)
    }
    
}

extension UIScreen {
    public struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder
                .bind(UIScreen.self)
                .to { UIScreen.main }
        }
    }
    
}

extension UIWindow {
    public struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder
                .bind(UIWindow.self)
                .to { (rootViewController: TaggedProvider<UIViewController.Root>, windowScene: UIWindowScene) -> UIWindow in
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = rootViewController.get()
                    return window
                }
        }
    }
    
}

extension UIViewController {
    public struct Root : Tag {
        public typealias Element = UIViewController
    }
}

