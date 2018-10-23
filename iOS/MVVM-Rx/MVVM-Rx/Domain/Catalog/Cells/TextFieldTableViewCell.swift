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
    var disposeBag: DisposeBag?
    
    @IBOutlet weak var textField: UITextField!

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
            .bind(to: viewModel.input.searchTextInput)
            .disposed(by: bag)

        disposeBag = bag
    }
}

