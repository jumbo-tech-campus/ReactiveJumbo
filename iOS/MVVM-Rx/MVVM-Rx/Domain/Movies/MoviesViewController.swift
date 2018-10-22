//
//  MoviesViewController.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa

final class MoviesViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: MoviesViewModel
    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(viewModel: self.viewModel, frame: self.view.bounds)
        tableView.refreshControl = UIRefreshControl()

        return tableView
    }()

    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        view.addSubview(tableView)
    }
}

extension MoviesViewController: ViewModelBindable {
    func bind(to viewModel: MoviesViewModel) {
        let viewModelOutput = viewModel.transform(input: viewControllerInput)

        viewModelOutput.observableMovies
            .drive(tableView.rx.items(cellIdentifier: MovieTableViewCell.cellId, cellType: MovieTableViewCell.self)) { (index, refinedMovie, movieCell) in

                movieCell.configure(with: refinedMovie)
            }.disposed(by: disposeBag)

        viewModelOutput.observableMovies
            .map { _ in false }.startWith(true)
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModelOutput.observableMovies
            .map { "\($0.count) movies retrieved" }
            .drive(rx.title)
            .disposed(by: disposeBag)
    }

    private var viewControllerInput: MoviesViewModel.ViewControllerInput {
        let onViewWillAppear = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        let onTableViewRefresh = tableView.refreshControl!.rx.controlEvent(.valueChanged)
            .asDriver()
        let onFetchTrigger = Driver.merge(onViewWillAppear, onTableViewRefresh)

        return MoviesViewModel.ViewControllerInput(onFetchTrigger: onFetchTrigger)
    }
}
