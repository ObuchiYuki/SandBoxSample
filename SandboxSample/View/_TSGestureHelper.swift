//
//  _TSGestureHelper.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

protocol _TSGestureHelperDelegate:class {
    func moveCamera(to position:SCNVector3)
}

/// ジェスチャーの稼働を助けます。
/// カメラの方向は（x: -π/12, y: π/4, z: 0）を前提に作っています。　
class _TSGestureHelper<Delegate:_TSGestureHelperDelegate> {
    weak var delegate:Delegate!
    
    private let cameraEularAngle:SCNVector3
    private var cameraStartPosition = SCNVector3.zero
    private var touchStartPosition = CGPoint.zero
    
    init(delegate:Delegate) {
        self.delegate = delegate
        self.cameraEularAngle = cameraEularAngle
    }
    
    /// タッチ開始時に呼び出してください。
    func touchBegan(at location:CGPoint, with firstCameraPosition:SCNVector3) {
        cameraStartPosition = firstCameraPosition
        touchStartPosition = location
    }
    
    /// タッチ移動時に呼び出してください。
    func touchMoved(to location:CGPoint) {
        let dx:Float = Float((location.x - touchStartPosition.x)) / 60
        let dy:Float = Float((location.y - touchStartPosition.y)) / 40
        
        let p:SCNVector3 = [cameraStartPosition.x - dx, cameraStartPosition.y, cameraStartPosition.z + dx]
        
        self.delegate.moveCamera(to: p)
    }
}
