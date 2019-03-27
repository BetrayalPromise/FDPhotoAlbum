//
//  FDVerifyCodeValidator.swift
//  FDFoundation
//
//  Created by Zhongkai Li 李忠凯 on 2018/10/12.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

/// Verify code validation failure type
public enum FDVerifyCodeFailureType {

    /// length is not equal verifyCodeLength
    case invalidLength

    /// number only
    case numberOnly
}

open class FDVerifyCodeValidator: FDValidator<String> {
    
    /// Verify code count
    private(set) var verifyCodeLength: Int
    
    public init(value: String, verifyCodeLength: Int = 6) {
        self.verifyCodeLength = verifyCodeLength
        super.init(value: value)
    }
    
    /// Whether the length is valid
    ///
    /// - Returns: true when valid, and vice versa
    public func isValidLength() -> Bool {
        return value.count == verifyCodeLength
    }

    /// Whether the content is valid, number only
    ///
    /// - Returns: true when valid, and vice versa
    public func isContainsOnlyNumber() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: value))
    }

    /// Phone No validation
    ///     1. check if length equals 11
    ///     2. check if content contains only numbers
    ///     3. check if first number equals 1
    ///
    /// - Parameters:
    ///   - successClosure: action after successful validation
    ///   - failureClosure: action after failure validation
    /// - Returns: ture when valid, and vice versa
    @discardableResult
    open func validate(successClosure: (() -> ())?, failureClosure: ((FDVerifyCodeFailureType) -> ())?) -> Bool {
        if !isValidLength() {
            failureClosure?(.invalidLength)
            return false
        }
        else if !isContainsOnlyNumber() {
            failureClosure?(.numberOnly)
            return false
        }
        else {
            successClosure?()
            return true
        }
    }
}
