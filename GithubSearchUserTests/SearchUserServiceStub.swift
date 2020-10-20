//
//  SearchUserServiceStub.swift
//  GithubSearchUserTests
//
//  Created by Jinho Jang on 2020/10/19.
//

@testable import GithubSearchUser
import RxSwift
import Foundation

final class SearchUserServiceStub: SearchUserService {
    func search(query: String) -> Single<UserList> {
        let sampleData = SampleData.userList.data(using: .utf8)!
        
        return Single<UserList>.create { single in
            do {
                let result = try JSONDecoder().decode(UserList.self, from: sampleData)
                single(.success(result))
            } catch {
                single(.error(NetworkError.castingError))
            }
            
            return Disposables.create{}
        }
    }
}
