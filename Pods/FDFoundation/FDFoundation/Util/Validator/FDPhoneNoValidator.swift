//
//  FDPhoneNoValidator.swift
//  FDFoundation
//
//  Created by Zhongkai Li 李忠凯 on 2018/10/12.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

/// Cell phone number count
public let FDPhoneNoLength: Int = 11

/// Cell phone number validation failure type
public enum FDPhoneNoFailureType {

    /// length is not equal 11
    case invalidLength

    /// number only
    case numberOnly

    /// should begin with 1
    case firstNumber
}

open class FDPhoneNoValidator: FDValidator<String> {

    /// Whether the length is valid
    ///
    /// - Returns: true when valid, and vice versa
    public func isValidLength() -> Bool {
        return value.count == FDPhoneNoLength
    }

    /// Whether the content is valid, number only
    ///
    /// - Returns: true when valid, and vice versa
    public func isContainsOnlyNumber() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: value))
    }

    /// Whether the first number is valid, first number should be 1
    ///
    /// - Returns: true when valid, and vice versa
    public func isValidFirstNumber() -> Bool {
        guard let first = value.first else { return false }
        return String(first) == "1"
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
    open func validate(successClosure: (() -> ())?, failureClosure: ((FDPhoneNoFailureType) -> ())?) -> Bool {
        if !isValidLength() {
            failureClosure?(.invalidLength)
            return false
        }
        else if !isContainsOnlyNumber() {
            failureClosure?(.numberOnly)
            return false
        }
        else if !isValidFirstNumber() {
            failureClosure?(.firstNumber)
            return false
        }
        else {
            successClosure?()
            return true
        }
    }
}
