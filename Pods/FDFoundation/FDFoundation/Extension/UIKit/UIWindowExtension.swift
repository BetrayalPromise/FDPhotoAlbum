//
//  UIWindowExtension.swift
//  FDFoundation
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/4/18.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import Foundation

public typealias FDWindow = UIWindow

// MARK: - Properties
public extension FDWindow {
    
    /// FDFoundation: Find current window ,returns the current window.
    static public var fd_currentWindow: UIWindow? {
        let enumerator = UIApplication.shared.windows.reversed()
        for window in enumerator {
            let windowOnMainScreen = (window.screen == UIScreen.main)
            let windowIsVisible = (!window.isHidden && window.alpha > 0)
            if windowOnMainScreen && windowIsVisible && window.isKeyWindow {
                return window
            }
        }
        return UIApplication.shared.delegate?.window ?? nil
    }
}
