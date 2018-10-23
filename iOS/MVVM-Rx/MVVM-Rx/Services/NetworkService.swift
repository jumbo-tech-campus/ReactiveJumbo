//
//  NetworkService.swift
//  MVVM-Rx
//
//  Created by Fabijan Bajo on 18/10/2018.
//  Copyright © 2018 Jumbo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias Json = [String: AnyHashable]
typealias Params = [String: AnyHashable]

struct NetworkService {
    static var getPopularMovies: Observable<[Movie]> {
        return NetworkService.request(endpoint: .popularMovies)
    }

    static var getPopularActors: Observable<[Actor]> {
        return NetworkService.request(endpoint: .popularActors)
    }

    static func getSimilarMovies(for id: Int) -> Observable<[Movie]> {
        return NetworkService.request(endpoint: .similarMovies(id))
    }

    private static func request<T: Decodable>(endpoint: TmdbEndpoint) -> Observable<[T]> {
        return URLSession.shared.rx
            .data(request: URLRequest(url: endpoint.url))
            .map({ data -> [T] in
                print(try! JSONSerialization.jsonObject(with: data, options: []))
                return (try JSONDecoder().decode(ResultsWrapper<T>.self, from: data)).results
            })
    }
}
