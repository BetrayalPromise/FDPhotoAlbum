//
//  FloatingPointExtensions.swift
//  FloatingPointExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Properties
public extension FloatingPoint {
	
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
	
	/// FDFoundation: Ceil of number.
	public var fd_ceil: Self {
		return Foundation.ceil(self)
	}
	
	/// FDFoundation: Radian value of degree input.
	public var fd_degreesToRadians: Self {
		return Self.pi * self / Self(180)
	}
	
	/// FDFoundation: Floor of number.
	public var fd_floor: Self {
		return Foundation.floor(self)
	}
	
	/// FDFoundation: Degree value of radian input.
	public var fd_radiansToDegrees: Self {
		return self * Self(180) / Self.pi
	}
	
}

// MARK: - Methods
public extension FloatingPoint {
	
	/// FDFoundation: Random number between two number.
	///
	/// - Parameters:
	///   - min: minimum number to start random from.
	///   - max: maximum number random number end before.
	/// - Returns: random number between two numbers.
	public static func fd_random(between min: Self, and max: Self) -> Self {
		let aMin = Self.minimum(min, max)
		let aMax = Self.maximum(min, max)
		let delta = aMax - aMin
		return Self(arc4random()) / Self(UInt64(UINT32_MAX)) * delta + aMin
	}
	
	/// FDFoundation: Random number in a closed interval range.
	///
	/// - Parameter range: closed interval range.
	/// - Returns: random number in the given closed range.
	public static func fd_random(inRange range: ClosedRange<Self>) -> Self {
		let delta = range.upperBound - range.lowerBound
		return Self(arc4random()) / Self(UInt64(UINT32_MAX)) * delta + range.lowerBound
	}
	
}

// MARK: - Initializers
public extension FloatingPoint {
	
	/// FDFoundation: Created a random number between two numbers.
	///
	/// - Parameters:
	///   - min: minimum number to start random from.
	///   - max: maximum number random number end before.
	public init(randomBetween min: Self, and max: Self) {
		let aMin = Self.minimum(min, max)
		let aMax = Self.maximum(min, max)
		let delta = aMax - aMin
		self = Self(arc4random()) / Self(UInt64(UINT32_MAX)) * delta + aMin
	}
	
	/// FDFoundation: Create a random number in a closed interval range.
	///
	/// - Parameter range: closed interval range.
	public init(randomInRange range: ClosedRange<Self>) {
		let delta = range.upperBound - range.lowerBound
		self = Self(arc4random()) / Self(UInt64(UINT32_MAX)) * delta + range.lowerBound
	}
	
}

// MARK: - Operators

infix operator ±
/// FDFoundation: Tuple of plus-minus operation.
///
/// - Parameters:
///   - lhs: number
///   - rhs: number
/// - Returns: tuple of plus-minus operation ( 2.5 ± 1.5 -> (4, 1)).
public func ±<T: FloatingPoint> (lhs: T, rhs: T) -> (T, T) {
	// http://nshipster.com/swift-operators/
	return (lhs + rhs, lhs - rhs)
}

prefix operator ±
/// FDFoundation: Tuple of plus-minus operation.
///
/// - Parameter int: number
/// - Returns: tuple of plus-minus operation (± 2.5 -> (2.5, -2.5)).
public prefix func ±<T: FloatingPoint> (number: T) -> (T, T) {
	// http://nshipster.com/swift-operators/
	return 0 ± number
}
