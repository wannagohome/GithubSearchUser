//
//  UIScrollView + Ex.swift
//  GithubSearchUser
//
//  Created by Jinho Jang on 2020/10/21.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
  var isReachedBottom: ControlEvent<Void> {
    let source = self.contentOffset
      .filter { [weak base = self.base] offset in
        guard let base = base else { return false }
        return base.contentOffset.y >= (base.contentSize.height - base.frame.size.height)
      }
      .map { _ in Void() }
    return ControlEvent(events: source)
  }
}

