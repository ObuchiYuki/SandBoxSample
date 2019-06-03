//
//  Ex+TSVector3.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

extension TSVector3 {
    // Initirize `TSVector3` from `SCNVector3`
    public init(_ scnVector3:SCNVector3) {
        self.x = Int(scnVector3.x)
        self.y = Int(scnVector3.y)
        self.z = Int(scnVector3.z)
    }
    
    // Converted TSVector3 to SCNVector3
    public var scnVector3:SCNVector3 {
        return SCNVector3(self.x, self.y, self.z)
    }
    
    public static func + (left:TSVector3, right:TSVector3) -> TSVector3 {
        return TSVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }
    public static func - (left:TSVector3, right:TSVector3) -> TSVector3 {
        return TSVector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
    }
    public static func * (left:TSVector3, right:Int) -> TSVector3 {
        return TSVector3(x: left.x * right, y: left.y * right, z: left.z * right)
    }
    public static func / (left:TSVector3, right:Int) -> TSVector3 {
        return TSVector3(x: left.x / right, y: left.y / right, z: left.z / right)
    }
}
extension TSVector3 {
    static let zero = TSVector3(x: 0, y: 0, z: 0)
    
    /// An unit size of TSVector3 which is `(x: 1, y: 1, z: 1)`
    static let unit = TSVector3(x: 1, y: 1, z: 1)
}
