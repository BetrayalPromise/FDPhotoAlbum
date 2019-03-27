//
//  DateExtension.swift
//  FDFoundation
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/23.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import Foundation

// MARK: - Enums
public extension Date {
    
    /// FDFoundation: Day name format.
    ///
    /// - threeLetters: 3 letter day abbreviation of day name.
    /// - oneLetter: 1 letter day abbreviation of day name.
    /// - full: Full day name.
    public enum FDDayNameStyle {
        case threeLetters
        case oneLetter
        case full
    }
    
    /// FDFoundation: Month name format.
    ///
    /// - threeLetters: 3 letter month abbreviation of month name.
    /// - oneLetter: 1 letter month abbreviation of month name.
    /// - full: Full month name.
    public enum FDMonthNameStyle {
        case threeLetters
        case oneLetter
        case full
    }
    
}



// MARK: - Properties
public extension Date {
    
    /// FDFoundation: Era.
    ///
    ///        Date().fd_era -> 1
    ///
    public var fd_era: Int {
        return Calendar.current.component(.era, from: self)
    }
    
    /// FDFoundation: User’s current calendar.
    public var fd_calendar: Calendar {
        return Calendar.current
    }

    /// FDFoundation: Week of year.
    ///
    ///        Date().fd_weekOfYear -> 2 // second week in the year.
    ///
    public var fd_weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    /// FDFoundation: Week of month.
    ///
    ///        Date().fd_weekOfMonth -> 3 // date is in third week of the month.
    ///
    public var fd_weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    /// FDFoundation: Year.
    ///
    ///        Date().fd_year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    public var fd_year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = Calendar.current.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = Calendar.current.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// FDFoundation: Month.
    ///
    ///     Date().fd_month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.month = 10 // sets someDate's month to 10.
    ///
    public var fd_month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMonth = Calendar.current.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// FDFoundation: Day.
    ///
    ///     Date().fd_day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    public var fd_day: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentDay = Calendar.current.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// FDFoundation: Weekday.
    ///
    ///     Date().fd_weekday -> 5 // fifth day in the current week.
    ///
    public var fd_weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /// FDFoundation: Hour.
    ///
    ///     Date().fd_hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
    ///
    public var fd_hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentHour = Calendar.current.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// FDFoundation: Minutes.
    ///
    ///     Date().fd_minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    public var fd_minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// FDFoundation: Seconds.
    ///
    ///     Date().fd_second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15 // sets someDate's seconds to 15.
    ///
    public var fd_second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentSeconds = Calendar.current.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = Calendar.current.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// FDFoundation: Nanoseconds.
    ///
    ///     Date().fd_nanosecond -> 981379985
    ///
    ///     var someDate = Date()
    ///     someDate.nanosecond = 981379985 // sets someDate's seconds to 981379985.
    ///
    public var fd_nanosecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentNanoseconds = Calendar.current.component(.nanosecond, from: self)
            let nanosecondsToAdd = newValue - currentNanoseconds
            
