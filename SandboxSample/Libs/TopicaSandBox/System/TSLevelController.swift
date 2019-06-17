//
//  TSLevelController.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/06.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSLevelController <Level:TSLevel> {
    
    private let level:Level
    private lazy var eventRoop = TSEventRoop(self)
    
    init(_ level:Level) {
        self.level = level
    }
}

extension TSLevelController: TSEventRoopDelegate {
    
    func randomEventOccured() {
        let ancs = level.getAllAnchors()
        for _ in 0...5 {
            guard let anc = ancs.randomElement() else {return}
            // level.getFBlock(at: anc).didRandomEventRoopCome(at: anc)
        }
    }
}
