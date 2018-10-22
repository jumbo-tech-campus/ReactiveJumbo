//
//  MoviesViewModel.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MoviesViewModel {}

extension MoviesViewModel: ReactiveTransforming {
    struct ViewControllerInput {
        let onFetchTrigger: Driver<()>
    }

    struct ViewModelOutput {
        let observableMovies: Driver<[RefinedMovie]>
    }

    func transform(input: ViewControllerInput) -> ViewModelOutput {
        let observableMovies = input.onFetchTrigger.flatMapLatest { _ in
            return NetworkService.getPopularMovies
                .map { [weak self] in $0.compactMap { self?.refine(rawModel: $0) } }
                .asDriver(onErrorJustReturn: [])
        }

        return ViewModelOutput(observableMovies: observableMovies)
    }
}

extension MoviesViewModel: ModelRefining {
    struct RefinedMovie {
        let title: String
        let posterUrl: URL
    }

    func refine(rawModel: Movie) -> RefinedMovie {
        return RefinedMovie(title: rawModel.title, posterUrl: TmdbEndpoint.imageUrl(pathString: rawModel.backdropPath, size: .backdropSmall))
    }
}

extension MoviesViewModel: TableViewConfigurable {
    var tableCellRegisterInfo: [CellRegisterInfo] { return [CellRegisterInfo(cellClass: MovieTableViewCell.self, reuseId: MovieTableViewCell.cellId, isXib: true)] }
    var rowHeight: CGFloat { return 200.0 }
}
