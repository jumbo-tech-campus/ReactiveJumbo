//
//  Navigator.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit

final class Navigator {
    private let window: UIWindow?
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.window = window
        self.navigationController = navigationController
    }

    @discardableResult
    func appEntry() -> Bool {
        let catalogViewController = CatalogViewController(viewModel: CatalogViewModel(navigator: self))
        navigationController.setViewControllers([catalogViewController], animated: false)

        window?.rootViewController = navigationController

        window?.makeKeyAndVisible()

        return true
    }

    func toActorMovies(selectedActor: CatalogViewModel.RefinedActor) {
        let moviesViewModel = MoviesViewModel(navigator: self, contentType: .actorMovies(selectedActor: selectedActor))
        let moviesViewController = MoviesViewController(viewModel: moviesViewModel)

        navigationController.pushViewController(moviesViewController, animated: true)
    }

    func toSimilarMovies(selectedMovie: MoviesViewModel.RefinedMovie) {
        let moviesViewModel = MoviesViewModel(navigator: self, contentType: .similarMovies(selectedMovie: selectedMovie))
        let moviesViewController = MoviesViewController(viewModel: moviesViewModel)

        navigationController.pushViewController(moviesViewController, animated: true)
    }
}
