//
//  MySceneController.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import SceneKit.ModelIO

class MySceneController: ESSceneController {
    private let level = TSLevel.ground
    private lazy var gestutreHelper = _TSCameraGestureHelper(delegate: self)
    private lazy var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
    private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    
    @objc func handlePinchGesture(_ recognizer:UIPinchGestureRecognizer) {
        let scale = recognizer.scale
        self.gestutreHelper.pinched(to: scale)
    }
    @objc func handlePanGesture(_ recognizer:UIPanGestureRecognizer) {
        let vector = recognizer.translation(in: scnView)
        self.gestutreHelper.panned(to: vector)
    }
    func handleSliderMovement(with value:Float) {
        self.camera.focalLength = CGFloat(value)
    }
    
    func createHouse(x: Int, y:Int) {
        let position = TSVector3(x, 1, y)
        
        level.placeBlock(.japaneseHouse1, at: position)
    }

    override func touchesBegan(at location: CGPoint) {
        gestutreHelper.touchBegan(at: location, with: self.cameraNode.position)
    }
    
    override func didHitTestEnd(_ results: [SCNHitTestResult]) {
        guard let result = results.first else { return }
        let coordinate = result.worldCoordinates
        
        createHouse(x: Int(coordinate.x), y: Int(coordinate.z))
    }
    
    override func sceneDidLoad() {
        
        self.level.delagate = self
        
        self.addGestureRecognizer(pinchGestureRecognizer)
        self.addGestureRecognizer(panGestureRecognizer)
        
        self.setupSkybox()
        self.setupCamera()
        self.setupDirectionalLight()
        
        for x in 0...10 {
            for z in 0...10 {
                level.placeBlock(.normalFloar, at: TSVector3(x * 5, 0, z * 5))
            }
        }
    }
}
extension MySceneController:_TSCameraGestureHelperDelegate {
    func moveCamera(to position: SCNVector3) {
        self.cameraNode.position = position
    }
    func changeZoom(to value: CGFloat) {
        self.camera.orthographicScale = Double(value)
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
    func setupDirectionalLight() {
        directionalLightNode.eulerAngles = [-.pi/4, -.pi/4, 0]
        directionalLight.castsShadow = true
        directionalLight.shadowSampleCount = 16
        directionalLight.shadowCascadeCount = 4
        directionalLight.shadowRadius = 5
        directionalLight.shadowMapSize = CGSize(width: 500, height: 500)
        directionalLight.maximumShadowDistance = 2000
        directionalLight.shadowColor = UIColor.black
        
        let action = SCNAction.repeatForever(SCNAction.rotateBy(x: .pi, y: 0, z: 0, duration: 10))
        directionalLightNode.runAction(action)
    }
    func setupCamera() {
        camera.wantsHDR = true
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 10
        camera.automaticallyAdjustsZRange = true
        camera.wantsExposureAdaptation = true
        
        camera.wantsDepthOfField = true
        camera.focalLength = 1.8
        camera.fStop = 1.2
        
        camera.bloomIntensity = 1.0
        

        cameraNode.eulerAngles = [-.pi/12, .pi/4, 0]
        cameraNode.position = [100, 25, 100]
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
