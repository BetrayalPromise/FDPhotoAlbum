//
//  NSAttributedStringExtensions.swift
//  FDFoundation
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/23.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//


// MARK: - Properties
public extension NSAttributedString {
    
    /// FDFoundation: Bolded string.
    public var fd_bolded: NSAttributedString {
        return fd_applying(attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    /// FDFoundation: Underlined string.
    public var fd_underlined: NSAttributedString {
        return fd_applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    #if os(iOS)
    /// FDFoundation: Italicized string.
    public var fd_italicized: NSAttributedString {
        return fd_applying(attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif
    
    /// FDFoundation: Struckthrough string.
    public var fd_struckthrough: NSAttributedString {
        return fd_applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    
    /// FDFoundation: Dictionary of the attributes applied across the whole string
    public var fd_attributes_p: [NSAttributedString.Key: Any] {
        return attributes(at: 0, effectiveRange: nil)
    }
    
}

// MARK: - Methods
public extension NSAttributedString {
    
    /// FDFoundation: Applies given attributes to the new instance of NSAttributedString initialized with self object
    ///
    /// - Parameter attributes: Dictionary of attributes
    /// - Returns: NSAttributedString with applied attributes
    fileprivate func fd_applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)
        
        return copy
    }
    
    /// FDFoundation: Add color to NSAttributedString.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    public func fd_colored(with color: UIColor) -> NSAttributedString {
        return fd_applying(attributes: [.foregroundColor: color])
    }
    
    /// FDFoundation: Apply attributes to substrings matching a regular expression
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - pattern: a regular expression to target
    /// - Returns: An NSAttributedString with attributes applied to substrings matching the pattern
    public func fd_applying(attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }
        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)
        
        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }
        return result
    }
    
    /// FDFoundation: Apply attributes to occurrences of a given string
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - target: a subsequence string for the attributes to be applied to
    /// - Returns: An NSAttributedString with attributes applied on the target string
    public func fd_applying<T: StringProtocol>(attributes: [NSAttributedString.Key: Any], toOccurrencesOf target: T) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"
        
