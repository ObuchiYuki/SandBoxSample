//
//  TSBlockItem.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

private let kBlockItemMargin:UInt16 = 10000

public class TSBlockItem: TSItem {
    public let block:TSBlock
    
    public init(name:String, textureNamed textureName:String ,block:TSBlock) {
        self.block = block
        
        // TODO: - 自動でテクスチャ生成？ -
        super.init(name: name, index: block.index + kBlockItemMargin, textureNamed: textureName)
        
    }
}
