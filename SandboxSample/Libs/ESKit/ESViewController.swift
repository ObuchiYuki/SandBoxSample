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
        guard let scnView = self.view as? SCNView else {
            fatalError("Error in converting UIViewController.view to SCNView. You cannot set other UIView subclass in ESViewController.view.")
        }
        return scnView
    }
    public var gestureRecognizers = [UIGestureRecognizer]()
    
    /// 配下のSceneControllerです。
    public var sceneController:ESSceneController!
    
    //==================================================================
    // MARK: - Private Properties -
    
    /// タップ時のヒットテストを行うために使用します。
    /// タップ時のヒットテストは常時有効です。
    private lazy var tapRayTraceGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleRayTrace(_:)))
    
    /// ドラッグ時のヒットテストを行うために使用します。
    /// ドラッグ時のヒットテストは　enableDragHitTest() を呼び出すまで無効です。
    private lazy var dragRayTraceGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleRayTrace(_:)))
    
    //==================================================================
    // MARK: - Methods -
    
    /// ESViewControllerを継承するクラスはこのメソッドを上書きし、
    /// ESSceneControllerのサブクラスを返す必要があります。
    open func getSceneController() -> ESSceneController {
        fatalError("GetSceneController.getSceneController() must be overrided to return ESSceneController.")
    }
    
    //==================================================================
    // MARK: - Internal Methods -
    
    /// allowsCameraControl状態保持用
    private var _oldAllowsCameraControlStateForDragHitTest:Bool?
    
    /// ドラッグによるヒットテストを有効にします。
    /// 非常に重い処理であるので、常時有効にはしないでください。
    /// SCNView.allowsCameraControl は自動的に無効になります。
    internal func enableDragHitTest() {
        self.scnView.addGestureRecognizer(dragRayTraceGestureRecognizer)
        
        self._oldAllowsCameraControlStateForDragHitTest = scnView.allowsCameraControl
        self.scnView.allowsCameraControl = false
    }
    
    /// ドラッグによるヒットテストを無効にします。
    /// ドラッグによるヒットテストは重い処理であるため、必要な処理が終了したら無効かしてください。
    /// SCNView.allowsCameraControl は自動的に enableDragHitTest() を呼び出す前の状況に戻ります。
    internal func disablDragHitTest() {
        scnView.removeGestureRecognizer(dragRayTraceGestureRecognizer)
        
        if let oldAllowsCameraControlStateForDragHitTest = _oldAllowsCameraControlStateForDragHitTest {
            self.scnView.allowsCameraControl = oldAllowsCameraControlStateForDragHitTest
        }
    }
    
    internal func addGestureRecognizer(_ gestureRecognizer:UIGestureRecognizer) {
        self.scnView.addGestureRecognizer(gestureRecognizer)
        self.gestureRecognizers.append(gestureRecognizer)
    }
    
    internal func removeGestureRecognizer(_ gestureRecognizer:UIGestureRecognizer) {
        self.scnView.removeGestureRecognizer(gestureRecognizer)
        self.gestureRecognizers.remove(of: gestureRecognizer)
    }
    //==================================================================
    // MARK: - Override Methods -
    
    /// Viewを読み込みます。 override した場合は必ずsuper.loadView()を呼んでください。
    /// view に SCNView をセットします。
    /// StoryBoardでSCNViewを設定していた場合は、新規にViewは作られません。
    override open func loadView() {
        super.loadView()
        
        // StoryBoardによって設定されていた場合の分岐
        if !(self.view is SCNView){
            self.view = SCNView()
        }
        
        // SceneController作成
        let sceneController = getSceneController()
        
        self.sceneController = sceneController
        self.scnView.scene = sceneController.scene
    }
    
    /// タップによるヒットテスト判定の登録を行います。
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView.addGestureRecognizer(tapRayTraceGestureRecognizer)
        
        self.gestureRecognizers.append(tapRayTraceGestureRecognizer)
    }
    
    @objc private func handleRayTrace(_ gestureRecognize: UIGestureRecognizer) {
        let position = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(position, options: [:])
        
        self.sceneController.didHitTestEnd(hitResults)
    }
    
    //==================================================================
    // MARK: - UIResponder Override Metheods -
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = _excludeFirstLocation(from: touches) else {return}
        self.sceneController.touchesBegan(at: location)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = _excludeFirstLocation(from: touches) else {return}
        self.sceneController.touchesEnd(at: location)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = _excludeFirstLocation(from: touches) else {return}
        self.sceneController.touchesMoved(at: location)
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = _excludeFirstLocation(from: touches) else {return}
        self.sceneController.touchesCanceled(at: location)
    }
    
    private func _excludeFirstLocation(from touches:Set<UITouch>) -> CGPoint? {
        guard
            let touch = touches.first,
            let view = touch.view
            else {debugPrint("Error occured while finding averable touch event.");return nil}
        return touch.location(in: view)
    }
}
