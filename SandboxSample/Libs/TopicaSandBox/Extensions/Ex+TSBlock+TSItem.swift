//
//  Ex+TSBlock.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

public class TSSandboxBlockSystem {
    /// ブロックを登録してください。
    
    func registerBlocks(manager: TSBlockManager) {
        manager.registerBlock(.air)
        manager.registerBlock(.normalFloar)
        manager.registerBlock(.japaneseHouse1)
        manager.registerBlock(.japaneseHouse2)
        manager.registerBlock(.normailBuilding)
        manager.registerBlock(.normalFloar5x5)
    }
}

extension TSSandboxBlockSystem {
    static let `default` = TSSandboxBlockSystem()
    
    public func applicationDidLuanched() {
        self.registerBlocks(manager: TSBlockManager.default)
        
    }
}


// TSBlockへの登録
public extension TSBlock {
    
    /// air
    static let air:TSBlock = TSBlock.init()
    
    /// normalFloar
    static let normalFloar:TSBlock = NormalFloar(nodeNamed: "TP_normal_floar", index: 1)
    private class NormalFloar:TSBlock {
        override func canPlaceBlockOnTop(at point: TSVector3) -> Bool { return true}
        
    }
    
    /// japaneseHouse1
    static let japaneseHouse1:TSBlock = TSBlock(nodeNamed: "TP_japanese_house_1", index: 2)
    
    /// japaneseHouse2
    static let japaneseHouse2:TSBlock = TSBlock(nodeNamed: "TP_japanese_house_2", index: 3)
    
    /// normailBuilding
    static let normailBuilding:TSBlock = NormailBuilding(nodeNamed: "TP_building_1", index: 4)
    private class NormailBuilding:TSBlock {
        override func canPlaceBlockOnTop(at point: TSVector3) -> Bool { return true}
        
    }
    
    /// normalFloar5x5
    static let normalFloar5x5:TSBlock = NormalFloar5x5(nodeNamed: "TP_floar_5x5", index: 5)
    private class NormalFloar5x5:TSBlock { override func canPlaceBlockOnTop(at point: TSVector3) -> Bool { return true} }
}

// TSItemへの登録
public extension TSItem {
    static let none = TSItem(name: "", index: 0, textureNamed: "TP_nil")
    
    static let normalFloar = TSBlockItem(name: "フツウノユカ", textureNamed: "TS_none", block: .normalFloar)
    
    static let japaneseHouse1 = TSBlockItem(name: "オオキナニホンカオク", textureNamed: "TP_item_thumb_japanese_house_1", block: .japaneseHouse1)
    
    static let japaneseHouse2 = TSBlockItem(name: "チイサナニホンカオク", textureNamed: "TP_item_thumb_japanese_house_2", block: .japaneseHouse2)
    
    static let normailBuilding = TSBlockItem(name: "フツウノビル", textureNamed: "TP_item_thumb_building_1", block: .normailBuilding)
    
    static let normalFloar5x5 = TSBlockItem(name: "フツウノユカ (5x5)", textureNamed: "TS_none", block: .normalFloar5x5)
}

