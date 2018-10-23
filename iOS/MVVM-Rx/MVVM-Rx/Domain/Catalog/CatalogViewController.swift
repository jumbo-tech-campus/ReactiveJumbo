//
//  CatalogViewController.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CatalogViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: CatalogViewModel
    private let tableDataSource: CatalogTableDataSource
    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(viewModel: self.viewModel, frame: self.view.bounds, datasource: self.tableDataSource)
        tableView.refreshControl = UIRefreshControl()

        return tableView
    }()

    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        self.tableDataSource = CatalogTableDataSource(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        bind(to: viewModel)
    }
}

extension CatalogViewController: CatalogViewModelBindable {
    func bind(to viewModel: CatalogViewModel) {
        bindViewControllerInput(to: viewModel)
        bindViewModelOutput(from: viewModel)
    }

    private func bindViewModelOutput(from viewModel: CatalogViewModel) {
        viewModel.output.observableActors
            .map { _ in false }.startWith(true)
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.output.observableActors
            .do(onNext: { actors in self.title = "\(actors.count) Results" })
            .drive(onNext: { [weak self] actors in
                self?.tableDataSource.insert(actors)
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.output.navigateToMovies
            .drive()
            .disposed(by: disposeBag)
    }

    private func bindViewControllerInput(to viewModel: CatalogViewModel) {
        let onViewWillAppear = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
        let onTableViewRefresh = tableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()

        Observable.merge(onViewWillAppear, onTableViewRefresh)
            .bind(to: viewModel.input.refreshInput)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .asObservable()
            .bind(to: viewModel.input.moviesNavigationInput)
            .disposed(by: disposeBag)
    }
}


