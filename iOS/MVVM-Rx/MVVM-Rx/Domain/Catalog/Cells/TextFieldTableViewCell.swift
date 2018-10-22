//
//  TextFieldTableViewCell.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextFieldTableViewCell: UITableViewCell {
    static let cellId = String(describing: TextFieldTableViewCell.self)
    @IBOutlet weak var textField: UITextField!
    var disposeBag: DisposeBag?

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }
}

extension TextFieldTableViewCell: CatalogViewModelBindable {
    func bind(to viewModel: CatalogViewModel) {
        let bag = DisposeBag()

        textField.rx.text
            .orEmpty
            .bind(to: viewModel.input.onTextFieldChanged)
            .disposed(by: bag)

        disposeBag = bag
    }
}

