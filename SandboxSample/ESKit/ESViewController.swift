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
    //==================================================================
    // MARK: - Properties -
    
    // SCNViewを返します。
    public var scnView:SCNView{
        return self.view as! SCNView
    }
    
    //==================================================================
    // MARK: - Methods -
    
    /// ESViewControllerを継承するクラスはこのメソッドを上書きし、
    /// ESSceneControllerのサブクラスを返す必要があります。
    open func getSceneController() -> ESSceneController? {
        return nil
    }
    
    //==================================================================
    // MARK: - Private Properties -
    
    private var _sceneController:ESSceneController!
    
    //==================================================================
    // MARK: - Override Methods -
    
    /// Load View.
    override open func loadView() {
        super.loadView()
        
        if !(self.view is SCNView){
            self.view = SCNView()
        }
        guard let sceneController = getSceneController() else {
            fatalError("GetSceneController must be overrided to return ESSceneController.")
        }
        self._sceneController = sceneController
        
        self.scnView.scene = sceneController.scene
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let rayTraceTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlerayTraceTap(_:)))
        scnView.addGestureRecognizer(rayTraceTapGestureRecognizer)
        
    }
    
    @objc private func handlerayTraceTap(_ gestureRecognize: UIGestureRecognizer) {
        let position = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(position, options: [:])
        
        self._sceneController.didHitTestEnd(hitResults)
    }
    
    //==================================================================
    // MARK: - UIResponder Override Metheods -
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self._sceneController.touchesBegan(touches, with: event)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self._sceneController.touchesEnded(touches, with: event)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self._sceneController.touchesMoved(touches, with: event)
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self._sceneController.touchesCancelled(touches, with: event)
    }
}
