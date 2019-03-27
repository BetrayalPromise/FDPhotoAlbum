//
//  SignedIntegerExtensions.swift
//  SignedIntegerExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Properties
public extension SignedInteger {
	
	/// FDFoundation: Absolute value of integer number.
	public var fd_abs: Self {
		return Swift.abs(self)
	}
	
	/// FDFoundation: Check if integer is positive.
	public var fd_isPositive: Bool {
		return self > 0
	}
	
	/// FDFoundation: Check if integer is negative.
	public var fd_isNegative: Bool {
		return self < 0
	}
	
	/// FDFoundation: Check if integer is even.
	public var fd_isEven: Bool {
		return (self % 2) == 0
	}
	
	/// FDFoundation: Check if integer is odd.
	public var fd_isOdd: Bool {
		return (self % 2) != 0
	}

	/// FDFoundation: String of format (XXh XXm) from seconds Int.
	public var fd_timeString: String {
		guard self > 0 else {
			return "0 sec"
		}
		if self < 60 {
			return "\(self) sec"
		}
		if self < 3600 {
			return "\(self / 60) min"
		}
		let hours = self / 3600
		let mins = (self % 3600) / 60
		
		if hours != 0 && mins == 0 {
			return "\(hours)h"
		}
		return "\(hours)h \(mins)m"
	}
	
}

