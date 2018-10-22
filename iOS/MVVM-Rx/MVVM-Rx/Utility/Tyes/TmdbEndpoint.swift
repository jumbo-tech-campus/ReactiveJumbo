//
//  TmdbEndpoint.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 19/10/2018.
//  Copyright © 2018 Jumbo. All rights reserved.
//

import Foundation

enum TmdbEndpoint: String {
    case popularMovies = "/movie/popular"
    case popularActors = "/person/popular"

    static let baseUrlString = "https://api.themoviedb.org/3"
    static let apiKey = "91e3a1fc957cde9192fede75cedb96e2"

    var url: URL {
        return TmdbEndpoint.constructUrl(baseUrlString: TmdbEndpoint.baseUrlString, pathString: self.rawValue)
    }

    static func imageUrl(pathString: String, size: ImageSize) -> URL {
        return URL(string: "https://image.tmdb.org/t/p/" + size.rawValue + pathString)!
    }

    private static func constructUrl(baseUrlString: String, pathString: String, extraParams: Params = [:]) -> URL {
        let url = URL(string: baseUrlString)!.appendingPathComponent(pathString)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        var queryItems = [URLQueryItem(name: "api_key", value: TmdbEndpoint.apiKey)]
        queryItems += extraParams.compactMap { URLQueryItem(name: $0.key, value: $0.value as? String) }
        components.queryItems = queryItems

        return components.url!
    }
}

enum ImageSize: String {
    case posterSmall = "w500"
    case backdropSmall = "w780"
    case profileMedium = "w185"
}
