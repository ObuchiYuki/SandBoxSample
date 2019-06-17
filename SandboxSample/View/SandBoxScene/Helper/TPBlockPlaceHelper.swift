//
//  TPBlockPlaceHelper.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/16.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import RxSwift
import SceneKit

// =============================================================== //
// MARK: - TPBlockPlaceHelperDelegate -

public protocol TPBlockPlaceHelperDelegate :class{
    var nodeGenerator:TSNodeGenerator { get }
    
    func blockPlaceHelper(placeGuideNodeWith node:SCNNode, at position:TSVector3)
    func blockPlacehelper(endBlockPlacingWith node:SCNNode)
    func blockPlaceHelper(moveNodeWith node:SCNNode, to position:TSVector3)
    func blockPlaceHelper(failToFindInitialBlockPointWith node:SCNNode, to position:TSVector3)
}

// =============================================================== //
// MARK: - TPBlockPlaceHelper -

/**
 ブロック設置の補助をします。
 ジェスチャー置かれたかどうかなど。
 */
class TPBlockPlaceHelper {
    // =============================================================== //
    // MARK: - Properties -    public let targetBlock:TSBlock
    
    public weak var delegate:TPBlockPlaceHelperDelegate?

    // =============================================================== //
    // MARK: - Private Properties -
    
    // - Managing -
    /// 管理するレベルです。
    private let level = TSLevel.grobal
    
    /// 管理するブロックです。
    private let block:TSBlock
    
    /// ブロック仮設置用ノードです。
    private lazy var blockNode:SCNNode? = {
        guard block.canCreateNode() else {return nil}
        
        return block.createNode()
    }()
    
    // - Variables -
    
    private var initialPosition = TSVector3()
    private var dragStartingPosition = TSVector3()
    private var nodePosition = TSVector3()
    
    // =============================================================== //
    // MARK: - Methods -
    
    /// HitTestが終わったら、hitTestのworldCoodinateで呼びだしてください。
    func startBlockPlacing(from position:TSVector3) {
        guard let blockNode = blockNode else { return }
        guard let initialPosition = level.calculatePlacablePosition(for: block, at: position.vector2) else {
            self._calculatePlacablePositionFailture(at: position)
            return
        }
        
        self.initialPosition = initialPosition
        delegate?.blockPlaceHelper(placeGuideNodeWith: blockNode, at: initialPosition)
    }
    
    /// ドラッグが開始されたら呼び出してください。
    func dragDidStart() {
        dragStartingPosition = nodePosition
    }
    /// 画面がドラッグされたら呼びだしてください。
    func blockDidDrag(with vector:CGPoint) {
        
    }
    
    /// 編集モード完了時に呼びだしてください。
    func endBlockPlacing() {
        
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    init(delegate:TPBlockPlaceHelperDelegate, block:TSBlock) {
        self.delegate = delegate
        self.block = block
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    private func _convertToNodeMovement(from vector2:TSVector2) -> TSVector2 {
        #warning("実機検証が必要")
        
        let transform = CGAffineTransform(rotationAngle: .pi/4)
        let transformed = vector2.applying(transform)
        
        if transformed.x > transformed.y {
           return [transformed.x, 0]
        } else {
            return [0, transformed.y]
        }
    }
    
    private func _calculatePlacablePositionFailture(at position:TSVector3) {
        guard let showFailtureNode = blockNode else {return}
        
        delegate?.blockPlaceHelper(failToFindInitialBlockPointWith: showFailtureNode, to: position)
        
        showFailtureNode.runAction(_failtureAction())
    }
    
    private func _failtureAction() -> SCNAction {
        let redIlluminationAction = SCNAction.run{node in
            node.tsMaterial?.selfIllumination.contents = UIColor.red
        }
        
        let normaIlluminationAction = SCNAction.run{node in
            node.tsMaterial?.selfIllumination.contents = UIColor.black
        }
        
        let waitAction = SCNAction.wait(duration: 0.2)
        
        let sequestceAction = SCNAction.sequence([redIlluminationAction,waitAction, normaIlluminationAction, waitAction])
        let repeatAction = SCNAction.repeat(sequestceAction, count: 4)
        
        return repeatAction
    }
}
