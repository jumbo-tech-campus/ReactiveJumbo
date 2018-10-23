//
//  CatalogTableDataSource.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

import UIKit

class CatalogTableDataSource: NSObject {
    enum Section: Int {
        case textField = 0, label, actor, total
        var cellId: String {
            switch self {
            case .textField: return TextFieldTableViewCell.cellId
            case .label: return LabelTableViewCell.cellId
            case .actor: return ActorTableViewCell.cellId
            case .total: return ""
            }
        }

        var title: String {
            switch self {
            case .textField: return "textField.text -> searchTextSubject-input"
            case .label: return "searchTextSubject-output -> label.text"
            case .actor: return "viewWilAppear & pullRefresh -> refreshSubject"
            case .total: return ""
            }
        }
    }

    private var actors = [CatalogViewModel.RefinedActor]()
    private let viewModel: CatalogViewModel

    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    var actorsCount: Int {
        return actors.count
    }
    func insert(_ actors: [CatalogViewModel.RefinedActor]) {
        self.actors = actors
    }
}

extension CatalogTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.total.rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }

        return section.rawValue > 1 ? actors.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section)  else {
                return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellId, for: indexPath)

        (cell as? CatalogViewModelBindable)?.bind(to: viewModel)
        (cell as? ActorTableViewCell)?.configure(with: actors[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  Section(rawValue: section)?.title
    }
}
