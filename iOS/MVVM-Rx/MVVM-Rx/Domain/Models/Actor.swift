//
//  Actor.swift
//  iOS
//
//  Created by Fabijan Bajo on 18/10/2018.
//  Copyright © 2018 Jumbo. All rights reserved.
//

import Foundation

struct Actor {
    let id: Int
    let name: String
    let profilePath: String
    let popularity: Double
}

extension Actor: Decodable {
    enum ActorKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case profilePath = "profile_path"
        case popularity = "popularity"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActorKeys.self)

        self.init(id: try container.decode(Int.self, forKey: .id),
                  name: try container.decode(String.self, forKey: .name),
                  profilePath: try container.decode(String.self, forKey: .profilePath),
                  popularity: try container.decode(Double.self, forKey: .popularity))
    }
}
