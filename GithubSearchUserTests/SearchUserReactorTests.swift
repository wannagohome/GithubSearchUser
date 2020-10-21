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
        
        self.scheduler.createColdObservable([.next(0, ("a"))])
            .map { SearchUserReactor.Action.search($0) }
            .bind(to: self.reactor.action)
            .disposed(by: self.disposeBag)
        
        self.reactor.state.compactMap { $0.userList }
            .bind(to: result)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertNotNil(result.events)
        XCTAssertEqual(result.events.count, 20)
    }
}
