//
//  CalendarExtensions.swift
//  FDFoundation
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/23.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Methods
public extension Calendar {
    
    /// FDFoundation: Return the number of days in the month for a specified 'Date'.
    ///
    ///        let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///        Calendar.current.fd_numberOfDaysInMonth(for: date) -> 31
    ///
    /// - Parameter date: the date form which the number of days in month is calculated.
    /// - Returns: The number of days in the month of 'Date'.
    public func fd_numberOfDaysInMonth(for date: Date) -> Int {
        return range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
}
