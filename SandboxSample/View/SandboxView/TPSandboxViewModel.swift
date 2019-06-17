//
//  TPSandboxViewModel.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/06.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import RxSwift

class TPSandboxViewModel {
    private weak var sceneModel:TPSandboxSceneModel!
    
    let isItemCollectionHidden = BehaviorRelay(value: true)
    
    init(sceneModel:TPSandboxSceneModel) {
        self.sceneModel = sceneModel
        
    }
}
