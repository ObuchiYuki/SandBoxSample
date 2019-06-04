//
//  TS.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

protocol TSLevelDelegate:class {
    func didPlaceBlock(at anchor:TSVector3)
    func didDestoryBlock(at anchor:TSVector3)
}

/**
 次元の抽象化クラスです。
 */
class TSLevel {
    
    /// 地上の場所を表します。
    static let ground = TSLevel()
    
    weak var delagate:TSLevelDelegate?
    
    // ==============================================================================
    // MARK: - Private Property -
    
    /// 次元のマップです。各元に 0 〜 65535 のサイズを持ちます。
    /// これは次元の座標と異なります。編集は直接でなく
    /// _getBlock(at:_) _setBlock(at:_) を用いてください。
    private lazy var _anchorBlockMap:[[[Int]]] = _constructFillMap()
    
    /// ノードのマップです。作られたタイミングで、それぞれ初期化されます。
    private lazy var _nodemap:[[[SCNNode?]]] = _constructNodeMap()
    
    /// ブロックのアンカー（原点）のマップです。
    /// 画面に配置する場合これをmapしてください。
    private lazy var _anchormap = Set<TSVector3>()
    
    // ==============================================================================
    // MARK: - Public Methods -
    
    /// オブジェクトのSCNNodeを返します。空気の場合はnilを返します。
    func getBlockNode(at point:TSVector3) -> SCNNode? {
        let (x, y, z) = _convertVectorToIndex(point)
        let block = TSBlock.block(for: _anchorBlockMap[x][y][z])
        let blockNode = _nodemap[x][y][z]
        
        if let blockNode = blockNode { //すでに生成済みならば
            
            return blockNode
        } else if block.isAir { //空気ならば
            
            return nil
        } else {  //未生成ならば生成
            let newNode = block.createNode()
            _nodemap[x][y][z] = newNode
            
            return newNode
        }
    }
    
    /// オブジェクトのTSBlockを返します。
    func getBlock(at point:TSVector3) -> TSBlock{
        
        return _getBlock(at: point)
    }
    func getAnchors() -> [TSVector3]{
        
        return Array(_anchormap)
    }
    /// ブロックを設置します。
    /// 設置できない場合は設置しません。canPlaceBlock(at:_)で調べてから使用してください。
    public func placeBlock(_ block:TSBlock, at anchor:TSVector3) {
        // TODO: - fillmapを確認する
        guard canPlaceBlock(block, at: anchor) else {
            return debugPrint("Cannot place block at \(anchor). Check if can place block with canPlaceBlock.")
        }
        let oldBlock = _getBlock(at: anchor)
        // 破壊と創造
        
        oldBlock.willDestroy(at: anchor)
        block.willPlaced(at: anchor)
        
        _setBlock(block, at: anchor)
        
        delagate?.didDestoryBlock(at: anchor)
        delagate?.didPlaceBlock(at: anchor)
        
        oldBlock.didDestroy(at: anchor)
        block.didPlaced(at: anchor)
    }
    
    /// ブロックが置けるかどうかを確かめます。
    public func canPlaceBlock(_ block:TSBlock,at point:TSVector3) -> Bool {
        let oldBlock = _getBlock(at: point)
        return block.canPlace(at: point) && oldBlock.canDestroy(at: point)
    }
    
    /// ブロックを破壊します。
    /// 破壊できない場合は破壊しません。canDestoryBlock(at:_)で調べてから使用してください。
    public func destroyBlock(at point:TSVector3) {
        _anchormap.remove(point)
        placeBlock(.air, at: point)
    }
    
    /// ブロックが破壊できるかどうかを確かめます。
    public func canDestoryBlock(at point:TSVector3) -> Bool {
        return canPlaceBlock(.air, at: point)
    }
    // ==============================================================================
    // MARK: - Private Methods -
    
    /// マスのブロックを返します。
    private func _getBlock(at point:TSVector3) -> TSBlock {
        let (x, y, z) = _convertVectorToIndex(point)
        let index = _anchorBlockMap[x][y][z]
        return TSBlock.block(for: index)
    }
    
    private func _setBlock(_ block:TSBlock, at point:TSVector3) {
        let (x, y, z) = _convertVectorToIndex(point)
        _anchormap.insert(point)
        _anchorBlockMap[x][y][z] = block.index
    }
    
    private func _convertVectorToIndex(_ v:TSVector3) -> (x:Int, y:Int, z:Int) {
        let modefier = 32768
        return (v.x + modefier, v.y + modefier, v.z + modefier)
    }
    
    private func _constructNodeMap() -> [[[SCNNode?]]]{
        let size = Int(UInt16.max)
        return Array(repeating:Array(repeating:Array(repeating: nil, count: size), count: size), count: size)
    }
    private func _constructFillMap() -> [[[Int]]]{
        let size = Int(UInt16.max)
        return Array(repeating:Array(repeating:Array(repeating: 0, count: size), count: size), count: size)
    }
    private func _constructAnchorMap() -> [[[Int]]]{
        let size = Int(UInt16.max)
        return Array(repeating:Array(repeating:Array(repeating: 0, count: size), count: size), count: size)
    }
}
