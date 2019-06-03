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
    static let air = TSBlock()
    
    /// 床（通常）(50, 10, 50)
    static let normalFloar = TSBlock(nodeNamed: "TP_normal_floar", textureNamed: "TP_normal_floar")
    
    /// 日本家屋　(40, 30, 20)
    static let japaneseHouse = TSBlock(nodeNamed: "TP_japanese_house_1", textureNamed: "TP_japanese_house_1")
}
