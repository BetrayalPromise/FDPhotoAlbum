//
//  FloatExtensions.swift
//  FloatExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import CoreGraphics

// MARK: - Properties
public extension Float {
	
	/// FDFoundation: Int.
	public var fd_int: Int {
		return Int(self)
	}
	
	/// FDFoundation: Double.
	public var fd_double: Double {
		return Double(self)
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
///   - lhs: base float.
///   - rhs: exponent float.
/// - Returns: exponentiation result (4.4 ** 0.5 = 2.0976176963).
public func ** (lhs: Float, rhs: Float) -> Float {
	// http://nshipster.com/swift-operators/
	return pow(lhs, rhs)
}

prefix operator √
/// FDFoundation: Square root of float.
///
/// - Parameter float: float value to find square root for
/// - Returns: square root of given float.
public prefix func √ (float: Float) -> Float {
	// http://nshipster.com/swift-operators/
	return sqrt(float)
}
