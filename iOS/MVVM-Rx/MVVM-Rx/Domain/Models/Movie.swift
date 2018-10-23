//
//  Movie.swift
//  MVVM-iOS-macOS
//
//  Created by Fabijan Bajo on 17/10/2018.
//  Copyright © 2018 Jumbo. All rights reserved.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let backdropPath: String
}

extension Movie: Decodable {
    enum MovieKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case backdropPath = "backdrop_path"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieKeys.self)

        self.init(id: try container.decode(Int.self, forKey: .id),
                  title: try container.decode(String.self, forKey: .title),
                  backdropPath: try container.decode(String.self, forKey: .backdropPath))
    }
}
