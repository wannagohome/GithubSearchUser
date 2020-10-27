//
//  Network.swift
//  GithubSearchUser-SwiftUI
//
//  Created by Jinho Jang on 2020/10/27.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func request<T>(with url: URL) -> AnyPublisher<T, NetworkError> where T: Decodable
}

final class Network: NetworkProtocol {
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 20
        self.session = URLSession(configuration: configuration)
    }
    
    func request<T>(with url: URL) -> AnyPublisher<T, NetworkError> where T: Decodable {
        session.dataTaskPublisher(for: url)
            .mapError { .error($0.localizedDescription) }
            .flatMap(maxPublishers: .max(1)) { pair in
                Just(pair.data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { _ in .castingError }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
