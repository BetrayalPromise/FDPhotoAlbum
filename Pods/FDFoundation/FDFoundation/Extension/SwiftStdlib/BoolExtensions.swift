//
//  BoolExtensions.swift
//  BoolExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Properties
public extension Bool {
	
	/// FDFoundation: Return 1 if true, or 0 if false.
	///
	///		false.fd_int -> 0
	///		true.fd_int -> 1
	///
	public var fd_int: Int {
		return self ? 1 : 0
	}
	
	/// FDFoundation: Return "true" if true, or "false" if false.
	///
	///		false.fd_string -> "false"
	///		true.fd_string -> "true"
	///
	public var fd_string: String {
		return description
	}
	
	/// FDFoundation: Return inversed value of bool.
	///
	///		false.fd_toggled -> true
	///		true.fd_toggled -> false
	///
	public var fd_toggled: Bool {
		return !self
	}
	
	/// FDFoundation: Returns a random boolean value.
	///
	///     Bool.fd_random -> true
	///     Bool.fd_random -> false
	///
	public static var fd_random: Bool {
		return arc4random_uniform(2) == 1
	}
	
}

