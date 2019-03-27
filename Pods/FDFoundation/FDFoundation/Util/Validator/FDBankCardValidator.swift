//
//  FDBankCardValidator.swift
//  FDFoundation
//
//  Created by Zhongkai Li 李忠凯 on 2018/10/12.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

/// The length of bank card is limited to 100
public let FDBankCardMaxLength: Int = 30

/// The length of bank card is limited to more than 0
public let FDBankCardMinLength: Int = 10

/// Cell phone number validation failure type
public enum FDBankCardFailureType {

    /// length is not between 10 and 30
    case invalidLength

    /// number only
    case numberOnly
}

open class FDBankCardValidator: FDValidator<String> {

    /// Whether the length is valid
    ///
    /// - Returns: true when valid, and vice versa
    public func isValidLength() -> Bool {
        return value.count >= FDBankCardMinLength
            && value.count <= FDBankCardMaxLength
    }

    /// Whether if value contains only number
    ///
    /// - Returns: true when valid, and vice versa
    public func isContainsOnlyNumber() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: value))
    }

    /// Bank card validation
    ///     1. check if length is between 10 and 30
    ///     2. check if content contains only numbers
    ///
    /// - Parameters:
    ///   - successClosure: action after successful validation
    ///   - failureClosure: action after failure validation
    /// - Returns: ture when valid, and vice versa
    @discardableResult
    open func validate(successClosure: (() -> ())?, failureClosure: ((FDBankCardFailureType) -> ())?) -> Bool {
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
