//
//  ViewModelBindable.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 22/10/2018.
//  Copyright © 2018 Fabijan Bajo. All rights reserved.
//

protocol ViewModelBindable {
    associatedtype ViewModel

    func bind(to viewModel: ViewModel)
}
