//
//  SearchUserViewModel.swift
//  GithubSearchUser-SwiftUI
//
//  Created by Jinho Jang on 2020/10/28.
//

import Foundation
import Combine

final class SearchUserViewModel: ObservableObject {
    private let service: SearchUserService
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchText: String = ""
    @Published var userList: [User] = [User]()
    @Published var showingAlert: Bool = false
    @Published var errorMessage: String = ""
    
    let appearedID = PassthroughSubject<UUID?, NetworkError>()
    
    init(service: SearchUserService = SearchUserServiceImpl()) {
        self.service = service
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(300),
                      scheduler: DispatchQueue(label: "SearchUserViewModel"))
            .sink(receiveValue: search(with:))
            .store(in: &self.cancellables)
        
        let loadNextPage = appearedID
            .compactMap { cellID -> Int? in
                let lastRowCount = self.userList.count
                let lastIndex = self.userList.firstIndex { cellID == $0.id }
                guard lastRowCount - 1 == lastIndex else { return nil }
                return lastRowCount / 20 + 1
            }
            .print()
            .map { (self.searchText, $0) }
            .eraseToAnyPublisher()
        
        loadNextPage
            .flatMap(self.service.search)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handelError,
                  receiveValue: { userList in
                self.userList += userList.users ?? []
            })
            .store(in: &self.cancellables)

        
    }
    
    func search(with str: String) {
        let search = self.service.search(query: str, page: self.currentPage)
            .compactMap { $0.users }
            .eraseToAnyPublisher()
        
        search
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: handelError,
                   receiveValue: { [weak self] list in
                guard let self = self else { return }
                self.userList = list
            })
            .store(in: &self.cancellables)
        
        $userList
            .compactMap { $0.compactMap { $0.url } }
            .flatMap { $0.publisher }
            .flatMap (self.service.getNumberOfRepos(from:))
//            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: handelError,
                   receiveValue: { [weak self] repo in
                guard let self = self else { return }
                for (index, user) in self.userList.enumerated() {
                    if user.login == repo.login {
                        self.userList[index].numberOfRepos = repo.publicRepos!
                    }
                }
            })
            .store(in: &self.cancellables)
    }
    
    func handelError(completion: Subscribers.Completion<NetworkError>) {
        guard case .failure(let error) = completion else { return }
        self.userList.removeAll()
        self.showingAlert = true
        self.errorMessage = error.message ?? "Error"
    }
}
