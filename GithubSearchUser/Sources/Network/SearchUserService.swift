//
//  SearchUserService.swift
//  GithubSearchUser
//
//  Created by Jinho Jang on 2020/10/18.
//

import Foundation
import Alamofire
import RxSwift

protocol SearchUserService {
    func search(query: String, page: Int) -> Single<[User]>
    func getNumberOfRepos(url: String) -> Single<Repo>
}

final class SearchUserServiceImpl: SearchUserService {
    private let session: Session
    
    init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.httpMaximumConnectionsPerHost = 20
        session = Session(configuration: configuration)
    }
    
    func search(query: String, page: Int = 1) -> Single<[User]> {
        let url = "https://api.github.com/search/users"
        
        return Single<[User]>.create { [weak self] single in
            self?.session.request(url, method: .get, parameters: ["q":query, "page":page, "per_page":20])
                .validate(statusCode: 200 ..< 300)
                .responseData { data in
                    do {
                        if let data = data.data {
                            let result = try JSONDecoder().decode(UserList.self, from: data)
                            single(.success(result.users ?? []))
                        } else {
                            single(.error(NetworkError.defaultError))
                        }
                    } catch {
                        single(.error(NetworkError.castingError))
                    }   
                }
            return Disposables.create{}
        }
    }
    
    func getNumberOfRepos(url: String) -> Single<Repo> {
        return Single<Repo>.create { [weak self] single in
            self?.session.request(url)
                .validate(statusCode: 200 ..< 300)
                .responseData { data in
                    do {
                        if let data = data.data {
                            let result = try JSONDecoder().decode(Repo.self, from: data)
                            single(.success(result))
                        } else {
                            single(.error(NetworkError.defaultError))
                        }
                    } catch {
                        single(.error(NetworkError.castingError))
                    }
                }
            return Disposables.create{}
        }
    }
}
