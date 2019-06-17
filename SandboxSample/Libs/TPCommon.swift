//
//  TPCommon.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import RxSwift

public struct TPCommon {
    public struct Font {
        public static func pixcel(_ size:CGFloat) -> UIFont {
            return UIFont(name: "5squared-pixel", size: size)!
        }
    }
}
