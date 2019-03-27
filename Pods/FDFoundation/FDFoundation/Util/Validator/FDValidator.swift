//
//  FDValidation.swift
//  FDBusinessUIControl
//
//  Created by Zhongkai Li 李忠凯 on 23/04/2018.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

/// Base class for Validation
open class FDValidator<T> {
    open var value: T
    
    open var isEmpty: Bool {
        return true
    }
    
    open var isValid: Bool {
        return true
    }
    
    public init(value: T) {
        self.value = value
    }
    
    public func validate(expression closure: (T) -> Bool) -> Bool {
        return closure(value)
    }

}



