        return fd_applying(attributes: attributes, toRangesMatching: pattern)
    }
    
    /// FDFoundation: UIFont or NSFont, default Helvetica(Neue) 12.
    ///
    /// - Parameters:
    ///   - font: UIFont or NSFont, default Helvetica(Neue) 12.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_font(_ font: FDFont, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: NSParagraphStyle, default defaultParagraphStyle
    ///
    /// - Parameters:
    ///   - paragraphStyle: NSParagraphStyle, default defaultParagraphStyle
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_paragraphStyle(_ paragraphStyle: NSParagraphStyle, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: UIColor or NSColor, default black.
    ///
    /// - Parameters:
    ///   - foregroundColor: UIColor or NSColor, default black.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_foregroundColor(_ foregroundColor: FDColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: foregroundColor, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: UIColor or NSColor, default nil means no background.
    ///
    /// - Parameters:
    ///   - backgroundColor: UIColor or NSColor, default nil means no background.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_backgroundColor(_ backgroundColor: FDColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: backgroundColor, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: Default true means default ligatures, false means no ligatures.
    ///
    /// - Parameters:
    ///   - ligature: Default true means default ligatures, false means no ligatures.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_ligature(_ ligature: Bool, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.ligature, value: ligature, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: Amount to modify default kerning.
    /// 0 means kerning is disabled.
    ///
    /// - Parameters:
    ///   - kern: Amount to modify default kerning.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_kern(_ kern: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.kern, value: kern, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: Default 0 means no strikethrough.
    ///
    /// - Parameters:
    ///   - strikethroughStyle: Default 0 means no strikethrough.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_strikethroughStyle(_ strikethroughStyle: Int, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: strikethroughStyle, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: NSUnderlineStyle.
    ///
    /// - Parameters:
    ///   - underlineStyle: NSUnderlineStyle.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_underlineStyle(_ underlineStyle: NSUnderlineStyle, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: underlineStyle, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: UIColor or NSColor, default nil means same as foreground color.
    ///
    /// - Parameters:
    ///   - strokeColor: UIColor or NSColor, default nil means same as foreground color.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_strokeColor(_ strokeColor: FDColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.strokeColor, value: strokeColor, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: In percent of font point size, default 0 measn no stroke.
    /// Positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0).
    ///
    /// - Parameters:
    ///   - strokeWidth: In percent of font point size, default 0 measn no stroke.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_strokeWidth(_ strokeWidth: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.strokeWidth, value: strokeWidth, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: NSShadow, default nil means no shadow.
    ///
    /// - Parameters:
    ///   - shadow: NSShadow, default nil means no shadow.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_shadow(_ shadow: NSShadow, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.shadow, value: shadow, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: Default nil means no text effect.
    ///
    /// - Parameters:
    ///   - textEffect: Default is nil means no text effect. Currently, only NSTextEffectLetterpressStyle can be used.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_textEffect(_ textEffect: String, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.textEffect, value: textEffect, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: NSTextAttachment, default is nil.
    ///
    /// - Parameters:
    ///   - attachment: NSTextAttachment, default is nil.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_attachment(_ attachment: NSTextAttachment, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.attachment, value: attachment, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: NSURL.
    ///
    /// - Parameters:
    ///   - link: NSURL.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_link(_ link: NSURL, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.link, value: link, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: Offset from baseline, default is 0.
    ///
    /// - Parameters:
    ///   - baselineOffset: Offset from baseline, default is 0.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_baselineOffset(_ baselineOffset: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: baselineOffset, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: UIColor or NSColor, default nil means same as foreground color.
    ///
    /// - Parameters:
    ///   - underlineColor: UIColor or NSColor, default nil means same as foreground color.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_underlineColor(_ underlineColor: FDColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.underlineColor, value: underlineColor, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: UIColor or NSColor, default nil means same as foreground color.
    ///
    /// - Parameters:
    ///   - strikethroughColor: UIColor or NSColor, default nil means same as foreground color.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_strikethroughColor(_ strikethroughColor: FDColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: strikethroughColor, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: Skew to be applied to glyphs, default 0 means no skew.
    ///
    /// - Parameters:
    ///   - obliqueness: Skew to be applied to glyphs, default 0 means no skew.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_obliqueness(_ obliqueness: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.obliqueness, value: obliqueness, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: Log of expansion factor to be applied to glyphs, default 0 means no expansion.
    ///
    /// - Parameters:
    ///   - expansion: Log of expansion factor to be applied to glyphs, default 0 means no expansion.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_expansion(_ expansion: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.expansion, value: expansion, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: Array of Int representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.
    /// The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.
    /// Remeber to use `.rawValue`, because the attribute wants an Int.
    /// - LRE: NSWritingDirection.leftToRight, NSWritingDirectionFormatType.embedding.
    /// - RLE: NSWritingDirection.rightToLeft, NSWritingDirectionFormatType.embedding.
    /// - LRO: NSWritingDirection.leftToRight, NSWritingDirectionFormatType.override.
    /// - RLO: NSWritingDirection.rightToLeft, NSWritingDirectionFormatType.override.
    ///
    /// - Parameters:
    ///   - writingDirection: Array of Int representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_writingDirection(_ writingDirection: [Int], range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.writingDirection, value: writingDirection, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: The value 0 indicates horizontal text, the value 1 indicates vertical text.
    /// In iOS, horizontal text is always used and specifying a different value is undefined.
    ///
    /// - Parameters:
    ///   - verticalGlyphForm: The value false indicates horizontal text, the value true indicates vertical text.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    public func fd_verticalGlyphForm(_ verticalGlyphForm: Bool, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.fd_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: verticalGlyphForm, range: fd_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// FDFoundation: Set text alignment to left.
    ///
    /// - Returns: Returns a NSAttributedString.
    public func fd_textAlignmentLeft() -> NSAttributedString {
        return self.fd_textAlignment(.left)
    }
    
    /// FDFoundation: Set text alignment to right.
    ///
    /// - Returns: Returns a NSAttributedString.
    public func fd_textAlignmentRight() -> NSAttributedString {
        return self.fd_textAlignment(.right)
    }
    
    /// FDFoundation: Set text alignment to center.
    ///
    /// - Returns: Returns a NSAttributedString.
    public func fd_textAlignmentCenter() -> NSAttributedString {
        return self.fd_textAlignment(.center)
    }
    
    /// FDFoundation: Set text alignment to justified.
    ///
    /// - Returns: Returns a NSAttributedString.
    public func fd_textAlignmentJustified() -> NSAttributedString {
        return self.fd_textAlignment(.justified)
    }
    
    /// FDFoundation: Returns a list of all string attributes.
    ///
    /// - Returns: Returns a list of all string attributes.
    public func fd_attributes() -> [NSAttributedString.Key: Any] {
        return self.attributes(at: 0, longestEffectiveRange: nil, in: self.fd_attributedStringRange(nil))
    }
    
    /// FDFoundation: Set text alignment.
    ///
    /// - Parameter alignment: Text alignment.
    /// - Returns: Returns an NSAttributedString with the given text alignment.
    private func fd_textAlignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let textAlignment = NSMutableParagraphStyle()
        textAlignment.alignment = alignment
        
        return self.fd_paragraphStyle(textAlignment)
    }
    
    /// FDFoundation: Returns self NSRange if the given NSRange is nil.
    ///
    /// - Parameter range: Given NSRange.
    /// - Returns: Returns self NSRange if the given NSRange is nil.
    private func fd_attributedStringRange(_ range: NSRange?) -> NSRange {
        return range ?? NSRange(location: 0, length: self.string.fd_length)
    }
    
}




// MARK: - Operators
public extension NSAttributedString {
    
    /// FDFoundation: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    public static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        lhs = ns
    }
    
    /// FDFoundation: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        return NSAttributedString(attributedString: ns)
    }
    
    /// FDFoundation: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    public static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }
    
    /// FDFoundation: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
    
}







