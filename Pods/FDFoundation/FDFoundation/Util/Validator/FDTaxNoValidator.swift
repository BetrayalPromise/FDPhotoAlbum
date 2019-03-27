//
//  FDTaxNoValidator.swift
//  FDBusinessUIControl
//
//  Created by Zhongkai Li 李忠凯 on 04/05/2018.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

/// The number of 'Tax No' is limited to 30
public let FDTaxNoMaxLength: Int = 30

/// The number of 'Tax No' is limited to more than 10
public let FDTaxNoMinLength: Int = 10

/// TaxNo validation failure type
public enum FDTaxNoFailureType {
    
    /// empty
    case isEmpty
    
    /// length is not correct
    case isNotValidLength
    
    /// regular expression validation failure
    case isNotValid
}

open class FDTaxNoValidator: FDValidator<String> {
    open override var isEmpty: Bool {
        return value == ""
    }
    
    /// General 'Tax No' validation
    open override var isValid: Bool {
        return validate(expression: isValidTaxNo)
    }
    
    /// Whether the number of words is valid
    ///
    /// - Returns: true when valid, and vice versa
    public func isValidLength() -> Bool {
        return isValidNumber(minCount: FDTaxNoMinLength, maxCount: FDTaxNoMaxLength)
    }
    
    /// Whether the number of words is valid
    ///
    /// - Parameters:
    ///   - minCount: minimum limit
    ///   - maxCount: maximum limit
    /// - Returns: true when valid, and vice versa
    public func isValidNumber(minCount: Int, maxCount: Int) -> Bool {
        return value.count >= minCount
            && value.count <= maxCount
    }
    
    /// Whether the 'Tax No' is valid: A-Z, 0-9, a-z
    ///
    /// - Parameter testStr: test string
    /// - Returns: true when valid, and vice versa
    public func isValidTaxNo(testStr: String) -> Bool {
        let regEx = "[A-Z0-9a-z]+"
        
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: testStr)
    }
    
    /// Tax No validation
    ///     1. check if empty
    ///     2. check length(corrent length is between 10 and 30)
    ///     3. regular expression check
    ///
    /// - Parameters:
    ///   - successClosure: action after successful validation
    ///   - failureClosure: action after failure validation
    /// - Returns: ture when valid, and vice versa
    @discardableResult
    open func validate(successClosure: (() -> ())?, failureClosure: ((FDTaxNoFailureType) -> ())?) -> Bool {
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