            if let date = Calendar.current.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// FDFoundation: Milliseconds.
    ///
    ///     Date().fd_millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.fd_millisecond = 68 // sets someDate's nanosecond to 68000000.
    ///
    public var fd_millisecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self) / 1000000
        }
        set {
            let ns = newValue * 1000000
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: self)!
            guard allowedRange.contains(ns) else { return }
            
            if let date = Calendar.current.date(bySetting: .nanosecond, value: ns, of: self) {
                self = date
            }
        }
    }
    
    /// FDFoundation: Check if date is in future.
    ///
    ///     Date(timeInterval: 100, since: Date()).fd_isInFuture -> true
    ///
    public var fd_isInFuture: Bool {
        return self > Date()
    }
    
    /// FDFoundation: Check if date is in past.
    ///
    ///     Date(timeInterval: -100, since: Date()).fd_isInPast -> true
    ///
    public var fd_isInPast: Bool {
        return self < Date()
    }
    
    /// FDFoundation: Check if date is within today.
    ///
    ///     Date().fd_isInToday -> true
    ///
    public var fd_isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// FDFoundation: Check if date is within yesterday.
    ///
    ///     Date().fd_isInYesterday -> false
    ///
    public var fd_isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// FDFoundation: Check if date is within tomorrow.
    ///
    ///     Date().fd_isInTomorrow -> false
    ///
    public var fd_isInTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// FDFoundation: Check if date is within a weekend period.
    public var fd_isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    /// FDFoundation: Check if date is within a weekday period.
    public var fd_isWorkday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
    
    /// FDFoundation: Check if date is within the current week.
    public var fd_isInCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// FDFoundation: Check if date is within the current month.
    public var fd_isInCurrentMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// FDFoundation: Check if date is within the current year.
    public var fd_isInCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    /// FDFoundation: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSS) from date.
    ///
    ///     Date().fd_iso8601String -> "2017-01-12T14:51:29.574Z"
    ///
    public var fd_iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
    /// FDFoundation: Nearest five minutes to date.
    ///
    ///     var date = Date() // "5:54 PM"
    ///     date.fd_minute = 32 // "5:32 PM"
    ///     date.fd_nearestFiveMinutes // "5:30 PM"
    ///
    ///     date.fd_minute = 44 // "5:44 PM"
    ///     date.fd_nearestFiveMinutes // "5:45 PM"
    ///
    public var fd_nearestFiveMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// FDFoundation: Nearest ten minutes to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.fd_minute = 34 // "5:34 PM"
    ///     date.fd_nearestTenMinutes // "5:30 PM"
    ///
    ///     date.fd_minute = 48 // "5:48 PM"
    ///     date.fd_nearestTenMinutes // "5:50 PM"
    ///
    public var fd_nearestTenMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// FDFoundation: Nearest quarter hour to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.fd_minute = 34 // "5:34 PM"
    ///     date.fd_nearestQuarterHour // "5:30 PM"
    ///
    ///     date.fd_minute = 40 // "5:40 PM"
    ///     date.fd_nearestQuarterHour // "5:45 PM"
    ///
    public var fd_nearestQuarterHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// FDFoundation: Nearest half hour to date.
    ///
    ///     var date = Date() // "6:07 PM"
    ///     date.fd_minute = 41 // "6:41 PM"
    ///     date.fd_nearestHalfHour // "6:30 PM"
    ///
    ///     date.fd_minute = 51 // "6:51 PM"
    ///     date.fd_nearestHalfHour // "7:00 PM"
    ///
    public var fd_nearestHalfHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// FDFoundation: Nearest hour to date.
    ///
    ///     var date = Date() // "6:17 PM"
    ///     date.fd_nearestHour // "6:00 PM"
    ///
    ///     date.fd_minute = 36 // "6:36 PM"
    ///     date.fd_nearestHour // "7:00 PM"
    ///
    public var fd_nearestHour: Date {
        let min = Calendar.current.component(.minute, from: self)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = Calendar.current.date(from: Calendar.current.dateComponents(components, from: self))!
        
        if min < 30 {
            return date
        }
        return Calendar.current.date(byAdding: .hour, value: 1, to: date)!
    }
    
    /// FDFoundation: Time zone used currently by system.
    ///
    ///        Date().fd_timeZone -> Europe/Istanbul (current)
    ///
    public var fd_timeZone: TimeZone {
        return Calendar.current.timeZone
    }
    
    /// FDFoundation: UNIX timestamp from date.
    ///
    ///        Date().fd_unixTimestamp -> 1484233862.826291
    ///
    public var fd_unixTimestamp: Double {
        return timeIntervalSince1970
    }
    
}

// MARK: - Methods
public extension Date {
    
    /// FDFoundation: Date by adding multiples of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.fd_adding(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.fd_adding(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.fd_adding(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.fd_adding(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of components to add.
    /// - Returns: original date + multiples of component added.
    public func fd_adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
    /// FDFoundation: Add calendar component to date.
    ///
    ///     var date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     date.add(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     date.add(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     date.add(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     date.add(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of compnenet to add.
    public mutating func fd_add(_ component: Calendar.Component, value: Int) {
        if let date = Calendar.current.date(byAdding: component, value: value, to: self) {
            self = date
        }
    }
    
    /// FDFoundation: Date by changing value of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.fd_changing(.minute, value: 10) // "Jan 12, 2017, 6:10 PM"
    ///     let date3 = date.fd_changing(.day, value: 4) // "Jan 4, 2017, 7:07 PM"
    ///     let date4 = date.fd_changing(.month, value: 2) // "Feb 12, 2017, 7:07 PM"
    ///     let date5 = date.fd_changing(.year, value: 2000) // "Jan 12, 2000, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: new value of compnenet to change.
    /// - Returns: original date after changing given component to given value.
    public func fd_changing(_ component: Calendar.Component, value: Int) -> Date? {
        switch component {
        case .nanosecond:
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentNanoseconds = Calendar.current.component(.nanosecond, from: self)
            let nanosecondsToAdd = value - currentNanoseconds
            return Calendar.current.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self)
            
        case .second:
            let allowedRange = Calendar.current.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentSeconds = Calendar.current.component(.second, from: self)
            let secondsToAdd = value - currentSeconds
            return Calendar.current.date(byAdding: .second, value: secondsToAdd, to: self)
            
        case .minute:
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = value - currentMinutes
            return Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self)
            
