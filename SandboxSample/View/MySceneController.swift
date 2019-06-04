//
//  MySceneController.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

class MySceneController: ESSceneController {
    private let level = TSLevel()
    private lazy var gestutreHelper = _TSGestureHelper(delegate: self)
    
    func createHouse(x: Int, y:Int) {
        let position = TSVector3(x: x, y: 1, z: y)
        level.placeBlock(.japaneseHouse, at: position)
    }

    override func touchesBegan(at location: CGPoint) {
        gestutreHelper.touchBegan(at: location, with: self.cameraNode.position)
    }
    override func touchesMoved(at location: CGPoint) {
        gestutreHelper.touchMoved(to: location)
    }
    
    override func didHitTestEnd(_ results: [SCNHitTestResult]) {
        guard let result = results.first else { return }
        let coordinate = result.worldCoordinates
        
        createHouse(x: Int(coordinate.x), y: Int(coordinate.z))
    }
    
    override func sceneDidLoad() {
        setupSkybox()
        level.delagate = self
        
        lightNode.light?.castsShadow = true
        lightNode.light?.shadowSampleCount = 4
        
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 10
        
        cameraNode.eulerAngles = [-.pi/12, .pi/4, 0]
        cameraNode.position = [30, 9, 24]
        
        for x in 0...5 {
            for z in 0...5 {
                level.placeBlock(.normalFloar, at: TSVector3(x: x * 5, y: 0, z: z * 5))
            }
        }
    }
}
extension MySceneController:_TSGestureHelperDelegate {
    func moveCamera(to position: SCNVector3) {
        self.cameraNode.simdLocalTranslate(by: simd_float3
        )
        self.cameraNode.position = position
    }
}

extension MySceneController:TSLevelDelegate {
    func didPlaceBlock(at anchor: TSVector3) {
        guard let node = level.getBlockNode(at: anchor) else { return }
        node.position = anchor.scnVector3
        rootNode.addChildNode(node)
    }
    func didDestoryBlock(at anchor: TSVector3) {
        guard let node = level.getBlockNode(at: anchor) else { return }
        
        node.removeFromParentNode()
    }
}

extension MySceneController {
    func createMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        let program = SCNProgram()
        program.fragmentFunctionName = "myFragment"
        program.vertexFunctionName = "myVertex"
        material.program = program
        
        let image = UIImage(named: "TP_japanese_house")!
        let imageProperty = SCNMaterialProperty(contents: image)
        material.setValue(imageProperty, forKey: "diffuseTexture")
        
        return material
    }
    func setupSkybox() {
        self.scene.background.contents = [
            UIImage(named: "sky-0"),
            UIImage(named: "sky-1"),
            UIImage(named: "sky-2"),
            UIImage(named: "sky-3"),
            UIImage(named: "sky-4"),
            UIImage(named: "sky-5"),
        ]
    }
}
