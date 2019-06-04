//
//  _TSGestureHelper.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

protocol _TSCameraGestureHelperDelegate:class {
    func moveCamera(to position:SCNVector3)
    func changeZoom(to value:CGFloat)
}

/// ジェスチャーの稼働を助けます。
/// カメラの方向は（x: -π/12, y: π/4, z: 0）を前提に作っています。
/// 変わったらその時改修
class _TSCameraGestureHelper<Delegate:_TSCameraGestureHelperDelegate> {
    weak var delegate:Delegate!
    
    private var pinchScale:Float = 1.0
    private var originalPinchScale:Float = 1.0
    private var cameraStartPosition = SCNVector3.zero
    private var touchStartPosition = CGPoint.zero
    
    init(delegate:Delegate) {
        self.delegate = delegate
    }
    
    func pinched(to scale:CGFloat) {
        pinchScale = originalPinchScale * Float(scale)
        let tscale = 1 / pinchScale
        delegate.changeZoom(to: CGFloat(tscale * 10))
    }
    func panned(to vector:CGPoint) {
        let dx:Float = Float(vector.x) / 60 * Float(1.0 / pinchScale)
        let dy:Float = Float(vector.y) / 60 * Float(1.0 / pinchScale)
        
        let p:SCNVector3 = [cameraStartPosition.x - dx, cameraStartPosition.y + dy, cameraStartPosition.z + dx]
        
        self.delegate.moveCamera(to: p)
    }
    
    /// タッチ開始時に呼び出してください。
    func touchBegan(at location:CGPoint, with firstCameraPosition:SCNVector3) {
        originalPinchScale = pinchScale
        cameraStartPosition = firstCameraPosition
        touchStartPosition = location
    }
}
