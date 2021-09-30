//
//  MainComponent.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/21.
//

import Cleanse

struct MainComponent: Cleanse.RootComponent {
    typealias Root = PropertyInjector<SceneDelegate>
    typealias Scope = Singleton
    typealias Seed = UIWindowScene

    static func configure(binder: SingletonBinder) {
        binder.include(module: UIKitModule.self)
        binder.include(module: CoreAppModule.self)
//        binder.include(module: HttpClient.Module.self)
    }
    
    static func configureRoot(binder bind: ReceiptBinder<Root>) -> BindingReceipt<Root> {
        return bind.propertyInjector(configuredWith: MainComponent.configureAppDelegateInjector)
    }
    
    static func configureAppDelegateInjector(binder bind: PropertyInjectionReceiptBinder<SceneDelegate>) -> BindingReceipt<PropertyInjector<SceneDelegate>> {
        return bind.to(injector: SceneDelegate.injectProperties)
    }
}