        case .hour:
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentHour = Calendar.current.component(.hour, from: self)
            let hoursToAdd = value - currentHour
            return Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self)
            
        case .day:
            let allowedRange = Calendar.current.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentDay = Calendar.current.component(.day, from: self)
            let daysToAdd = value - currentDay
            return Calendar.current.date(byAdding: .day, value: daysToAdd, to: self)
            
        case .month:
            let allowedRange = Calendar.current.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentMonth = Calendar.current.component(.month, from: self)
            let monthsToAdd = value - currentMonth
            return Calendar.current.date(byAdding: .month, value: monthsToAdd, to: self)
            
        case .year:
            guard value > 0 else { return nil }
            let currentYear = Calendar.current.component(.year, from: self)
            let yearsToAdd = value - currentYear
            return Calendar.current.date(byAdding: .year, value: yearsToAdd, to: self)
            
        default:
            return Calendar.current.date(bySetting: component, value: value, of: self)
        }
    }
    
    /// FDFoundation: Data at the beginning of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:14 PM"
    ///     let date2 = date.fd_beginning(of: .hour) // "Jan 12, 2017, 7:00 PM"
    ///     let date3 = date.fd_beginning(of: .month) // "Jan 1, 2017, 12:00 AM"
    ///     let date4 = date.fd_beginning(of: .year) // "Jan 1, 2017, 12:00 AM"
    ///
    /// - Parameter component: calendar component to get date at the beginning of.
    /// - Returns: date at the beginning of calendar component (if applicable).
    public func fd_beginning(of component: Calendar.Component) -> Date? {
        if component == .day {
            return Calendar.current.startOfDay(for: self)
        }
        
        var components: Set<Calendar.Component> {
            switch component {
            case .second:
                return [.year, .month, .day, .hour, .minute, .second]
                
            case .minute:
                return [.year, .month, .day, .hour, .minute]
                
            case .hour:
                return [.year, .month, .day, .hour]
                
            case .weekOfYear, .weekOfMonth:
                return [.yearForWeekOfYear, .weekOfYear]
                
            case .month:
                return [.year, .month]
                
            case .year:
                return [.year]
                
            default:
                return []
            }
        }
        
        guard !components.isEmpty else { return nil }
        return Calendar.current.date(from: Calendar.current.dateComponents(components, from: self))
    }
    
    /// FDFoundation: Date at the end of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:27 PM"
    ///     let date2 = date.fd_end(of: .day) // "Jan 12, 2017, 11:59 PM"
    ///     let date3 = date.fd_end(of: .month) // "Jan 31, 2017, 11:59 PM"
    ///     let date4 = date.fd_end(of: .year) // "Dec 31, 2017, 11:59 PM"
    ///
    /// - Parameter component: calendar component to get date at the end of.
    /// - Returns: date at the end of calendar component (if applicable).
    public func fd_end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = fd_adding(.second, value: 1)
            date = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            date.fd_add(.second, value: -1)
            return date
            
        case .minute:
            var date = fd_adding(.minute, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.fd_adding(.second, value: -1)
            return date
            
        case .hour:
            var date = fd_adding(.hour, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.fd_adding(.second, value: -1)
            return date
            
        case .day:
            var date = fd_adding(.day, value: 1)
            date = Calendar.current.startOfDay(for: date)
            date.fd_add(.second, value: -1)
            return date
            
        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.fd_adding(.day, value: 7).fd_adding(.second, value: -1)
            return date
            
        case .month:
            var date = fd_adding(.month, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: date))!
            date = after.fd_adding(.second, value: -1)
            return date
            
        case .year:
            var date = fd_adding(.year, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: date))!
            date = after.fd_adding(.second, value: -1)
            return date
            
        default:
            return nil
        }
    }
    
    /// FDFoundation: Check if date is in current given calendar component.
    ///
    ///     Date().fd_isInCurrent(.day) -> true
    ///     Date().fd_isInCurrent(.year) -> true
    ///
    /// - Parameter component: calendar component to check.
    /// - Returns: true if date is in current given calendar component.
    public func fd_isInCurrent(_ component: Calendar.Component) -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: component)
    }
    
    /// FDFoundation: Date string from date.
    ///
    ///     Date().fd_string(withFormat: "dd/MM/yyyy") -> "1/12/17"
    ///     Date().fd_string(withFormat: "HH:mm") -> "23:50"
    ///     Date().fd_string(withFormat: "dd/MM/yyyy HH:mm") -> "1/12/17 23:50"
    ///
    /// - Parameter format: Date format (default is "dd/MM/yyyy").
    /// - Returns: date string.
    public func fd_string(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    /// FDFoundation: Date string from date.
    ///
    ///     Date().fd_dateString(ofStyle: .short) -> "1/12/17"
    ///     Date().fd_dateString(ofStyle: .medium) -> "Jan 12, 2017"
    ///     Date().fd_dateString(ofStyle: .long) -> "January 12, 2017"
    ///     Date().fd_dateString(ofStyle: .full) -> "Thursday, January 12, 2017"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date string.
    public func fd_dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    /// FDFoundation: Date and time string from date.
    ///
    ///     Date().fd_dateTimeString(ofStyle: .short) -> "1/12/17, 7:32 PM"
    ///     Date().fd_dateTimeString(ofStyle: .medium) -> "Jan 12, 2017, 7:32:00 PM"
    ///     Date().fd_dateTimeString(ofStyle: .long) -> "January 12, 2017 at 7:32:00 PM GMT+3"
    ///     Date().fd_dateTimeString(ofStyle: .full) -> "Thursday, January 12, 2017 at 7:32:00 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date and time string.
    public func fd_dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    /// FDFoundation: Time string from date
    ///
    ///     Date().fd_timeString(ofStyle: .short) -> "7:37 PM"
    ///     Date().fd_timeString(ofStyle: .medium) -> "7:37:02 PM"
    ///     Date().fd_timeString(ofStyle: .long) -> "7:37:02 PM GMT+3"
    ///     Date().fd_timeString(ofStyle: .full) -> "7:37:02 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: time string.
    public func fd_timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }
    
    /// FDFoundation: Day name from date.
    ///
    ///     Date().fd_dayName(ofStyle: .oneLetter) -> "T"
    ///     Date().fd_dayName(ofStyle: .threeLetters) -> "Thu"
    ///     Date().fd_dayName(ofStyle: .full) -> "Thursday"
    ///
    /// - Parameter Style: style of day name (default is DayNameStyle.full).
    /// - Returns: day name string (example: W, Wed, Wednesday).
    public func fd_dayName(ofStyle style: FDDayNameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "EEEEE"
            case .threeLetters:
                return "EEE"
            case .full:
                return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
    
    /// FDFoundation: Month name from date.
    ///
    ///     Date().fd_monthName(ofStyle: .oneLetter) -> "J"
    ///     Date().fd_monthName(ofStyle: .threeLetters) -> "Jan"
    ///     Date().fd_monthName(ofStyle: .full) -> "January"
    ///
    /// - Parameter Style: style of month name (default is MonthNameStyle.full).
    /// - Returns: month name string (example: D, Dec, December).
    public func fd_monthName(ofStyle style: FDMonthNameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "MMMMM"
            case .threeLetters:
                return "MMM"
            case .full:
                return "MMMM"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
    
    /// FDFoundation: get number of seconds between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of seconds between self and given date.
    public func fd_secondsSince(_ date: Date) -> Double {
        return timeIntervalSince(date)
    }
    
    /// FDFoundation: get number of minutes between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of minutes between self and given date.
    public func fd_minutesSince(_ date: Date) -> Double {
        return timeIntervalSince(date)/60
    }
    
    /// FDFoundation: get number of hours between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of hours between self and given date.
    public func fd_hoursSince(_ date: Date) -> Double {
        return timeIntervalSince(date)/3600
    }
    
    /// FDFoundation: get number of days between two date
    ///
    /// - Parameter date: date to compate self to.
    /// - Returns: number of days between self and given date.
    public func fd_daysSince(_ date: Date) -> Double {
        return timeIntervalSince(date)/(3600*24)
    }
    
    /// FDFoundation: check if a date is between two other dates
    ///
    /// - Parameters:
    ///   - startDate: start date to compare self to.
    ///   - endDate: endDate date to compare self to.
    ///   - includeBounds: true if the start and end date should be included (default is false)
    /// - Returns: true if the date is between the two given dates.
    public func fd_isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self).rawValue * compare(endDate).rawValue >= 0
        }
        return startDate.compare(self).rawValue * compare(endDate).rawValue > 0
    }
    
    /// FDFoundation: check if a date is a number of date components of another date
    ///
    /// - Parameters:
    ///   - value: number of times component is used in creating range
    ///   - component: Calendar.Component to use.
    ///   - date: Date to compare self to.
    /// - Returns: true if the date is within a number of components of another date
    public func fd_isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = Calendar.current.dateComponents([component], from: self, to: date)
        let componentValue = components.value(for: component)!
        return abs(componentValue) <= value
    }
    
    /// FDFoundation: Random date between two dates.
    ///
    ///     Date.fd_random()
    ///     Date.fd_random(from: Date())
    ///     Date.fd_random(upTo: Date())
    ///     Date.fd_random(from: Date(), upTo: Date())
    ///
    /// - Parameters:
    ///   - fromDate: minimum date (default is Date.distantPast)
    ///   - toDate: maximum date (default is Date.distantFuture)
    /// - Returns: random date between two dates.
    public static func fd_random(from fromDate: Date = Date.distantPast, upTo toDate: Date = Date.distantFuture) -> Date {
        guard fromDate != toDate else {
            return fromDate
        }
        
        let diff = llabs(Int64(toDate.timeIntervalSinceReferenceDate - fromDate.timeIntervalSinceReferenceDate))
        var randomValue: Int64 = 0
        arc4random_buf(&randomValue, MemoryLayout<Int64>.size)
        randomValue = llabs(randomValue%diff)
        
        let startReferenceDate = toDate > fromDate ? fromDate : toDate
        return startReferenceDate.addingTimeInterval(TimeInterval(randomValue))
    }

    /// - Parameters:
    ///   - timeInterval: 1551323716
    /// - Returns: 周四
    public func fd_weekDayForTimeInterval(timeInterval: TimeInterval) -> String {
        let dayArray = ["周日","周一","周二","周三","周四","周五","周六"]
        let date = Date(timeIntervalSince1970: timeInterval)
        let calendar: Calendar = Calendar.init(identifier: .gregorian)
        let components = calendar.component(.weekday, from: date)
        return dayArray[components - 1]
    }
}

