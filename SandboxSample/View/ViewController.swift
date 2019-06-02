//
//  ViewController.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class ViewController: ESViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scnView.allowsCameraControl = true
        self.scnView.showsStatistics = true
    }
    
    override func getSceneController() -> ESSceneController? {
        return MySceneController(self)
    }
}
