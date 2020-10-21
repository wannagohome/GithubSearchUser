//
//  ViewController.swift
//  GithubSearchUser
//
//  Created by Jinho Jang on 2020/10/17.
//

import UIKit
import ReactorKit
import Kingfisher
import RxCocoa

class SearchUserViewController: UIViewController, StoryboardView {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UserCell.nib(), forCellReuseIdentifier: "UserCell")
    }
    
    func bind(reactor: SearchUserReactor) {
        self.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.search($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.isReachedBottom
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .map { Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.userList }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.tableView.rx.items) { tb, row, data in
                let cell = tb.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
                cell.user = data
                return cell
            }
            .disposed(by: self.disposeBag)
    }
}
