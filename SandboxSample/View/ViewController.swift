//
//  ViewController.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: ESViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scnView.allowsCameraControl = true
        self.scnView.showsStatistics = true
        
    }
    
    override func getSceneController() -> ESSceneController? {
        return MySceneController(self)
    }
}

class MySceneController: ESSceneController {
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
            $0.geometry?.firstMaterial?.diffuse.contents = self.filter01(image: UIImage(named: "TP_japanese_house")!)!
        }
        self.rootNode.addChildNode(house)
    }
    func filter01(image: UIImage) -> UIImage?{
        let ciImage:CIImage = CIImage(image:image)!
        // カラーエフェクトを指定してCIFilterをインスタンス化.
        let mySharpFilter = CIFilter(name:"CIPhotoEffectInstant")
        
        // イメージのセット.
        mySharpFilter!.setValue(ciImage, forKey: kCIInputImageKey)
        
        // フィルターを通した画像をアウトプット.
        //修正前let image2 = UIImage(CIImage: mySharpFilter!.outputImage!)
        let context = CIContext()
        guard let cgImage = context.createCGImage(mySharpFilter!.outputImage!,from: mySharpFilter!.outputImage!.extent) else { return nil }
        let image2 = UIImage(cgImage: cgImage)
        return image2
    }
    override func sceneDidLoad() {
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
        
        camera.eulerAngles = [-.pi/12, .pi/4, 0]
        camera.position = [10 ,7, 10]
        
        for i in -5...5 {
            for j in -5...5 {
                createHouse(at: CGPoint(x: 5*i, y: 5*j))
            }
        }
        
        for i in -5...5 {
            for j in -5...5 {
                createFloar(at: CGPoint(x: 4*i, y: 4*j))
            }
        }
    }
}
