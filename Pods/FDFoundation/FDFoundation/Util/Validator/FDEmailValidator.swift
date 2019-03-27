//
//  FDEmailValidator.swift
//  FDBusinessUIControl
//
//  Created by Zhongkai Li 李忠凯 on 27/04/2018.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

/// The length of email is limited to 100
public let FDEmailMaxLength: Int = 100

/// The length of email is limited to more than 0
public let FDEmailMinLength: Int = 0

/// Email validation failure type
public enum FDEmailFailureType {
    
    /// empty
    case isEmpty
    
    /// length is not correct
    case isNotValidLength
    
    /// regular expression validation failure
    case isNotValid
}

/// Email validator
open class FDEmailValidator: FDValidator<String> {
    open override var isEmpty: Bool {
        return value == ""
    }
    
    /// General email validation
    open override var isValid: Bool {
        return validate(expression: isValidEmail)
    }
    
    /// Whether the number of words is valid
    ///
    /// - Returns: true when valid, and vice versa
    public func isValidLength() -> Bool {
        return isValidLength(minCount: FDEmailMinLength, maxCount: FDEmailMaxLength)
    }
    
    /// Whether the number of words is valid
    ///
    /// - Parameters:
    ///   - minCount: minimum limit
    ///   - maxCount: maximum limit
    /// - Returns: true when valid, and vice versa
    public func isValidLength(minCount: Int, maxCount: Int) -> Bool {
        return value.count >= minCount
            && value.count <= maxCount
    }
    
    /// Whether the first letter is valid: A-Z, 0-9, a-z
    ///
    /// - Returns: true when valid, and vice versa
    public func isValidFirstLetter() -> Bool {
        guard !isEmpty else { return false }
        
        let firstLetter = String(value.first!)
        return isValidLetter(testStr: firstLetter)
    }
    
    /// Whether the last letter is valid: A-Z, 0-9, a-z
    ///
    /// - Returns: true when valid, and vice versa
    public func isValidLastLetter() -> Bool {
        guard !isEmpty else { return false }
        
        let lastLetter = String(value.last!)
        return isValidLetter(testStr: lastLetter)
    }
    
    /// Whether the letter is valid: A-Z, 0-9, a-z
    ///
    /// - Parameter testStr: test string
    /// - Returns: true when valid, and vice versa
    public func isValidLetter(testStr: String) -> Bool {
        let regEx = "[A-Z0-9a-z]"
        
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: testStr)
    }
    
    private func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.[a-zA-Z0-9]{2,6}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /// Email validation
    ///     1. check if empty
    ///     2. check length(corrent length is between 0 and 100)
    ///     3. regular expression check
    ///
    /// - Parameters:
    ///   - successClosure: action after successful validation
    ///   - failureClosure: action after failure validation
    /// - Returns: ture when valid, and vice versa
    @discardableResult
    open func validate(successClosure: (() -> ())?, failureClosure: ((FDEmailFailureType) -> ())?) -> Bool {
        if isEmpty {
            failureClosure?(.isEmpty)
            return false
        }
        else if !isValidLength() {
            failureClosure?(.isNotValidLength)
            return false
        }
        else if !isValid {
            failureClosure?(.isNotValid)
            return false
        }
        else {
            successClosure?()
            return true
        }
    }
}
