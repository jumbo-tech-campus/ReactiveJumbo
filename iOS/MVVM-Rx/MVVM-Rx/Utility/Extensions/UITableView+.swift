import UIKit

extension UITableView {
    convenience init(viewModel: TableViewConfigurable, frame: CGRect, datasource: UITableViewDataSource? = nil, delegate: UITableViewDelegate? = nil) {
        self.init(frame: frame, style: viewModel.isStylePlain ? .plain : .grouped)

        viewModel.tableCellRegisterInfo.forEach {
            if $0.isXib {
                register(UINib(nibName: String(describing: $0.cellClass), bundle: nil), forCellReuseIdentifier: $0.reuseId)
            } else {
                register($0.cellClass, forCellReuseIdentifier: $0.reuseId)
            }
        }

        rowHeight = viewModel.rowHeight
        sectionHeaderHeight = viewModel.sectionHeaderHeight
        contentInset = UIEdgeInsets(top: viewModel.sectionTopTableInset, left: viewModel.sectionLeftTableInset, bottom: viewModel.sectionBottomTableInset, right: viewModel.sectionRightTableInset)
        self.delegate = delegate
        self.dataSource = datasource
    }
}
