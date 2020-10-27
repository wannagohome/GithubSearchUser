//
//  SearchUserViewControllerTests.swift
//  GithubSearchUserTests
//
//  Created by Jinho Jang on 2020/10/27.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import GithubSearchUser

class SearchUserViewControllerTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private var service: SearchUserServiceStub!
    private var reactor: SearchUserReactor!
    private var scheduler: TestScheduler!
    private var viewController: SearchUserViewController!
    
    override func setUp() {
        defer {
            self.reactor = SearchUserReactor(self.service)
            self.viewController.reactor = self.reactor
            self.viewController.loadViewIfNeeded()
        }
        self.service = SearchUserServiceStub()
        self.scheduler = TestScheduler(initialClock: 0)
        self.viewController = UIStoryboard(name: "SearchUser", bundle: nil)
            .instantiateViewController(withIdentifier: "SearchUserViewController") as? SearchUserViewController
    }
    
    func testSearchBar_typeText() {
        let result = self.scheduler.createObserver(String.self)
        
        self.scheduler.createColdObservable([.next(10, ("abc"))])
            .subscribe(onNext: {
                self.viewController.searchBar.text = $0
                self.viewController.searchBar.rx.text.onNext($0)
            })
            .disposed(by: self.disposeBag)
        
        self.reactor.state.compactMap { $0.searchText }
            .bind(to: result)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
//        XCTAssertEqual(result.events, [.next(10, "abc")])
    }
}
