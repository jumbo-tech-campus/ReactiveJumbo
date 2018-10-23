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
    private lazy var tableView = UITableView(viewModel: self.viewModel, frame: self.view.bounds)

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

extension MoviesViewController: MoviesViewModelBindable {
    func bind(to viewModel: MoviesViewModel) {
        let viewModelOutput = viewModel.transform(input: viewControllerInput)

        viewModelOutput.observableMovies
            .drive(tableView.rx.items(cellIdentifier: MovieTableViewCell.cellId, cellType: MovieTableViewCell.self)) { (index, refinedMovie, movieCell) in

                movieCell.configure(with: refinedMovie)
            }.disposed(by: disposeBag)
        
        viewModelOutput.observableMovies
            .map {
                let count = "\($0.count) Movies"
                switch viewModel.contentType {
                case .actorMovies(let actor): return "\(count) from \(actor.name)"
                case .similarMovies(let movie): return "\(count) similar to \(movie.title)"
                }
            }
            .drive(rx.title)
            .disposed(by: disposeBag)

        viewModelOutput.navigateToSimilarMovies
            .drive()
            .disposed(by: disposeBag)
    }

    private var viewControllerInput: MoviesViewModel.ViewControllerInput {
        let onViewWillAppear = rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
            .asDriver(onErrorJustReturn: ())

        return MoviesViewModel.ViewControllerInput(onViewWillAppear: onViewWillAppear, onCellTap: tableView.rx.itemSelected.asDriver())
    }
}
