//
//  TPPreference.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import RxSwift

// =============================================================== //
// MARK: - TPPreference -

/**
 */
class TPPreference {
    // =============================================================== //
    // MARK: - Properties -
    var renderDistance = BehaviorRelay(value: 5)
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================================================== //
    // MARK: - Methods -
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
}


// =============================================================== //
// MARK: - Extension For Singleton

extension TPPreference {
    
    /// Singleton of TPPreference
    static let `default` = TPPreference()
}
