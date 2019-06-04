//
//  TSBlock.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

/**
 SandBoxにおけるオブジェクトを管理するクラスです。
 各オブジェクトに対して生成される`TSBlock` のインスタンスは1つのみとします。
 
 --実装方法--
 
 なんのイベントもないブロックの場合、そのまま`init(nodeNamed:_, textureNamed:_)`を使って初期化し、登録してください。
 イベントを持つブロックの場合、継承しメソッドをオーバーライドしてください。
 */
open class TSBlock {
    //========================================================================
    // MARK: - TSBlock Public Properties -
    /// `TSBlock`のidetifierです。
    /// 通常はファイル名で初期化されます。
    public let identifier:String
    
    /// 空気かどうかです。
    public let isAir:Bool
    
    /// Sandbox座標系におけるアイテムのサイズです。
    public lazy var size:TSVector3 = {
        if isAir { return .unit }
        
        return TSVector3(self.createNode().size)
    }()
    
    //========================================================================
    // MARK: - TSBlock Private Properties -
    private let _textureName:String
    
    //========================================================================
    // MARK: - TSBlock Public Methods -
    public func createNode() -> SCNNode {
        // 空気は実態化できない
        assert(!isAir, "TP_Air have no node to render.")
        
        // ノード生成
        guard let node = SCNNode(named: identifier) else {
            fatalError("No scn file named \"\(identifier).scn\" found.")
        }
        
        // マテリアル生成
        let material = _TSNodeMaterialProvider.default.material(textureNamed: _textureName)
        node.childNodes.forEach{
            $0.geometry?.materials = [material]
        }
        return node
    }
    
    //==================================
    // MARK: - TSBlock Overridable Methods -
    
    open func willPlaced(at point:TSVector3) {}
    open func didPlaced(at point:TSVector3) {}
    open func canPlace(at point:TSVector3) -> Bool {return true}

    open func willDestroy(at point:TSVector3) {}
    open func didDestroy(at point:TSVector3) {}
    open func canDestroy(at point:TSVector3) -> Bool {return true}
    
    open func didTouch(at point:TSVector3) {}
    open func shouldShrinkAnimateWhenTouched(at point:TSVector3) -> Bool {return false}
    
    open func didNearBlockUpdate(_ nearBlock:TSBlock, at point:TSVector3) {}
    open func didRandomEventRoopCome(at point:TSVector3) {}
    
    //========================================================================
    // MARK: - TSBlock Constructor -
    init(nodeNamed nodeName:String, textureNamed textureName:String) {
        self.identifier = nodeName
        self.isAir = false
        self._textureName = textureName
    }
    init() {
        self.identifier = "TP_Air"
        self.isAir = true
        self._textureName = "none"
    }
}

// ================================================================
// MARK: - _TSNodeMaterialProvider (Private Class) -
private class _TSNodeMaterialProvider {
    static let `default` = _TSNodeMaterialProvider()
    
    func material(textureNamed name:String) -> SCNMaterial {
        guard let texture = UIImage(named: name) else {
            fatalError("Cannot find image named \"\(name)\"")
        }
        let material = SCNMaterial()
        
        let program = SCNProgram()
        program.fragmentFunctionName = "TSFragment"
        program.vertexFunctionName = "TSVertex"
        
        material.program = program
        
        let imageProperty = SCNMaterialProperty(contents: texture)
        material.setValue(imageProperty, forKey: "diffuseTexture")
        
        return material
    }
}
