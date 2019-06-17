//
//  TSSandboxPlayerSystem.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/06.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSSandboxPlayerSystem {
    public static let `default` = TSSandboxPlayerSystem()
    
    private var _player:TSPlayer!
    
    public init() {}
    
    public func getPlayer() -> TSPlayer {
        return _player
    }
    public func setPlayer(_ player:TSPlayer) {
        self._player = player
    }
}
