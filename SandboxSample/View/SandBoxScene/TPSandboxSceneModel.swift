//
//  TPSandboxSceneModel.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/06.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa

/// ここら辺はRxSwiftの書きやすさより処理速度優先なので
protocol TPSandboxSceneModelBinder: class {
    
    // - Level -
    func __placeNode(_ block:SCNNode, at position:TSVector3)
    func __moveNode(_ node:SCNNode, to position:TSVector3)
    func __removeNode(_ node:SCNNode)
    
    // - Material -
    func __setNodeTrancparency(_ node:SCNNode, trancparency:CGFloat)
    
    // - Camera -
    func __moveCamera(to position:SCNVector3)
    func __zoomCamera(to scale:CGFloat)
    
}


class TPSandboxSceneModel {
    // ================================================================== //
    // MARK: - Properties -
    
    internal var itemBarInventory:TSItemBarInventory {
        return TSSandboxPlayerSystem.default.getPlayer().itemBarInventory
    }
    
    // =============================== //
    // MARK: - System Connection -
    
    // - Level -
    private let level = TSLevel.grobal
    internal lazy var nodeGenerator = TSNodeGenerator(level: level)
    
    // - Binders -
    private weak var binder:TPSandboxSceneModelBinder!
    
    // - Helper -
    private var blockPlaceHelper:TPBlockPlaceHelper?
    private lazy var cameraGestutreHelper = TPSandboxCameraGestureHelper(delegate: self)
    
    
    // - Variables -
    public var isPlacingBlockMode = BehaviorRelay(value: false)
    
    // ================================================================== //
    // MARK: - Methods -
    
    /// ヒットテストが終わったら呼び出してください。
    func hitTestDidEnd(at worldCoordinate:TSVector3) {
        do { // ここの直呼び出しは今後変更あるかも？
            isPlacingBlockMode.accept(true)
            
            guard let block = (itemBarInventory.selectedItemStack.item as? TSBlockItem)?.block else { return }
            
            let blockPlaceHelper = TPBlockPlaceHelper(delegate: self, block: block)
            
            self.blockPlaceHelper = blockPlaceHelper

            blockPlaceHelper.startBlockPlacing(from: worldCoordinate)
            
            
        }
    }

    
    func sceneDidLoad() {
        level.delegate = self
    
        /// 床設置
        for x in 1...5 {
            for z in 1...5 {
                let position = TSVector3(x * 5, 0, z * 5)
                guard let _position = level.calculatePlacablePosition(for: .normalFloar5x5, at: position.vector2) else { return }
                
                level.placeBlock(.normalFloar5x5, at: _position)
            }
        }
    }
    

    // ================================================================== //
    // MARK: - Private Methods -
    
    private func _placeItem(to tapPosition:TSVector3) {
        guard let blockItem = itemBarInventory.selectedItemStack.item as? TSBlockItem else { return }
        let block = blockItem.block
        let inventory = TSSandboxPlayerSystem.default.getPlayer().itemBarInventory
        
        if inventory.canUseCurrentItem() {
            guard let position = level.calculatePlacablePosition(for: block, at: tapPosition.vector2) else {
                return
            }
            
            level.placeBlock(block, at: position) // 仮置き
            inventory.useCurrentItem()
        }
    }
    // ================================================================== //
    // MARK: - Constructor -
    
    init(_ binder:TPSandboxSceneModelBinder) {
        self.binder = binder
    }
}

// ================================================================== //
// MARK: - Extension for TPBlockPlaceHelperDelegate -
extension TPSandboxSceneModel: TPBlockPlaceHelperDelegate {
    func blockPlaceHelper(placeGuideNodeWith node:SCNNode, at position:TSVector3) {
        binder.__placeNode(node, at: position)
    }
    func blockPlacehelper(endBlockPlacingWith node:SCNNode) {
        binder.__removeNode(node)
    }
    func blockPlaceHelper(moveNodeWith node:SCNNode, to position:TSVector3) {
        binder.__moveNode(node, to: position)
    }
    func blockPlaceHelper(failToFindInitialBlockPointWith node:SCNNode, to position:TSVector3) {
        binder.__placeNode(node, at: position)
    }
}

// ================================================================== //
// MARK: - Extension for TPCameraGestureHelperDelegate -
extension TPSandboxSceneModel: TPCameraGestureHelperDelegate{
    func cameraGestureHelper(_ cameraGestureHelper: TPSandboxCameraGestureHelper, cameraDidMoveTo position: SCNVector3) {
        binder.__moveCamera(to: position)
    }
    func cameraGestureHelper(_ cameraGestureHelper: TPSandboxCameraGestureHelper, cameraDidchangeZoomedTo scale: CGFloat) {
        binder.__zoomCamera(to: scale)
    }
}

// ================================================================== //
// MARK: - Extension for TSLevelDelegate -
extension TPSandboxSceneModel : TSLevelDelegate {
    func level(_ level: TSLevel, levelDidUpdateBlockAt position: TSVector3) {
        guard let node = nodeGenerator.getNode(for: position) else {return}
        
        binder.__placeNode(node, at: position)
    }
    func level(_ level: TSLevel, levelDidDestoryBlockAt position: TSVector3) {
        guard let node = nodeGenerator.getNode(for: position) else {return}
        
        binder.__removeNode(node)
    }
}
