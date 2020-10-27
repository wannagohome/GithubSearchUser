//
//  SearchUserService.swift
//  GithubSearchUser-SwiftUI
//
//  Created by Jinho Jang on 2020/10/27.
//

import Foundation
import Combine

protocol SearchUserService {
    func search(query:String, page: Int) -> AnyPublisher<[User], NetworkError>
    func getNumberOfRepos(from url: String) -> AnyPublisher<Repo, NetworkError>
}

final class SearchUserServiceImpl {
    private let network: Network
    
    init(network: Network = Network()) {
        self.network = network
    }
}

extension SearchUserServiceImpl: SearchUserService {
    func search(query: String, page: Int = 1) -> AnyPublisher<[User], NetworkError> {
        guard let url = makeSearchComponents(query: query, page: page).url else {
            return Fail(error: NetworkError.defaultError).eraseToAnyPublisher()
        }
        return self.network.request(with: url)
    }
    
    func getNumberOfRepos(from url: String) -> AnyPublisher<Repo, NetworkError> {
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.defaultError).eraseToAnyPublisher()
        }
        return self.network.request(with: url)
    }
}

private extension SearchUserServiceImpl {
    func makeSearchComponents(query: String, page: Int) -> URLComponents {
        var components = API.basicComponents
        components.path += "/users"
        components.queryItems = [
            URLQueryItem(name: "q", value: "\(query)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "20")
        ]
        
        return components
    }
}
