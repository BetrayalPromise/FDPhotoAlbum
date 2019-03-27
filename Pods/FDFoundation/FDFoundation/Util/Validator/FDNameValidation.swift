//
//  FDNameValidation.swift
//  FDFoundation
//
//  Created by Zhongkai Li 李忠凯 on 2018/6/12.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

/// The length of name is limited to 30
public let FDNameMaxLength: Int = 30

/// The length of name is limited to more than 0
public let FDNameMinLength: Int = 0

/// Name validation failure type
public enum FDNameFailureType {
    
    /// empty
    case isEmpty
    
    /// length is not correct
    case isNotValidLength
    
    /// regular expression validation failure
    case isNotValid
}

open class FDNameValidator: FDValidator<String> {
    override open var isEmpty: Bool {
        return value.isEmpty
    }
    
    override open var isValid: Bool {
        return validate(expression: isValidName)
    }
    
    /// Whether the length of name is valid
    ///
    /// - Returns: true when valid, and vice versa
    public func isValidLength() -> Bool {
        return isValidLength(minCount: FDNameMinLength, maxCount: FDNameMaxLength)
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
    
    private func isValidName(testStr: String) -> Bool {
        let nameRegEx = "^[\\u4E00-\\u9FA5a-zA-Z. ]{1,100}$"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    /// Name validation
    ///     1. check if empty
    ///     2. check length(corrent length is between 0 and 30)
    ///     3. regular expression check
    ///
    /// - Parameters:
    ///   - successClosure: action after successful validation
    ///   - failureClosure: action after failure validation
    /// - Returns: ture when valid, and vice versa
    @discardableResult
    open func validate(successClosure: (() -> ())?, failureClosure: ((FDNameFailureType) -> ())?) -> Bool {
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
