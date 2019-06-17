//
//  MySceneController.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import SceneKit.ModelIO
import RxSwift
import RxCocoa


class TPSandboxSceneController: ESSceneController {
    // ===================================================================== //
    // MARK: - Properies -
    
    public lazy var sceneModel = TPSandboxSceneModel(self)
    
    private lazy var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
    private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    
    // ===================================================================== //
    // MARK: - Methods -
    
    // ================================ //
    // MARK: - Handler -
    @objc func handlePinchGesture(_ recognizer:UIPinchGestureRecognizer) {
        let scale = recognizer.scale
        if !sceneModel.isPlacingBlockMode.value {
            self.cameraGestutreHelper.pinched(to: scale)
        }
    }
    
    @objc func handlePanGesture(_ recognizer:UIPanGestureRecognizer) {
        let vector = recognizer.translation(in: scnView)
        
        if sceneModel.isPlacingBlockMode.value {
        } else {
            self.cameraGestutreHelper.panned(to: vector)
        }
    }

    // ================================ //
    // MARK: - Overrided -
    override func touchesBegan(at location: CGPoint) {
        cameraGestutreHelper.touchBegan(at: location, with: self.cameraNode.position)
    }
    
    override func didHitTestEnd(_ results: [SCNHitTestResult]) {
        guard let result = results.first else { return }
        let coordinate = result.worldCoordinates
        
        self.sceneModel.hitTestDidEnd(at: TSVector3(coordinate))
    }
    
    override func sceneDidLoad() {
        self.sceneModel.sceneDidLoad()
        
        self.addGestureRecognizer(pinchGestureRecognizer)
        self.addGestureRecognizer(panGestureRecognizer)
        
        self.setupSkybox()
        self.setupCamera()
        self.setupDirectionalLight()
    }
    
    override func sceneDidAppear() {
        self.sceneModel.setViewModel((esViewController as! TPSandboxViewController).viewModel)
    }
}

// ==================================================================================== //
// MARK: - Extension for SceneModel -

extension TPSandboxSceneController: TPSandboxSceneModelBinder {
    func placeNode(_ node: SCNNode, at position: TSVector3) {
        node.simdPosition = position.scnSIMD
        self.rootNode.addChildNode(node)
    }
    
    func removeNode(_ node: SCNNode) {
        node.removeFromParentNode()
    }
    
    func makeNodeTranceparent(_ node: SCNNode) {
        node.childNodes.first?.geometry?.firstMaterial?.transparencyMode = .singleLayer
        node.childNodes.first?.geometry?.firstMaterial?.transparency = 0.5
    }
    
    func makeNodeNotTranceparent(_ node: SCNNode) {
        node.childNodes.first?.geometry?.firstMaterial?.transparency = 1
    }
}

// ==================================================================================== //
// MARK: - Extension for _TSCameraGestureHelperDelegate -

extension TPSandboxSceneController: _TSCameraGestureHelperDelegate {
    func moveCamera(to position: SCNVector3) {
        self.cameraNode.position = position
    }
    func changeZoom(to value: CGFloat) {
        self.camera.orthographicScale = Double(value)
    }
}

extension TPSandboxSceneController: TPBlockPlaceHelperDelegate {
    func blockPlaceHelper(moveNodeWith node: SCNNode, to position: TSVector3) {
        node.simdPosition = position.scnSIMD
    }
    func blockPlaceHelper(placeNodeWith node: SCNNode, at position: TSVector3) {
        node.simdPosition = position.scnSIMD
        rootNode.addChildNode(node)
    }
    func blockPlaceHelper(setNodeTranceparencyWith node: SCNNode, to transparency: CGFloat) {
        node.tsMaterial?.transparencyMode = .singleLayer
        node.tsMaterial?.transparency = transparency
    }
}

// ==================================================================================== //
// MARK: - Extension for Addtinal Methods -

extension TPSandboxSceneController {
    func setupDirectionalLight() {
        directionalLightNode.eulerAngles = [-.pi/4, -.pi/4, 0]
        
        directionalLight.castsShadow = true
        directionalLight.shadowMapSize = [1000, 1000]
        directionalLight.maximumShadowDistance = 2000
        directionalLight.shadowColor = UIColor.black.withAlphaComponent(0.8)
        directionalLight.shadowRadius = 3
        directionalLight.shadowSampleCount = 8
        
    }
    func setupCamera() {
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 10
        
        camera.automaticallyAdjustsZRange = true
        camera.wantsExposureAdaptation = true
        
        camera.screenSpaceAmbientOcclusionRadius = 1
        camera.screenSpaceAmbientOcclusionIntensity = 1
        
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
