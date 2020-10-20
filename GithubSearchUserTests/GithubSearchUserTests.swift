//
//  GithubSearchUserTests.swift
//  GithubSearchUserTests
//
//  Created by Jinho Jang on 2020/10/17.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import GithubSearchUser

class SearchUserServiceTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private var service: SearchUserServiceStub!
    private var scheduler: TestScheduler!
    
    override func setUp() {
        self.service = SearchUserServiceStub()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    func testSearchUser () {
        let result = self.scheduler.createObserver(UserList.self)
        
        self.scheduler.createColdObservable([.next(0, ("a"))])
            .flatMapLatest(self.service.search)
            .bind(to: result)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        XCTAssertNotNil(result.events)   
    }
}
