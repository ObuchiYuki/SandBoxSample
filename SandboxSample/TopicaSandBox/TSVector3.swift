//
//  TSVector3.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

/**
 SandBox次元のベクターを提供します。
 SCNVector3との関係は `TSVector3 = SCNVector3`です。
 ボクセルサイズのベクトルは、`TSVector3Ten`を使用してください。
 
 各元は必ず整数値になります。
 各元はInt16の範囲内である必要があります。
 */
public struct TSVector3 {
    //============================================================
    // MARK: - Public Properies -
    /// x component of TSVector3
    public var x:Int
    /// y component of TSVector3
    public var y:Int
    /// z component of TSVector3
    public var z:Int
    
    //============================================================
    // MARK: - Constructor -
    public init(_ x:Int, _ y:Int, _ z:Int) {
        assert(x <= Int(Int16.max) && y <= Int(Int16.max) && z <= Int(Int16.max), "Elements of TSVector3 must be less than 32767")
        assert(x >= Int(Int16.min) && y >= Int(Int16.min) && z >= Int(Int16.min), "Elements of TSVector3 must be bigger than -32768")
        
        self.x = x
        self.y = y
        self.z = z
    }
}

extension TSVector3 :Equatable {
    public static func == (left:TSVector3, right:TSVector3) -> Bool {
        return left.x == right.x && left.y == right.y && left.z == right.z
    }
}

extension TSVector3 :Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}


