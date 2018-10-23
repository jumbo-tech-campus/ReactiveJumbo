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
        toMovies(ofType: .actorMovies(selectedActor: selectedActor))
    }

    func toSimilarMovies(selectedMovie: MoviesViewModel.RefinedMovie) {
        toMovies(ofType: .similarMovies(selectedMovie: selectedMovie))
    }

    private func toMovies(ofType type: MoviesViewModel.ContentType) {
        var viewModel: MoviesViewModel

        switch type {
        case .actorMovies(selectedActor: let actor):
            viewModel = MoviesViewModel(navigator: self, contentType: .actorMovies(selectedActor: actor))
        case .similarMovies(selectedMovie: let movie):
            viewModel = MoviesViewModel(navigator: self, contentType: .similarMovies(selectedMovie: movie))
        }

        navigationController.pushViewController(MoviesViewController(viewModel: viewModel), animated: true)
    }




}
