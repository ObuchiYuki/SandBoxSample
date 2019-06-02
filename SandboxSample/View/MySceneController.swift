//
//  MySceneController.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

class MySceneController: ESSceneController {
    var material:SCNMaterial = {
        let material = SCNMaterial()
        let program = SCNProgram()
        program.fragmentFunctionName = "myFragment"
        program.vertexFunctionName = "myVertex"
        material.program = program
        
        let image = UIImage(named: "TP_japanese_house")!
        let imageProperty = SCNMaterialProperty(contents: image)
        material.setValue(imageProperty, forKey: "diffuseTexture")
        
        return material
    }()
    
    func createFloar(at point:CGPoint) {
        let floar = SCNNode(named: "TP_Floar_1.scn")!
        floar.position = [Float(point.x), -0.1, Float(point.y)]
        floar.eulerAngles.y = Float(Int.random(in: 0...3)) * (.pi/2)
        self.rootNode.addChildNode(floar)
    }
    func createHouse(at point:CGPoint) {
        let house = SCNNode(named: "TP_japanese_house_1.scn")!
        house.position = [Float(point.x), 0, Float(point.y)]
        
        house.childNodes.forEach{
            $0.geometry?.materials = [self.material]
        }
        self.rootNode.addChildNode(house)
    }
    override func sceneDidLoad() {
        self.camera.usesOrthographicProjection = true
        enableDragHitTest()
        self.scene.background.contents = [
            UIImage(named: "sky-0"),
            UIImage(named: "sky-1"),
            UIImage(named: "sky-2"),
            UIImage(named: "sky-3"),
            UIImage(named: "sky-4"),
            UIImage(named: "sky-5"),
        ]
        
        lightNode.light?.castsShadow = true
        lightNode.light?.shadowSampleCount = 16
        lightNode.light?.shadowMode = .modulated
        
        cameraNode.eulerAngles = [-.pi/12, .pi/4, 0]
        cameraNode.position = [10 ,7, 10]
        
        for i in -5...5 {
            for j in -5...5 {
                createFloar(at: CGPoint(x: 5*i, y: 5*j))
            }
        }
    }
    private func roundValue(_ value:Float, radix:Int = 5) -> Int {
        let rounded = round(Double(value)/Double(radix))
        return Int(rounded) * radix
    }

    override func didHitTestEnd(_ results: [SCNHitTestResult]) {
        
        guard let result = results.first else {return}
        
        let cordinate = result.worldCoordinates
        let point = CGPoint(x: roundValue(cordinate.x), y: roundValue(cordinate.z))
        createHouse(at: point)
    }
}
