//
//  Ex+TSBlock.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

// TSBlockへの登録用、
// (横幅、高さ、奥行き)
extension TSBlock {
    /// 空気 (10, 10, 10)
    static let air:TSBlock = TSBlock.init()
    
    /// 床（通常）(50, 10, 50)
    static let normalFloar = TSBlock(nodeNamed: "TP_normal_floar", index: 1)
    
    static let japaneseHouse1 = TSBlock(nodeNamed: "TP_japanese_house_1", index: 2)
    
    static let japaneseHouse2 = TSBlock(nodeNamed: "TP_japanese_house_2", index: 3)
}
