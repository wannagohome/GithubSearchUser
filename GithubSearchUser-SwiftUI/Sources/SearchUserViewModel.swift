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
    private var disposables = Set<AnyCancellable>()
    
    @Published var searchText: String = ""
    @Published var userList: [User] = [User]()
    
    init(service: SearchUserService = SearchUserServiceImpl()) {
        self.service = service
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(300),
                      scheduler: DispatchQueue(label: "SearchUserViewModel"))
            .sink(receiveValue: search(with:))
            .store(in: &disposables)
        
    }
    
    func search(with str: String) {
        service.search(query: str, page: 1)
            .compactMap { $0.users }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure:
                    self.userList.removeAll()
                case .finished:
                    break
                }
            } receiveValue: { [weak self] list in
                guard let self = self else { return }
                self.userList = list
            }
            .store(in: &disposables)
    }
}
