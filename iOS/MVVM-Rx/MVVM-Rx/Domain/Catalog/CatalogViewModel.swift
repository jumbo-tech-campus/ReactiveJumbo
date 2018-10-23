//
//  CatalogViewModel.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CatalogViewModelBindable {
    func bind(to viewModel: CatalogViewModel)
}

final class CatalogViewModel {
    let input: ViewInput
    let output: ViewModelOutput

    private let searchTextSubject = ReplaySubject<String>.create(bufferSize: 1)
    private let refreshSubject = PublishSubject<Void>()
    private let moviesNavigationSubject = PublishSubject<IndexPath>()

    init(navigator: Navigator) {
        let observableActors = CatalogViewModel.observableActors(subject: refreshSubject)
        self.output = Output(observableSearchText: CatalogViewModel.observableSearchText(subject: searchTextSubject),
                             observableActors: observableActors,
                             navigateToMovies: CatalogViewModel.navigateToMovies(subject: moviesNavigationSubject,
                                                                                 observableActors: observableActors,
                                                                                 navigator: navigator))
        self.input = Input(searchTextInput: searchTextSubject.asObserver(),
                           refreshInput: refreshSubject.asObserver(),
                           moviesNavigationInput: moviesNavigationSubject.asObserver())
    }
}

extension CatalogViewModel: ReactiveFeeding {
    struct ViewInput {
        let searchTextInput: AnyObserver<String>
        let refreshInput: AnyObserver<Void>
        var moviesNavigationInput: AnyObserver<IndexPath>
    }
    struct ViewModelOutput {
        let observableSearchText: Driver<String>
        let observableActors: Driver<[RefinedActor]>
        let navigateToMovies: Driver<RefinedActor>
    }

    private static func observableSearchText(subject: ReplaySubject<String>) -> Driver<String> {
        return subject.map { "Search text: \($0)" }.asDriver(onErrorJustReturn: "")
    }

    private static func observableActors(subject: PublishSubject<Void>) -> Driver<[RefinedActor]> {
        return subject.flatMapLatest { _ in
            return NetworkService.getPopularActors
                .map { $0.compactMap { RefinedActor(raw: $0) } } }
            .asDriver(onErrorJustReturn: [])
    }

    private static func navigateToMovies(subject: PublishSubject<IndexPath>, observableActors: Driver<[RefinedActor]>, navigator: Navigator) -> Driver<RefinedActor> {
        return subject
            .asDriver(onErrorJustReturn: IndexPath.init())
            .withLatestFrom(observableActors) { (indexPath, refinedActors) -> RefinedActor in
                return refinedActors[indexPath.row] }
            .do(onNext: { (actor) in
                navigator.toActorMovies(navigator: navigator, selectedActor: actor)
            })
    }
}

extension CatalogViewModel {
    struct RefinedActor {
        let id: Int
        let name: String
        let profileUrl: URL
        let popularityString: String
        let popularMovies: [Movie]

        init(raw: Actor) {
            self.id = raw.id
            self.name = raw.name
            self.profileUrl = TmdbEndpoint.imageUrl(pathString: raw.profilePath, size: .profileMedium)
            self.popularityString = "Votes: \(raw.popularity)"
            self.popularMovies = raw.popularMovies ?? []
        }
    }
}

extension CatalogViewModel: TableViewConfigurable {
    var tableCellRegisterInfo: [CellRegisterInfo] {
        return [
            CellRegisterInfo(cellClass: TextFieldTableViewCell.self, reuseId: TextFieldTableViewCell.cellId, isXib: true),
            CellRegisterInfo(cellClass: LabelTableViewCell.self, reuseId: LabelTableViewCell.cellId, isXib: false),
            CellRegisterInfo(cellClass: ActorTableViewCell.self, reuseId: ActorTableViewCell.cellId, isXib: true)
        ]
    }
    var rowHeight: CGFloat { return 100.0 }
    var isStylePlain: Bool { return false }
}
