//
//  TS.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

/**
 次元の抽象化クラスです。
 */
class TSLevel {
    // ==============================================================================
    // MARK: - Private Property -
    
    /// 次元のマップです。各元に 0 〜 65535 のサイズを持ちます。
    /// これは次元の座標と異なります。編集は直接でなく
    /// _getBlock(at:_) _setBlock(at:_) を用いてください。
    private lazy var _map = _constructMap()
    
    /// ノードのマップです。作られたタイミングで、それぞれ初期化されます。
    private lazy var _nodemap = _constructNodeMap()
    
    /// ブロックのアンカー（原点）のマップです。
    /// 画面に配置する場合これをmapしてください。
    private lazy var _anchormap = [ESVector3]()
    
    // ==============================================================================
    // MARK: - Public Methods -
    
    /// オブジェクトのSCNNodeを返します。空気の場合はnilを返します。
    func getBlockNode(at point:ESVector3) -> SCNNode? {
        let (x, y, z) = _convertVectorToIndex(point)
        let block = _map[x][y][z]
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
    func getBlock(at point:ESVector3) -> TSBlock{
        
        return _getBlock(at: point)
    }
    func getAnchors() -> [ESVector3]{
        
        return _anchormap
    }
    /// ブロックを設置します。
    /// 設置できない場合は設置しません。canPlaceBlock(at:_)で調べてから使用してください。
    public func placeBlock(_ block:TSBlock, at point:ESVector3) {
        guard canPlaceBlock(block, at: point) else {
            return debugPrint("Cannot place block at \(point). Check if can place block with canPlaceBlock.")
        }
        let oldBlock = _getBlock(at: point)
        // 破壊と創造
        
        oldBlock.willDestroy(at: point)
        block.willPlaced(at: point)
        
        _setBlock(block, at: point)
        
        oldBlock.didDestroy(at: point)
        block.didPlaced(at: point)
    }
    
    /// ブロックが置けるかどうかを確かめます。
    public func canPlaceBlock(_ block:TSBlock,at point:ESVector3) -> Bool {
        let oldBlock = _getBlock(at: point)
        return block.canPlace(at: point) && oldBlock.canDestroy(at: point)
    }
    
    /// ブロックを破壊します。
    /// 破壊できない場合は破壊しません。canDestoryBlock(at:_)で調べてから使用してください。
    public func destroyBlock(at point:ESVector3) {
        
        placeBlock(.air, at: point)
    }
    
    /// ブロックが破壊できるかどうかを確かめます。
    public func canDestoryBlock(at point:ESVector3) -> Bool {
        return canPlaceBlock(.air, at: point)
    }
    // ==============================================================================
    // MARK: - Private Methods -
    
    /// マスのブロックを返します。
    private func _getBlock(at point:ESVector3) -> TSBlock {
        let (x, y, z) = _convertVectorToIndex(point)
        return _map[x][y][z]
    }
    
    private func _setBlock(_ block:TSBlock, at point:ESVector3) {
        _anchormap.append(point)
        _fillMap(with: block, from: point)
    }
    private func _fillMap(with block:TSBlock, from point:ESVector3) {
          let (x, y, z) = _convertVectorToIndex(point)
        let bsize = block.size
        for xIndex in 0...bsize.x {
            for yIndex in 0...bsize.y {
                for zIndex in 0...bsize.z {
                    _map[x + xIndex][y + yIndex][z + zIndex] = block
                }
            }
        }
    }
    private func _convertVectorToIndex(_ vector:ESVector3) -> (x:Int, y:Int, z:Int) {
        let r = vector + ESVector3.unit * 32768
        return (r.x, r.y, r.z)
    }
    
    private func _constructNodeMap() -> [[[SCNNode?]]]{
        let size = Int(UInt16.max)
        return Array(repeating:Array(repeating:Array(repeating: nil, count: size), count: size), count: size)
    }
    private func _constructMap() -> [[[TSBlock]]]{
        let size = Int(UInt16.max)
        return Array(repeating:Array(repeating:Array(repeating: TSBlock.air, count: size), count: size), count: size)
    }
    private func _constructAnchorMap() -> [[[TSBlock?]]]{
        let size = Int(UInt16.max)
        return Array(repeating:Array(repeating:Array(repeating: nil, count: size), count: size), count: size)
    }
}
