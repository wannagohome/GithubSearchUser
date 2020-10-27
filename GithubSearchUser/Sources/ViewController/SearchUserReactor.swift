//
//  SearchUserReactor.swift
//  GithubSearchUser
//
//  Created by Jinho Jang on 2020/10/20.
//

import ReactorKit

final class SearchUserReactor: Reactor {
    let disposeBag = DisposeBag()
    let service: SearchUserService
    var initialState = State()
    
    init(_ service: SearchUserService = SearchUserServiceImpl()) {
        self.service = service
    }
    
    enum Action {
        case search(String)
        case loadNextPage
    }
    
    enum Mutation {
        case setSearchText(String)
        case setUserList([User])
        case setNumberOfRepos(Repo)
        case setLoadingNextPage(Bool)
        case appendUserList([User])
    }
    
    struct State {
        var userList: [User]?
        var searchText: String?
        var page: Int = 1
        var isLoadingNextPage: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let str):
            let search = self.service.search(query: str, page: 1)
            return Observable.just(Mutation.setSearchText(str))
                .concat(
                    search
                        .asObservable()
                        .map { Mutation.setUserList($0) }
                    
                )
                .concat(search
                            .asObservable()
                            .flatMap { Observable.from($0) }
                            .compactMap { $0.url }
                            .flatMap(self.service.getNumberOfRepos)
                            .map { Mutation.setNumberOfRepos($0) }
                )
            
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let searchText = self.currentState.searchText else { return Observable.empty() }
            let search = self.service.search(query: searchText, page: self.currentState.page)
                .asObservable()
                .filter { !$0.isEmpty }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                search.map { Mutation.appendUserList($0) },
                search.flatMap { Observable.from($0) }
                    .compactMap { $0.url }
                    .flatMap(self.service.getNumberOfRepos)
                    .map { Mutation.setNumberOfRepos($0) },
                Observable.just(Mutation.setLoadingNextPage(false)),
            ])   
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSearchText(let str):
            newState.searchText = str
            newState.page = 1
        case .setUserList(let list):
            newState.userList = list
            newState.page += 1
        case .setNumberOfRepos(let repo):
            for (index, user) in (newState.userList ?? []).enumerated() {
                if user.login == repo.login {
                    newState.userList?[index].numberOfRepos = repo.publicRepos!
                }
            }
        case .setLoadingNextPage(let bool):
            newState.isLoadingNextPage = bool
        case .appendUserList(let list):
            newState.userList?.append(contentsOf: list)
            newState.page += 1
        }
        
        return newState
    }
}
