//
//  ReactiveTransforming.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 17/10/2018.
//  Copyright © 2018 Jumbo. All rights reserved.
//

import Foundation

struct ResultsWrapper<T: Decodable> {
    let totalResults: Int
    let totalPages: Int
    let results: [T]
}

extension ResultsWrapper: Decodable {
    enum ResultsKeys: String, CodingKey {
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultsKeys.self)
        let totalResults = try container.decode(Int.self, forKey: .totalResults)
        let totalPages = try container.decode(Int.self, forKey: .totalPages)
        let results: [T] = try container.decode([T].self, forKey: .results)

        self.init(totalResults: totalResults, totalPages: totalPages, results: results)
    }
}

