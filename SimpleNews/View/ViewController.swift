//
//  ViewController.swift
//  SimpleNews
//
//  Created by Alex Hu on 2021/9/19.
//

import UIKit
import RxSwift
import RxCocoa
import Cleanse
import RealmSwift
import Moya

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        var view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UINib(nibName: cellID, bundle: nil),
                                forCellReuseIdentifier: cellID)
        return view
        
    } ()
    
    var disposeBag = DisposeBag()
    var vm: ArticlesListViewModel = ArticlesListViewModel(articlesListProvider: MoyaProvider<ArticlesListService>(), realm: try! Realm())
    let cellID: String = "ArticleCell"
    
//    init(vm: ArticlesListViewModel) {
//        self.vm = vm
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("ArticleList VC hasn't been initialized...")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
        vmCB()
    }
    
    private func setupViewModel() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        vm.onArticles.bind(to: tableView.rx.items) { tableView, _, element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID) as? ArticleCell else {
                return UITableViewCell()
            }
            
            cell.article = element
            
            return cell
        }.disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        self.tableView.estimatedRowHeight = 70
    }
    
    private func vmCB() {
        vm.onArticles
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60.0
    }
}
