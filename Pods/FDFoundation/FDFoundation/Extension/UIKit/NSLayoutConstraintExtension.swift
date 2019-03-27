//
//  NSLayoutConstraintExtension.swift
//  FDFoundation
//
//  Created by Youhao Gong 宫酉昊 on 2019/3/5.
//  Copyright © 2019 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import Foundation

public extension NSLayoutConstraint {
    /// 自适应的约束 constant（以 375 宽度为标准）
    public var fd_adaptableConstant: CGFloat {
        get {
            return self.constant
        }
        set {
            let scale = UIScreen.main.bounds.size.width / 375
            self.constant = newValue * scale
        }
    }
}
