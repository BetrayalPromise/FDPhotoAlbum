//
//  FDIDCardValidator.swift
//  FDBusinessUIControl
//
//  Created by Zhongkai Li 李忠凯 on 27/04/2018.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import Foundation

/// Correct area codes
fileprivate let CorrectAreaCodes = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]

/// Regular expression for 15 identifier card(born in leap year)
fileprivate let IDRegEx15LeapYear = "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"

/// Regular expression for 15 identifier card(born in no leap year)
fileprivate let IDRegEx15NormalYear = "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"

/// Regular expression for 18 identifier card(born is leap year)
fileprivate let IDRegEx18LeapYear = "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$"

/// Regular expression for 18 identifier card(born is no leap year)
fileprivate let IDRegEx18NormalYear = "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$"

/// 2 kinds: short ID card length is 15, and long ID card length is 18
fileprivate enum IDCardType: Int {
    case short = 15
    case long = 18
}

/// ID card validation failure type
public enum FDIDCardFailureType {
    
    /// empty
    case isEmpty
    
    /// length is not correct, correct length is 15 or 18
    case isNotValidLength
    
    /// area code is not correct
    case isNotValidAreaCode
    
    /// date is not correct
    case isNotValidDate
    
    /// regular expression validation failure
    case isNotValid
    
    /// when id card length is 18, check the detection code
    case isNotValidDetectionCode
}

public class FDIDCardValidator: FDValidator<String> {
    public override var isEmpty: Bool {
        return value == ""
    }
    
    /// General ID card validation
    public override var isValid: Bool {
        return validate(expression: isValidIDCard)
    }
    
    /// Whether the length is correct(correct length is 15 or 18)
    public var isValidLength: Bool {
        return type != .none
    }
    
    /// Whether the area code is correct
    public var isValidAreaCode: Bool {
        guard isValidLength else { return false }
        
        let index = value.index(value.startIndex, offsetBy: 2)
        let valueStart = String(value[..<index])
        
        return CorrectAreaCodes.contains(valueStart)
    }
    
    /// Whether the date is correct
    public var isValidDate: Bool {
        guard let type = type else { return false }
        
        return checkDate(testStr: value, type: type)
    }
    
    /// Whether the detection code is correct(only check when the type is long)
    private var isValidDetectionCode: Bool {
        guard let type = type,
            type == .long else { return true }
        
        return checkDetectionCode(testStr: value)
    }
    
    private var type: IDCardType? {
        if value.count == 15 {
            return .short
        }
        else if value.count == 18 {
            return .long
        }
        else {
            return nil
        }
    }
    
    /// ID card validation
    ///     1. check length(correct length is 15 or 18)
    ///     2. check regular expression respectively(according to leap year, length) 确保是数字
    ///     3. check area code
    ///     4. check date
    ///     4. check detection code if length is 18
    ///
    /// - Parameters:
    ///   - successClosure: action after successful validation
    ///   - failureClosure: action after failure validation
    /// - Returns: true when valid, and vice versa
    @discardableResult
    public func validate(successClosure: (() -> ())?, failureClosure: ((FDIDCardFailureType) -> ())?) -> Bool {
        if isEmpty {
            failureClosure?(.isEmpty)
            return false
        }
        else if !isValidLength {
            failureClosure?(.isNotValidLength)
            return false
        }
        else if !isValid {
            failureClosure?(.isNotValid)
            return false
        }
        else if !isValidAreaCode {
            failureClosure?(.isNotValidAreaCode)
            return false
        }
        else if !isValidDate {
            failureClosure?(.isNotValidDate)
            return false
        }
        else if !isValidDetectionCode {
            failureClosure?(.isNotValidDetectionCode)
            return false
        }
        else {
            successClosure?()
            return true
        }
    }

    /// Using regular expressions to check generally
    ///
    /// - Parameter testStr: test string
    /// - Returns: true when passed validation, and vice versa
    private func isValidIDCard(testStr: String) -> Bool {
        guard let type = type else {
            return false
        }
        
        guard let year = getYear(testStr: testStr, type: type) else { return false }

        switch type {
        case .short:
            if isLeapYear(year: year) {
                let test = NSPredicate(format:"SELF MATCHES %@", IDRegEx15LeapYear)
                return test.evaluate(with: testStr)
            }
            else {
                let test = NSPredicate(format: "SELF MATCHES %@", IDRegEx15NormalYear)
                return test.evaluate(with: testStr)
            }
            
        case .long:
            if isLeapYear(year: year) {
                let test = NSPredicate(format: "SELF MATCHES %@", IDRegEx18LeapYear)
                return test.evaluate(with: testStr)
            }
            else {
                let test = NSPredicate(format: "SELF MATCHES %@", IDRegEx18NormalYear)
                return test.evaluate(with: testStr)
            }
            
        }
    }
    
