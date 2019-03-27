//
//  CharacterExtensions.swift
//  CharacterExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Properties
public extension Character {
	
	/// FDFoundation: Check if character is emoji.
	///
	///		Character("😀").fd_isEmoji -> true
	///
	public var fd_isEmoji: Bool {
		// http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
		let scalarValue = String(self).unicodeScalars.first!.value
		switch scalarValue {
		case 0x3030, 0x00AE, 0x00A9, // Special Characters
		0x1D000...0x1F77F, // Emoticons
		0x2100...0x27BF, // Misc symbols and Dingbats
		0xFE00...0xFE0F, // Variation Selectors
		0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
			return true
		default:
			return false
		}
	}
	
	/// FDFoundation: Check if character is number.
	///
	///		Character("1").fd_isNumber -> true
	///		Character("a").fd_isNumber -> false
	///
	public var fd_isNumber: Bool {
		return Int(String(self)) != nil
	}
	
	/// FDFoundation: Check if character is a letter.
	///
	///		Character("4").fd_isLetter -> false
	///		Character("a").fd_isLetter -> true
	///
	public var fd_isLetter: Bool {
		return String(self).rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
	}
	
	/// FDFoundation: Check if character is uppercased.
	///
	///		Character("a").fd_isUppercased -> false
	///		Character("A").fd_isUppercased -> true
	///
	public var fd_isUppercased: Bool {
		return String(self) == String(self).uppercased()
	}
	
	/// FDFoundation: Check if character is lowercased.
	///
	///		Character("a").fd_isLowercased -> true
	///		Character("A").fd_isLowercased -> false
	///
	public var fd_isLowercased: Bool {
		return String(self) == String(self).lowercased()
	}
	
	
	/// FDFoundation: Integer from character (if applicable).
	///
	///		Character("1").fd_int -> 1
	///		Character("A").fd_int -> nil
	///
	public var fd_int: Int? {
		return Int(String(self))
	}
	
	/// FDFoundation: String from character.
	///
	///		Character("a").fd_string -> "a"
	///
	public var fd_string: String {
		return String(self)
	}
	
	/// FDFoundation: Return the character lowercased.
	///
	///		Character("A").fd_lowercased -> Character("a")
	///
	public var fd_lowercased: Character {
		return String(self).lowercased().first!
	}
	
	/// FDFoundation: Return the character uppercased.
	///
	///		Character("a").fd_uppercased -> Character("A")
	///
	public var fd_uppercased: Character {
		return String(self).uppercased().first!
	}
	
}

// MARK: - Operators
public extension Character {
	
	/// FDFoundation: Repeat character multiple times.
	///
	///		Character("-") * 10 -> "----------"
	///
	/// - Parameters:
	///   - lhs: character to repeat.
	///   - rhs: number of times to repeat character.
	/// - Returns: string with character repeated n times.
	public static func * (lhs: Character, rhs: Int) -> String {
		guard rhs > 0 else {
			return ""
		}
		return String(repeating: String(lhs), count: rhs)
	}
}
