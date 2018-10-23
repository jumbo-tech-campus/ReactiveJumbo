//
//  ReactiveConnectable.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 17/10/2018.
//  Copyright © 2018 Jumbo. All rights reserved.
//

import Foundation

protocol ReactiveConnectable {
    associatedtype Input
    associatedtype Output
}

protocol ReactiveTransformable: ReactiveConnectable {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

protocol ReactiveFeedable: ReactiveConnectable {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
