//
//  RMViewAnimator.swift
//  EXKit
//
//  Created by yuki on 2019/05/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

open class RMViewAnimator {
    public weak var view:UIView!
    
    public init(view:UIView) {
        self.view = view
    }
    
    public final func searchSubview<T:UIView>(of type :T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count > 0 else {return}
            view.subviews.forEach{getSubview(view: $0)}
        }
        getSubview(view: self.view)
        return all
    }
}

