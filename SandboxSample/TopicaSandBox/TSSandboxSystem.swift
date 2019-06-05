//
//  TSSandboxSystem.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSSandboxSystem {
    /// ブロックを登録してください。
    
    func registerBlocks(manager: TSBlockManager) {
        manager.registerBlock(TSBlock.air)
        manager.registerBlock(TSBlock.normalFloar)
        manager.registerBlock(TSBlock.japaneseHouse1)
        manager.registerBlock(TSBlock.japaneseHouse2)
    }
}

extension TSSandboxSystem {
    static let `default` = TSSandboxSystem()
    
    public func applicationDidLuanched() {
        self.registerBlocks(manager: TSBlockManager.default)
        
    }
}
