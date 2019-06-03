//
//  ESVector3.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

/**
 SandBox次元のベクターを提供します。
 SCNVector3との関係は
 ESVector3 = SCNVector3 * 10
 です。
 各元は必ず整数値になります。
 各元はInt16の範囲内である必要があります。
 */
public struct ESVector3 {
    //============================================================
    // MARK: - Public Properies -
    /// x component of ESVector3
    public var x:Int
    /// y component of ESVector3
    public var y:Int
    /// z component of ESVector3
    public var z:Int
    
    //============================================================
    // MARK: - Constructor -
    public init(x:Int, y:Int, z:Int) {
        assert(x <= Int(Int16.max) && y <= Int(Int16.max) && z <= Int(Int16.max), "Elements of ESVector3 must be less than 32767")
        assert(x >= Int(Int16.min) && y >= Int(Int16.min) && z >= Int(Int16.min), "Elements of ESVector3 must be bigger than -32768")
        
        self.x = x
        self.y = y
        self.z = z
    }
}


extension ESVector3 {
    // Initirize `ESVector3` from `SCNVector3`
    public init(_ scnVector3:SCNVector3) {
        self.x = Int(scnVector3.x) * 10
        self.y = Int(scnVector3.y) * 10
        self.z = Int(scnVector3.z) * 10
    }
    
    // Converted ESVector3 to SCNVector3
    public var scnVector3:SCNVector3 {
        return SCNVector3(self.x, self.y, self.z)
    }
    
    public static func + (left:ESVector3, right:ESVector3) -> ESVector3 {
        return ESVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }
    public static func - (left:ESVector3, right:ESVector3) -> ESVector3 {
        return ESVector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
    }
    public static func * (left:ESVector3, right:Int) -> ESVector3 {
        return ESVector3(x: left.x * right, y: left.y * right, z: left.z * right)
    }
}

extension ESVector3 :Equatable {
    public static func == (left:ESVector3, right:ESVector3) -> Bool {
        return left.x == right.x && left.y == right.y && left.z == right.z
    }
}

extension ESVector3 :Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}

extension ESVector3 {
    static let zero = ESVector3(x: 0, y: 0, z: 0)
    
    /// An unit size of ESVector3 which is `(x: 1, y: 1, z: 1)`
    static let unit = ESVector3(x: 1, y: 1, z: 1)
}
