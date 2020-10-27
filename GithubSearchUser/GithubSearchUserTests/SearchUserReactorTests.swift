//
//  SearchUserReactorTests.swift
//  GithubSearchUserTests
//
//  Created by Jinho Jang on 2020/10/21.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import GithubSearchUser

class SearchUserReactorTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private var service: SearchUserServiceStub!
    private var reactor: SearchUserReactor!
    private var scheduler: TestScheduler!
    
    override func setUp() {
        defer { self.reactor = SearchUserReactor(self.service) }
        self.service = SearchUserServiceStub()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    func testSearchAction() {
        let result = self.scheduler.createObserver([User].self)
        let resultCount = self.scheduler.createObserver(Int.self)
        
        self.scheduler.createColdObservable([.next(0, ("a"))])
            .map { SearchUserReactor.Action.search($0) }
            .bind(to: self.reactor.action)
            .disposed(by: self.disposeBag)
        
        self.reactor.state.compactMap { $0.userList }
            .bind(to: result)
            .disposed(by: self.disposeBag)
        
        self.reactor.state.compactMap { $0.userList?.count }
            .distinctUntilChanged()
            .bind(to: resultCount)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(result.events.count, 21)
        XCTAssertEqual(resultCount.events, [.next(0, 20)])
    }
    
    func testLoadNextPageAction() {
        let result = self.scheduler.createObserver([User].self)
        let resultCount = self.scheduler.createObserver(Int.self)
        
        self.scheduler.createColdObservable([.next(0, ("a"))])
            .map { SearchUserReactor.Action.search($0) }
            .bind(to: self.reactor.action)
            .disposed(by: self.disposeBag)
        
        self.scheduler.createColdObservable([.next(10, ())])
            .map { _ in SearchUserReactor.Action.loadNextPage }
            .bind(to: self.reactor.action)
            .disposed(by: self.disposeBag)
        
        self.reactor.state.compactMap { $0.userList }
            .bind(to: result)
            .disposed(by: self.disposeBag)
        
        self.reactor.state.compactMap { $0.userList?.count }
            .distinctUntilChanged()
            .bind(to: resultCount)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(result.events.count, 44)
        XCTAssertEqual(resultCount.events, [.next(0, 20),
                                            .next(10, 40)])
    }
}
