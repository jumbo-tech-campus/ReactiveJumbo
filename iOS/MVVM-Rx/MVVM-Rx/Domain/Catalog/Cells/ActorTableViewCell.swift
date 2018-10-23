//
//  ActorTableViewCell.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ActorTableViewCell: UITableViewCell {
    static let cellId = String(describing: ActorTableViewCell.self)
    var disposeBag: DisposeBag?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }

    func configure(with refinedActor: CatalogViewModel.RefinedActor) {
        nameLabel.text = refinedActor.name
        popularityLabel.text = refinedActor.popularityString

        profileImageView.kf.setImage(with: refinedActor.profileUrl,
                                      placeholder: UIImage(named: "placeholder"),
                                      options: [.transition(.fade(0.2))],
                                      progressBlock: { (received, total) in
                                        print(Float(received / total))},
                                      completionHandler: nil)
    }
}

extension ActorTableViewCell: CatalogViewModelBindable {
    func bind(to viewModel: CatalogViewModel) {
        let bag = DisposeBag()

        button.rx.tap
            .map { [weak self] in self?.nameLabel.text ?? "" }
            .bind(to: viewModel.input.searchTextInput)
            .disposed(by: bag)

        disposeBag = bag
    }
}
