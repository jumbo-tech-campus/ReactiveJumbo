//
//  ReactiveTransforming.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 17/10/2018.
//  Copyright © 2018 Jumbo. All rights reserved.
//

import Foundation

struct CellRegisterInfo {
    let cellClass: AnyClass
    let reuseId: String
    let isXib: Bool

    init(cellClass: AnyClass, reuseId: String = "", isXib: Bool) {
        self.cellClass = cellClass
        if reuseId.isEmpty {
            self.reuseId = String(describing: cellClass)
        } else {
            self.reuseId = reuseId
        }
        self.isXib = isXib
    }
}
