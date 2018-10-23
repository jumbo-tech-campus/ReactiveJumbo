//
//  LabelTableViewCell.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LabelTableViewCell: UITableViewCell {
    static let cellId = String(describing: LabelTableViewCell.self)
    var disposeBag: DisposeBag?

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }
}

extension LabelTableViewCell: CatalogViewModelBindable {
    func bind(to viewModel: CatalogViewModel) {
        let bag = DisposeBag()

        viewModel.output.observableSearchText
            .drive(textLabel!.rx.text)
            .disposed(by: bag)

        disposeBag = bag
    }
}
