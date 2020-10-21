//
//  User.swift
//  GithubSearchUser
//
//  Created by Jinho Jang on 2020/10/18.
//

struct UserList: Codable {
    var totalCount: Int?
    var incompleteResults: Bool?
    var users: [User]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case users = "items"
    }
}

struct User: Codable {
    var login: String?
    var avatarURL: String?
    var url: String?
    var numberOfRepos: Int = 0

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case url
    }
}


// MARK: - Repo
struct Repo: Codable {
    var login: String?
    var publicRepos: Int?

    enum CodingKeys: String, CodingKey {
        case login
        case publicRepos = "public_repos"
    }
}
