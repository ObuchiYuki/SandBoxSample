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
    // =============================================================== //
    // MARK: - TSBlock Public Properties -
    /// `TSBlock`のidetifierです。
    
    /// 通常はファイル名で初期化されます。
    public let identifier:String
    public let index:UInt16
    
    /// 空気かどうかです。
    public let isAir:Bool
    
    /// Sandbox座標系におけるアイテムのサイズです。
    public lazy var size:TSVector3 = _calculateSize()
    // =============================================================== //
    // MARK: - Private Properties -
    private lazy var _originalNode:SCNNode! = _createNode()
    
    // =============================================================== //
    // MARK: - Methods -
    public func canCreateNode() -> Bool {
        return !isAir
    }
    public func createNode() -> SCNNode {
        assert(self.canCreateNode(), "TP_Air cannot create SCNNode.")
        return _originalNode.clone()
    }
    
    // ============================= //
    // MARK: - TSBlock Overridable Methods -
    
    open func willPlace(at point:TSVector3) {}
    open func didPlaced(at point:TSVector3) {}
    open func canPlace(at point:TSVector3) -> Bool {return true}

    open func willDestroy(at point:TSVector3) {}
    open func didDestroy(at point:TSVector3) {}
    open func canDestroy(at point:TSVector3) -> Bool {return true}
    
    open func didTouch(at point:TSVector3) {}
    open func shouldShrinkAnimateWhenTouched(at point:TSVector3) -> Bool {return false}
    
    open func canPlaceBlockOnTop(at point:TSVector3) -> Bool {return isAir}
    
    open func didNearBlockUpdate(_ nearBlock:TSBlock, at point:TSVector3) {}
    open func didRandomEventRoopCome(at point:TSVector3) {}
    
    // =============================================================== //
    // MARK: - Private Methods -
    private func _calculateSize() -> TSVector3 {
        if self.isAir {
            return .unit
        }
        
        let boundingBox = self._originalNode.boundingBox
        var _size = boundingBox.max - boundingBox.min
        
        // ぴったりなら足さない。
        if (_size.x.truncatingRemainder(dividingBy: 1)) > 0.1 {
            _size.x += 1
        }
        if (_size.y.truncatingRemainder(dividingBy: 1)) > 0.1 {
            _size.y += 1
        }
        if (_size.z.truncatingRemainder(dividingBy: 1)) > 0.1 {
            _size.z += 1
        }
        
        return TSVector3(_size)
    }
    
    private func _createNode() -> SCNNode {
        // 空気は実態化できない
        assert(!isAir, "TP_Air have no node to render.")
        
        // ノード生成
        guard let node = SCNNode(named: identifier) else {
            fatalError("No scn file named \"\(identifier).scn\" found.")
        }
        
        return node
    }
    
    //========================================================================
    // MARK: - Constructors -
    init(nodeNamed nodeName:String, index:UInt16) {
        self.identifier = nodeName
        self.index = index
        self.isAir = false
    }
    init() {
        self.identifier = "TP_Air"
        self.index = 0
        self.isAir = true
    }
}

public extension TSBlock {
    static func block(for index:UInt16) -> TSBlock {
        guard let block = TSBlockManager.default.block(for: index) else {
            fatalError("Error in finding TSBlock indexed \(index)")
        }
        return block
    }
    static func block(for idetifier:String) -> TSBlock {
        guard let block = TSBlockManager.default.block(for: idetifier) else {
            fatalError("Error in finding TSBlock idetified \(idetifier)")
        }
        return block
    }
}


extension TSBlock: CustomStringConvertible {
    public var description: String {
        return "TSBlock(named: \"\(identifier)\")"
    }
}