    /// check date
    ///
    /// - Parameters:
    ///   - testStr: test string
    ///   - type: type
    /// - Returns: true when passed validation, and vice versa
    private func checkDate(testStr: String, type: IDCardType) -> Bool {
        let isNotBeyondCurrent = checkIfBeyondCurrent(testStr: testStr)
        guard isNotBeyondCurrent else {
            return false
        }
        
        guard let year = getYear(testStr: testStr, type: type) else { return false }
        let isYearValid = checkYear(year)
        guard isYearValid else {
            return false
        }
        
        let month = Int(getMonth(testStr: testStr, type: type))
        let isMonthValid = checkMonth(month)
        guard isMonthValid else {
            return false
        }
        
        let day = Int(getDay(testStr: testStr, type: type))
        let isDayValid = checkDay(day)
        guard isDayValid else {
            return false
        }
        
        return true
    }
    
    /// Check detection code
    /// 身份证校验码的计算方法：
    ///     1. 将前面的身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2
    ///     2. 将这17位数字和系数相乘的结果相加
    ///     3. 用加出来和除以11，看余数是多少
    ///     4. 余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字。其分别对应的最后一位身份证的号码为1－0－X－9－8－7－6－5－4－3－2。(即余数0对应1，余数1对应0，余数2对应X...)
    ///     5. 通过上面得知如果余数是3，就会在身份证的第18位数字上出现的是9。如果对应的数字是2，身份证的最后一位号码就是罗马数字x
    ///
    /// - Parameter testStr: test string
    /// - Returns: true when passed validation, and vice versa
    private func checkDetectionCode(testStr: String) -> Bool {
        
        var index = testStr.startIndex
        let a = Int(String(testStr[index...index]))! * 7
        
        index = testStr.index(after: index)
        let b = Int(String(testStr[index...index]))! * 9
        
        index = testStr.index(after: index)
        let c = Int(String(testStr[index...index]))! * 10
        
        index = testStr.index(after: index)
        let d = Int(String(testStr[index...index]))! * 5
        
        index = testStr.index(after: index)
        let e = Int(String(testStr[index...index]))! * 8
        
        index = testStr.index(after: index)
        let f = Int(String(testStr[index...index]))! * 4
        
        index = testStr.index(after: index)
        let g = Int(String(testStr[index...index]))! * 2
        
        index = testStr.index(after: index)
        let h = Int(String(testStr[index...index]))! * 1
        
        index = testStr.index(after: index)
        let i = Int(String(testStr[index...index]))! * 6
        
        index = testStr.index(after: index)
        let j = Int(String(testStr[index...index]))! * 3
        
        index = testStr.index(after: index)
        let k = Int(String(testStr[index...index]))! * 7
        
        index = testStr.index(after: index)
        let l = Int(String(testStr[index...index]))! * 9
        
        index = testStr.index(after: index)
        let m = Int(String(testStr[index...index]))! * 10
        
        index = testStr.index(after: index)
        let n = Int(String(testStr[index...index]))! * 5
        
        index = testStr.index(after: index)
        let o = Int(String(testStr[index...index]))! * 8
        
        index = testStr.index(after: index)
        let p = Int(String(testStr[index...index]))! * 4
        
        index = testStr.index(after: index)
        let q = Int(String(testStr[index...index]))! * 2
        
        index = testStr.index(after: index)
        let r = String(testStr[index...index])
        
        let total = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q
        
        let reminder = total % 11
        
        let detectionCode = "10X98765432"
        let referenceIndex = detectionCode.index(detectionCode.startIndex, offsetBy: reminder)
        let referenceValue = String(detectionCode[referenceIndex...referenceIndex])
        
        if referenceValue == "X" {
            return r == "X" || r == "x"
        }
        
        return referenceValue == r
        
    }
    
