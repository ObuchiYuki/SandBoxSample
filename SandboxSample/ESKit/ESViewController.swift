//
//  ESViewController.swift
//  3DAppSample
//
//  Created by yuki on 2019/05/09.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import SceneKit

/**
 `SCNScene`を使う`View`での`ViewControlelr`です。
 これを使うと`self.view`が`SCNView`であることが保証されます。
 StoryBoardからの使用も可能ですが、StoryBoardから使用する場合は`ViewController`の`View`を
 `SCNView`に設定してください。
 */
open class ESViewController: UIViewController {
    // SCNViewを返します。
    public var scnView:SCNView{
        return self.view as! SCNView
    }
    open func getSceneController() -> ESSceneController? {
        return nil
    }
    
    override open func loadView() {
        super.loadView()
        
        if !(self.view is SCNView){
            self.view = SCNView()
        }
        guard let scene = getSceneController()?.scene else {
            fatalError("GetSceneController must be overrided to return ESSceneController.")
        }
        
        self.scnView.scene = scene
    }
}
