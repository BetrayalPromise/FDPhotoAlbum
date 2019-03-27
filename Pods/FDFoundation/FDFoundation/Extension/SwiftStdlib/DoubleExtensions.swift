//
//  DoubleExtensions.swift
//  DoubleExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import CoreGraphics

// MARK: - Properties
public extension Double {
	
	/// FDFoundation: Int.
	public var fd_int: Int {
		return Int(self)
	}
	
	/// FDFoundation: Float.
	public var fd_float: Float {
		return Float(self)
	}
	
	/// FDFoundation: CGFloat.
	public var fd_cgFloat: CGFloat {
		return CGFloat(self)
	}
	
}

// MARK: - Operators

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence
/// FDFoundation: Value of exponentiation.
///
/// - Parameters:
///   - lhs: base double.
///   - rhs: exponent double.
/// - Returns: exponentiation result (example: 4.4 ** 0.5 = 2.0976176963).
public func ** (lhs: Double, rhs: Double) -> Double {
	// http://nshipster.com/swift-operators/
	return pow(lhs, rhs)
}

prefix operator √
/// FDFoundation: Square root of double.
///
/// - Parameter double: double value to find square root for.
/// - Returns: square root of given double.
public prefix func √ (double: Double) -> Double {
	// http://nshipster.com/swift-operators/
	return sqrt(double)
}
