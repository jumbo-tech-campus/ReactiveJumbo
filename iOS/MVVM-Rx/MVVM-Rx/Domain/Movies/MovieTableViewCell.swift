//
//  MovieTableViewCell.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    static let cellId = String(describing: MovieTableViewCell.self)

    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func configure(with refinedMovie: MoviesViewModel.RefinedMovie) {
        titleLabel.text = refinedMovie.title
        
        backdropImageView.kf.setImage(with: refinedMovie.posterUrl,
                                      placeholder: UIImage(named: "placeholder"),
                                      options: [.transition(.fade(0.2))],
                                      progressBlock: { (received, total) in
                                        print(Float(received / total))},
                                      completionHandler: nil)
    }
}
