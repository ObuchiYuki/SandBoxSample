//
//  ViewController.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class ViewController: ESViewController {
    // =================================================================
    // MARK: - Properties -
    private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestoreHandler))
    private var mySceneController:MySceneController {
        return sceneController as! MySceneController
    }
    
    // =================================================================
    // MARK: - Methods -
    @objc func panGestoreHandler(_ sender:UIPanGestureRecognizer) {
        let xRange = sender.velocity(in: scnView).x
        mySceneController.didPanMove(with: xRange)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scnView.showsStatistics = true
        // self.scnView.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func getSceneController() -> ESSceneController? {
        return MySceneController(self)
    }
}
