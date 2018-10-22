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

    private let textFieldStringSubject = ReplaySubject<String>.create(bufferSize: 1)
    private let refreshSubject = PublishSubject<Void>()

    init() {
        let observableTextFieldString = textFieldStringSubject
            .map { "TextField Output: \($0)" }
            .asDriver(onErrorJustReturn: "")
        let observableActors = refreshSubject.flatMapLatest { _ in
            return NetworkService.getPopularActors
                .map { $0.compactMap { RefinedActor(raw: $0) } }
                .asDriver(onErrorJustReturn: [])
        }

        self.output = Output(observableTextFieldString: observableTextFieldString,
                             observableActors: observableActors.asDriver(onErrorJustReturn: []))
        self.input = Input(onTextFieldChanged: textFieldStringSubject.asObserver(),
                           onRefreshTriggered: refreshSubject.asObserver())
    }
}

extension CatalogViewModel: ReactiveFeeding {
    struct ViewInput {
        let onTextFieldChanged: AnyObserver<String>
        let onRefreshTriggered: AnyObserver<Void>
    }
    struct ViewModelOutput {
        let observableTextFieldString: Driver<String>
        let observableActors: Driver<[RefinedActor]>
    }
}

extension CatalogViewModel {
    struct RefinedActor {
        let name: String
        let profileUrl: URL
        let popularityString: String

        init(raw: Actor) {
            self.name = raw.name
            self.profileUrl = TmdbEndpoint.imageUrl(pathString: raw.profilePath, size: .profileMedium)
            self.popularityString = "Votes: \(raw.popularity)"
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
    var rowHeight: CGFloat {
        return 100.0
    }
    var isStylePlain: Bool {
        return false
    }
}
