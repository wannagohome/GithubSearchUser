//
//  API.swift
//  GithubSearchUser-SwiftUI
//
//  Created by Jinho Jang on 2020/10/27.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.github.com"
    static let path = "/search"
    
    static var basicComponents: URLComponents {
        get {
            var components = URLComponents()
            components.scheme = API.scheme
            components.host = API.host
            components.path = API.path
            return components
        }
    }
}
