//
//  TSEventRoop.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/06.
//  Copyright © 2019 yuki. All rights reserved.
//

import QuartzCore

private let krandomEventOccurePerFrame = 10

protocol TSEventRoopDelegate :class{
    /// 平均してkrandomEventOccurePerFrameフレームに一回呼び出されます。
    func randomEventOccured()
}

class TSEventRoop<Delegate: TSEventRoopDelegate> {
    // =====================================================================//
    // MARK: - Private Properties -
    
    private weak var delegate:Delegate!
    
    private lazy var _displayLink = CADisplayLink(target: self, selector: #selector(TSEventRoop._update(displayLink:)))
    
    // =====================================================================//
    // MARK: - Methods -
    
    // ================================== //
    // MARK: - Handler -
    @objc private func _update(displayLink:CADisplayLink) {
        if Int.random(in: 1...krandomEventOccurePerFrame) == 1 {
            self.delegate.randomEventOccured()
        }
    }
    
    // =====================================================================//
    // MARK: - Construction -
    public init(_ delegate:Delegate) {
        self.delegate = delegate
        self._displayLink.add(to: .main, forMode: .common)
    }
    deinit {
        self._displayLink.remove(from: .main, forMode: .common)
    }
}
