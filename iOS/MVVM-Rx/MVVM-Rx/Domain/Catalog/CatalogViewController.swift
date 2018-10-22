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
        let tableView = UITableView(viewModel: self.viewModel, frame: self.view.bounds, datasource: self.tableDataSource, delegate: self.tableDataSource)
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
        bindViewControllerInput(input: viewModel.input)
        bindViewModelOutput(output: viewModel.output)
    }

    private func bindViewModelOutput(output: CatalogViewModel.ViewModelOutput) {
        output.observableActors
            .map { _ in false }.startWith(true)
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)

        output.observableActors
            .do(onNext: { actors in
                self.title = "\(actors.count) Results"
            })
            .drive(onNext: { [weak self] actors in
                self?.tableDataSource.insert(actors)
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    private func bindViewControllerInput(input: CatalogViewModel.ViewInput) {
        let onViewWillAppear = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        let onTableViewRefresh = tableView.refreshControl!.rx.controlEvent(.valueChanged)
            .asDriver()
        Driver.merge(onViewWillAppear, onTableViewRefresh)
            .drive(input.onRefreshTriggered)
            .disposed(by: disposeBag)
    }
}


