//
//  TSItem.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

/**
 SandBoxにおけるアイテムを表すクラスです。
 各アイテムに対してインスタンスは1つのみとします。
 
 複数個のアイテムは、TSItemStackを用いて表してください。
 */
public class TSItem {
    // ===================================================================== //
    // MARK: - Public Properties -
    
    /// アイテム名です。（今のことろ日本語）
    public let name:String
    
    /// ユニークなIndexです。（アイテム番号として使用します。）
    public let index:Int
    
    public lazy var itemImage:UIImage = {
        guard let image = UIImage(named: self._textureName) else {
            fatalError("Image named \(self._textureName) is not found in this app.")
        }
       return image
    }()
    
    // ===================================================================== //
    // MARK: - Private Properties -
    
    /// テクスチャ名です。
    private let _textureName:String
    
    // ===================================================================== //
    // MARK: - Constructor  -
    
    public init(name:String, index:Int, textureNamed textureName:String) {
        self.name = name
        self.index = index
        self._textureName = textureName
    }
}
