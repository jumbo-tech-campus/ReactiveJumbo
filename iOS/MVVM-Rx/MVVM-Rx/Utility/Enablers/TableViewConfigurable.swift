//
//  ReactiveTransforming.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 17/10/2018.
//  Copyright © 2018 Jumbo. All rights reserved.
//

import UIKit

protocol TableViewConfigurable {
    var tableCellRegisterInfo: [CellRegisterInfo] { get }
    var rowHeight: CGFloat { get }
    var tableHeaderHeight: CGFloat { get }
    var tableFooterHeight: CGFloat { get }
    var sectionHeaderHeight: CGFloat { get }
    var sectionTopTableInset: CGFloat { get }
    var sectionLeftTableInset: CGFloat { get }
    var sectionBottomTableInset: CGFloat { get }
    var sectionRightTableInset: CGFloat { get }
    var allEqualTableInset: CGFloat { get }
    var isStylePlain: Bool { get }
}

extension TableViewConfigurable {
    var rowHeight: CGFloat { return 44.0 }
    var tableHeaderHeight: CGFloat { return 0.0 }
    var tableFooterHeight: CGFloat { return 0.0 }
    var sectionHeaderHeight: CGFloat { return 0.0 }
    var sectionTopTableInset: CGFloat { return 0.0 }
    var sectionLeftTableInset: CGFloat { return 0.0 }
    var sectionBottomTableInset: CGFloat { return 0.0 }
    var sectionRightTableInset: CGFloat { return 0.0 }
    var allEqualTableInset: CGFloat { return 0.0 }
    var isStylePlain: Bool { return true }
}
