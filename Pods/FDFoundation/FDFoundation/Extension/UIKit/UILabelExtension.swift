//
//  UILabelExtension.swift
//  FDFoundation
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/24.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//


public typealias FDLabel = UILabel

// MARK: - Properties
public extension FDLabel {
    
    /// FDFoundation: Required height for a label
    public var fd_requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}


// MARK: - Methods
public extension FDLabel {
    
    /// FDFoundation: Sets a custom font from a character at an index to character at another index.
    ///
    /// - Parameters:
    ///   - font: New font to be setted.
    ///   - fromIndex: The start index.
    ///   - toIndex: The end index.
    public func fd_setFont(_ font: FDFont, fromIndex: Int, toIndex: Int) {
        guard let text = self.text else {
            return
        }
        
        self.attributedText = text.fd_attributedString.fd_font(font, range: NSRange(location: fromIndex, length: toIndex - fromIndex))
    }
    
    /// FDFoundation: Sets a custom font from a character at an index to character at another index.
    ///
    /// - Parameters:
    ///   - font: New font to be setted.
    ///   - fontSize: New font size.
    ///   - fromIndex: The start index.
    ///   - toIndex: The end index.
    public func fd_setFont(_ font: FDFontName, fontSize: CGFloat, fromIndex: Int, toIndex: Int) {
        guard let text = self.text else {
            return
        }
        
        self.attributedText = text.fd_attributedString.fd_font(FDFont(fd_fontName: font, fd_size: fontSize), range: NSRange(location: fromIndex, length: toIndex - fromIndex))
    }
    
    
    /// FDFoundation
    public func fd_getEstimatedSize(_ width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: height))
    }
    
    /// FDFoundation
    public func fd_getEstimatedHeight() -> CGFloat {
        return sizeThatFits(CGSize(width: fd_width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    /// FDFoundation
    public func fd_getEstimatedWidth() -> CGFloat {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fd_height)).width
    }
    
    /// FDFoundation
    public func fd_fitHeight() {
        self.fd_height = fd_getEstimatedHeight()
    }
    
    /// FDFoundation
    public func fd_fitWidth() {
        self.fd_width = fd_getEstimatedWidth()
    }
    
    /// FDFoundation
    public func fd_fitSize() {
        self.fd_fitWidth()
        self.fd_fitHeight()
        sizeToFit()
    }
    
    /// FDFoundation (if duration set to 0 animate wont be)
    public func fd_set(text _text: String?, duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            self.text = _text
        }, completion: nil)
    }
    
}


// MARK: - Initializers
public extension FDLabel {
    
    /// FDFoundation: Initialize a UILabel with text
    public convenience init(fd_text: String?) {
        self.init()
        self.text = fd_text
    }
    
    /// FDFoundation: Create an UILabel with the given parameters.
    ///
    /// - Parameters:
    ///   - frame: Label frame.
    ///   - text: Label text.
    ///   - font: Label font.
    ///   - color: Label text color.
    ///   - alignment: Label text alignment.
    ///   - lines: Label text lines.
    ///   - shadowColor: Label text shadow color.
    public convenience init(fd_frame: CGRect, fd_text: String, fd_font: UIFont, fd_color: UIColor = .black, fd_alignment: NSTextAlignment = .left, fd_lines: Int, fd_shadowColor: UIColor = UIColor.clear) {
        self.init(frame: fd_frame)
        self.font = fd_font
        self.text = fd_text
        self.backgroundColor = UIColor.clear
        self.textColor = fd_color
        self.textAlignment = fd_alignment
        self.numberOfLines = fd_lines
        self.shadowColor = fd_shadowColor
    }
    
    /// FDFoundation: Create an UILabel with the given parameters.
    ///
    /// - Parameters:
    ///   - frame: Label frame.
    ///   - text: Label text.
    ///   - font: Label font name.
    ///   - size: Label font size.
    ///   - color: Label text color.
    ///   - alignment: Label text alignment.
    ///   - lines: Label text lines.
    ///   - shadowColor: Label text shadow color.
    public convenience init(fd_frame: CGRect, fd_text: String, fd_font: FDFontName, fd_fontSize: CGFloat, fd_color: UIColor = .black, fd_alignment: NSTextAlignment = .left, fd_lines: Int, fd_shadowColor: UIColor = UIColor.clear) {
        self.init(frame: fd_frame)
        self.font = FDFont(fd_fontName: fd_font, fd_size: fd_fontSize)
        self.text = fd_text
        self.backgroundColor = UIColor.clear
        self.textColor = fd_color
        self.textAlignment = fd_alignment
        self.numberOfLines = fd_lines
        self.shadowColor = fd_shadowColor
    }
}



