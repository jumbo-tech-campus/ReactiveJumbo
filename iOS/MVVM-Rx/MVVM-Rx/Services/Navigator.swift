//
//  Navigator.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit

final class Navigator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toActorMovies(navigator: Navigator, selectedActor: CatalogViewModel.RefinedActor) {
        let moviesViewModel = MoviesViewModel(navigator: navigator, contentType: .actorMovies(selectedActor: selectedActor))
        let moviesViewController = MoviesViewController(viewModel: moviesViewModel)

        navigationController.pushViewController(moviesViewController, animated: true)
    }

    func toSimilarMovies(navigator: Navigator, selectedMovie: MoviesViewModel.RefinedMovie) {
        let moviesViewModel = MoviesViewModel(navigator: navigator, contentType: .similarMovies(selectedMovie: selectedMovie))
        let moviesViewController = MoviesViewController(viewModel: moviesViewModel)

        navigationController.pushViewController(moviesViewController, animated: true)
    }
}
