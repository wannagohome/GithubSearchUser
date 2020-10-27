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
    func getNumberOfRepos(url: String) -> Single<Repo> {
        let sampleData = SampleData.repo.data(using: .utf8)!
        
        return Single<Repo>.create { single in
            do {
                let result = try JSONDecoder().decode(Repo.self, from: sampleData)
                single(.success(result))
            } catch {
                single(.error(NetworkError.castingError))
            }
            
            return Disposables.create{}
        }
    }
    
    func search(query: String, page: Int = 1) -> Single<[User]> {
        let sampleData = SampleData.userList.data(using: .utf8)!
        
        return Single<[User]>.create { single in
            do {
                let result = try JSONDecoder().decode(UserList.self, from: sampleData)
                single(.success(result.users ?? []))
            } catch {
                single(.error(NetworkError.castingError))
            }
            
            return Disposables.create{}
        }
    }
}
