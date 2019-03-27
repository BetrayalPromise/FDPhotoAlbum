//
//  SignedNumericExtensions.swift
//  SignedNumericExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Properties
public extension SignedNumeric {
	
	/// FDFoundation: String.
	public var fd_string: String {
		return String(describing: self)
	}
	
	/// FDFoundation: String with number and current locale currency.
	public var fd_asLocaleCurrency: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = Locale.current
		guard let number = self as? NSNumber else { return "" }
		return formatter.string(from: number) ?? ""
	}
	
}
