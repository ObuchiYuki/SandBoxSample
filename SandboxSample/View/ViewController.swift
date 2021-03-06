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
    private var mySceneController:MySceneController {
        return sceneController as! MySceneController
    }
    @IBAction func sliderDidMoved(_ sender:UISlider) {
        print(sender.value)
        self.mySceneController.handleSliderMovement(with: sender.value)
    }
    // =================================================================
    // MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scnView.showsStatistics = true
    }
    
    override func getSceneController() -> ESSceneController {
        return MySceneController(self)
    }
}
