//
//  NetworkError.swift
//  GithubSearchUser-SwiftUI
//
//  Created by Jinho Jang on 2020/10/27.
//
import Foundation

enum NetworkError: Error {
    case error(String)
    case defaultError
    case castingError
    
    var message: String? {
        switch self {
        case let .error(message):
            return message
        case .defaultError:
            return "Network Error"
        case .castingError:
            return "Casting Error"
        }
    }
}
