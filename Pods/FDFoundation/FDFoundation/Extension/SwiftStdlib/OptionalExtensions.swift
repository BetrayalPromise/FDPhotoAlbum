//
//  OptionalExtensions.swift
//  OptionalExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Methods
public extension Optional {
	
	/// FDFoundation: Get self of default value (if self is nil).
	///
	///		let foo: String? = nil
	///		print(foo.fd_unwrapped(or: "bar")) -> "bar"
	///
	///		let bar: String? = "bar"
	///		print(bar.fd_unwrapped(or: "foo")) -> "bar"
	///
	/// - Parameter defaultValue: default value to return if self is nil.
	/// - Returns: self if not nil or default value if nil.
	public func fd_unwrapped(or defaultValue: Wrapped) -> Wrapped {
		// http://www.russbishop.net/improving-optionals
		return self ?? defaultValue
	}
	
    /// FDFoundation: Gets the wrapped value of an optional. If the optional is `nil`, throw a custom error.
    ///
    ///        let foo: String? = nil
    ///        try print(foo.fd_unwrapped(or: MyError.notFound)) -> error: MyError.notFound
    ///
    ///        let bar: String? = "bar"
    ///        try print(bar.fd_unwrapped(or: MyError.notFound)) -> "bar"
    ///
    /// - Parameter error: The error to throw if the optional is `nil`.
    /// - Returns: The value wrapped by the optional.
    /// - Throws: The error passed in.
    public func fd_unwrapped(or error: Error) throws -> Wrapped {
        guard let wrapped = self else {
            throw error
        }
        return wrapped
    }
    
	/// FDFoundation: Runs a block to Wrapped if not nil
	///
	///		let foo: String? = nil
	///		foo.fd_run { unwrappedFoo in
	///			// block will never run sice foo is nill
	///			print(unwrappedFoo)
	///		}
	///
	///		let bar: String? = "bar"
	///		bar.fd_run { unwrappedBar in
	///			// block will run sice bar is not nill
	///			print(unwrappedBar) -> "bar"
	///		}
	///
	/// - Parameter block: a block to run if self is not nil.
	public func fd_run(_ block: (Wrapped) -> Void) {
		// http://www.russbishop.net/improving-optionals
		_ = self.map(block)
	}
	
}

// MARK: - Operators
infix operator ??= : AssignmentPrecedence
