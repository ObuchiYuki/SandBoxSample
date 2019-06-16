//
//  TSItemStack.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/**
 複数個のアイテムを管理するクラスです。
 */
public class TSItemStack {
    // ================================================================= //
    // MARK: - Public Properties -
    /// 対象のアイテムです。
    public let item:TSItem
    
    /// アイテム数です。
    public var count:Int
    
    // ================================================================= //
    // MARK: - Constructor -
    
    public init(item:TSItem, count:Int) {
        self.item = item
        self.count = count
    }
}

public extension TSItemStack {
    func appendItem(_ count:Int) {
        self.count += count
    }
    func reduceItem(_ count:Int) {
        self.count -= count
    }
}
