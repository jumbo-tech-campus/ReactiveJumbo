//
//  ModelRefining.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 17/10/2018.
//  Copyright © 2018 Jumbo. All rights reserved.
//

import Foundation

protocol ModelRefining {
    associatedtype RawModel
    associatedtype RefinedModel

    func refine(rawModel: RawModel) -> RefinedModel
}