    /// check if test date is beyond current
    ///
    /// - Parameter testStr: testStr
    /// - Returns: if test date is beyond current, return false, and vice versa
    private func checkIfBeyondCurrent(testStr: String) -> Bool {
        guard let type = type,
            type == .long else {
            return true
        }
        
        guard let year = getYear(testStr: testStr, type: .long) else {
            return false
        }
        
        let dateStr = String(year)
            + "-"
            + String(getMonth(testStr: testStr, type: .long))
            + "-"
            + String(getDay(testStr: testStr, type: .long))
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let idCardDate = dateFormatter.date(from: dateStr) else { return false}
        
        let currentDate = Date()
        let result = currentDate.compare(idCardDate)
        
        if result != .orderedDescending {
            return false
        }
        else {
            return true
        }
    }
    
    /// check if age is more than 150
    ///
    /// - Parameter year: year
    /// - Returns: if age is more than 150, validation fail, and vice versa
    private func checkYear(_ year: Int) -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)

        if currentYear - year > 150 {
            return false
        }
        else {
            return true
        }
    }
    
    /// check if month is correct
    ///
    /// - Parameter month: month
    /// - Returns: if month is among 1...12, return true, and vice versa
    private func checkMonth(_ month: Int) -> Bool {
        return month > 0 && month <= 12
    }
    
    /// check if day is correct
    ///
    /// - Parameter month: day
    /// - Returns: if day is among 1...31, return true, and vice versa
    private func checkDay(_ day: Int) -> Bool {
        return day > 0 && day <= 31
    }
    
    /// Get year from string
    ///     1. short type: 412882870628401 -> 87
    ///     2. long type: 412882198706294014 -> 1987
    ///
    /// - Parameters:
    ///   - testStr: test string
    ///   - type: id card type
    /// - Returns: year
    private func getYear(testStr: String, type: IDCardType) -> Int? {
        switch type {
        case .short:
            let yearStrStart = testStr.index(testStr.startIndex, offsetBy: 6)
            let yearStrEnd = testStr.index(yearStrStart, offsetBy: 2)
            let yearStr = testStr[yearStrStart..<yearStrEnd]
            if let year = Int(yearStr) {
                return year + 1900
            }
            else {
                return nil
            }
        case .long:
            let yearStrStart = testStr.index(testStr.startIndex, offsetBy: 6)
            let yearStrEnd = testStr.index(yearStrStart, offsetBy: 4)
            let yearStr = testStr[yearStrStart..<yearStrEnd]
            return Int(yearStr)
        }
    }
    
    /// Get month from string
    ///     1. short type: 412882870628401 -> 06
    ///     2. long type: 412882198706294014 -> 06
    ///
    /// - Parameters:
    ///   - testStr: test string
    ///   - type: id card type
    /// - Returns: month
    private func getMonth(testStr: String, type: IDCardType) -> Int {
        switch type {
        case .short:
            let monthStrStart = testStr.index(testStr.startIndex, offsetBy: 8)
            let monthStrEnd = testStr.index(monthStrStart, offsetBy: 2)
            let monthStr = testStr[monthStrStart..<monthStrEnd]
            return Int(monthStr)!
        case .long:
            let monthStrStart = testStr.index(testStr.startIndex, offsetBy: 10)
            let monthStrEnd = testStr.index(monthStrStart, offsetBy: 2)
            let monthStr = testStr[monthStrStart..<monthStrEnd]
            return Int(monthStr)!
        }
    }
    
    /// Get day from string
    ///     1. short type: 412882870628401 -> 28
    ///     2. long type: 412882198706294014 -> 29
    ///
    /// - Parameters:
    ///   - testStr: test string
    ///   - type: id card type
    /// - Returns: day
    private func getDay(testStr: String, type: IDCardType) -> Int {
        switch type {
        case .short:
            let dayStrStart = testStr.index(testStr.startIndex, offsetBy: 10)
            let dayStrEnd = testStr.index(dayStrStart, offsetBy: 2)
            let dayStr = testStr[dayStrStart..<dayStrEnd]
            return Int(dayStr)!
        case .long:
            let dayStrStart = testStr.index(testStr.startIndex, offsetBy: 12)
            let dayStrEnd = testStr.index(dayStrStart, offsetBy: 2)
            let dayStr = testStr[dayStrStart..<dayStrEnd]
            return Int(dayStr)!
        }
    }
    
    /// Whether the year is leap year
    ///     闰年算法：
    ///         1. 能被4整除且不能被100整除的为闰年
    ///         2. 世纪年能被400整除的是闰年
    ///
    /// - Parameter year: year
    /// - Returns: true when the year is leap year, and vice versa
    private func isLeapYear(year: Int) -> Bool {
        if (year % 4 == 0 && year % 100 != 0) {
            return true
        }
        else if year % 400 == 0 {
            return true
        }
        else {
            return false
        }
    }
}
























