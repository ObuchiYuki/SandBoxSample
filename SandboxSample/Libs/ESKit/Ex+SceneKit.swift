//
//  Ex+SceneKit.swift
//  3DAppSample
//
//  Created by yuki on 2019/05/09.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit


// MARK: - SCNNode Extensions
public extension SCNNode {
    /// ファイル名からSCNNodeを初期化します。
    convenience init?(named name:String) {
        self.init()
        guard let modelScene = SCNScene(named: name) else {
            debugPrint(".scn file named \(name) is not found.")
            return nil
        }
        for childNode in modelScene.rootNode.childNodes {
            self.addChildNode(childNode)
        }
    }
    
    /// ファイル名から新規にSCNNodeを作成します。
    static func fromFile(named name:String,withExtension ex:String = "dae", identifier:String? = nil) -> SCNNode? {
        if let identifier = identifier {
            guard
                let url = Bundle.main.url(forResource: name, withExtension: ex),
                let sceneSource = SCNSceneSource(url: url, options: nil)
                else {return nil}
            
            
            guard let node = sceneSource.entryWithIdentifier(identifier, withClass: SCNNode.self) else {
                    return nil
            }
            return node
        }else{
            guard let url = Bundle.main.url(forResource: name, withExtension: ex) else {return nil}
            return try? SCNScene(url: url, options: nil).rootNode
        }
    }
    var size:SCNVector3 {
        return boundingBox.max - boundingBox.min
    }
}


// MARK: - SCNVector3 Extensions

public extension SCNVector3 {
    static let zero = SCNVector3(0, 0, 0)
}

public extension SCNVector3 {
    static func - (left:SCNVector3, right:SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    static func * <T: BinaryInteger>(left:SCNVector3, right:T) -> SCNVector3 {
        let fr = Float(right)
        return SCNVector3(left.x * fr, left.y * fr, left.z * fr)
    }
}

extension SCNVector3:ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Float...) {
        assert(elements.count == 3)
        self.init(x: elements[0], y: elements[1], z: elements[2])
    }
}

// MARK: - SCNAction Extensions

public extension SCNAction {
    func setEase(_ ease:SCNActionTimingMode) -> SCNAction{
        self.timingMode = ease
        return self
    }
}

// MARK: - SCNMatrix4 Extensions

public extension SCNMatrix4 {
    mutating func translate(_ tx:Float = 0,_ ty:Float = 0, _ tz:Float){
        self = SCNMatrix4Translate(self, tx, ty, tz)
    }
    mutating func scale(by scalar:Float){
        self = SCNMatrix4Scale(self, scalar, scalar, scalar)
    }
    mutating func scale(x:Float = 1, y:Float = 1, z:Float = 1) {
        self = SCNMatrix4Scale(self, x, y, z)
    }
    mutating func rotate(by angle:Float, x:Float=0, y:Float=0, z:Float=0){
        self = SCNMatrix4Rotate(self, angle, x, y, z)
        
    }
}
