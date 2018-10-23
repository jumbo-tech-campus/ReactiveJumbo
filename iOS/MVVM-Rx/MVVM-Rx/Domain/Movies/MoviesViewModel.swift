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

protocol MoviesViewModelBindable {
    func bind(to viewModel: MoviesViewModel)
}

final class MoviesViewModel {
    enum ContentType {
        case actorMovies(selectedActor: CatalogViewModel.RefinedActor)
        case similarMovies(selectedMovie: MoviesViewModel.RefinedMovie)
    }
    let contentType: ContentType
    let navigator: Navigator

    init(navigator: Navigator, contentType: ContentType) {
        self.navigator = navigator
        self.contentType = contentType
    }
}

extension MoviesViewModel: ReactiveTransforming {
    struct ViewControllerInput {
        let onViewWillAppear: Driver<()>
        let onCellTap: Driver<IndexPath>
    }

    struct ViewModelOutput {
        let observableMovies: Driver<[RefinedMovie]>
        let navigateToSimilarMovies: Driver<RefinedMovie>
    }

    func transform(input: ViewControllerInput) -> ViewModelOutput {
        var observableMovies: Driver<[RefinedMovie]>

        switch contentType {
        case .actorMovies(selectedActor: let refinedActor):
            observableMovies = Driver.just(refinedActor.popularMovies.map { RefinedMovie(raw: $0) })
        case .similarMovies(selectedMovie: let refinedMovie):
            observableMovies = input.onViewWillAppear.flatMapLatest { _ in
                return NetworkService.getSimilarMovies(for: refinedMovie.id)
                    .map { $0.compactMap { RefinedMovie(raw: $0) } }
                    .asDriver(onErrorJustReturn: [])
            }
        }

        let navigateToSimilarMovies = input.onCellTap
            .withLatestFrom(observableMovies) { (indexPath, refinedMovies) -> RefinedMovie in
                return refinedMovies[indexPath.row]
            }.do(onNext: { [weak self] refinedMovie in
                guard let strongSelf = self else { return }
                strongSelf.navigator.toSimilarMovies(selectedMovie: refinedMovie)
            })

        return ViewModelOutput(observableMovies: observableMovies, navigateToSimilarMovies: navigateToSimilarMovies)
    }
}

extension MoviesViewModel {
    struct RefinedMovie {
        let id: Int
        let title: String
        let posterUrl: URL

        init(raw: Movie) {
            self.id = raw.id
            self.title = raw.title
            self.posterUrl = TmdbEndpoint.imageUrl(pathString: raw.backdropPath, size: .backdropSmall)
        }
    }
}

extension MoviesViewModel: TableViewConfigurable {
    var tableCellRegisterInfo: [CellRegisterInfo] { return [CellRegisterInfo(cellClass: MovieTableViewCell.self, reuseId: MovieTableViewCell.cellId, isXib: true)] }
    var rowHeight: CGFloat { return 200.0 }
}