// MARK: - Initializers
public extension Date {
    
    /// FDFoundation: Create a new date form calendar components.
    ///
    ///     let date = Date(year: 2010, month: 1, day: 12) // "Jan 12, 2010, 7:45 PM"
    ///
    /// - Parameters:
    ///   - calendar: Calendar (default is current).
    ///   - timeZone: TimeZone (default is current).
    ///   - era: Era (default is current era).
    ///   - year: Year (default is current year).
    ///   - month: Month (default is current month).
    ///   - day: Day (default is today).
    ///   - hour: Hour (default is current hour).
    ///   - minute: Minute (default is current minute).
    ///   - second: Second (default is current second).
    ///   - nanosecond: Nanosecond (default is current nanosecond).
    public init?(
        fd_calendar: Calendar? = Calendar.current,
        fd_timeZone: TimeZone? = TimeZone.current,
        fd_era: Int? = Date().fd_era,
        fd_year: Int? = Date().fd_year,
        fd_month: Int? = Date().fd_month,
        fd_day: Int? = Date().fd_day,
        fd_hour: Int? = Date().fd_hour,
        fd_minute: Int? = Date().fd_minute,
        fd_second: Int? = Date().fd_second,
        fd_nanosecond: Int? = Date().fd_nanosecond) {
        
        var components = DateComponents()
        components.calendar = fd_calendar
        components.timeZone = fd_timeZone
        components.era = fd_era
        components.year = fd_year
        components.month = fd_month
        components.day = fd_day
        components.hour = fd_hour
        components.minute = fd_minute
        components.second = fd_second
        components.nanosecond = fd_nanosecond
        
        if let date = fd_calendar?.date(from: components) {
            self = date
        } else {
            return nil
        }
    }
    
    /// FDFoundation: Create date object from ISO8601 string.
    ///
    ///     let date = Date(iso8601String: "2017-01-12T16:48:00.959Z") // "Jan 12, 2017, 7:48 PM"
    ///
    /// - Parameter iso8601String: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSSZ).
    public init?(fd_iso8601String: String) {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: fd_iso8601String) {
            self = date
        } else {
            return nil
        }
    }
    
    /// FDFoundation: Create new date object from UNIX timestamp.
    ///
    ///     let date = Date(unixTimestamp: 1484239783.922743) // "Jan 12, 2017, 7:49 PM"
    ///
    /// - Parameter unixTimestamp: UNIX timestamp.
    public init(fd_unixTimestamp: Double) {
        self.init(timeIntervalSince1970: fd_unixTimestamp)
    }
    
    /// FDFoundation: Create date object from Int literal
    ///
    ///     let date = Date(integerLiteral: 2017_12_25) // "2017-12-25 00:00:00 +0000"
    /// - Parameter value: Int value, e.g. 20171225, or 2017_12_25 etc.
    public init?(integerLiteral fd_value: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        guard let date = formatter.date(from: String(fd_value)) else { return nil }
        self = date
    }
    
}
