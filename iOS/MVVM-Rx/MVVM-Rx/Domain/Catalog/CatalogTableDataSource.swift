//
//  CatalogTableDataSource.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit

class CatalogTableDataSource: NSObject {
    static let cellIds = [
        TextFieldTableViewCell.cellId,
        LabelTableViewCell.cellId,
        ActorTableViewCell.cellId
    ]

    private var actors = [CatalogViewModel.RefinedActor]()
    private let viewModel: CatalogViewModel

    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    func insert(_ actors: [CatalogViewModel.RefinedActor]) {
        self.actors = actors
    }
}

extension CatalogTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CatalogTableDataSource.cellIds.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section > 1 ? actors.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableDataSource.cellIds[indexPath.section], for: indexPath)

        (cell as? CatalogViewModelBindable)?.bind(to: viewModel)
        (cell as? ActorTableViewCell)?.configure(with: actors[indexPath.row])

        return cell
    }
}

extension CatalogTableDataSource: UITableViewDelegate {}
