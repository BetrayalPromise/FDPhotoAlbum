//
//  UIButtonExtension.swift
//  FDFoundation
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/24.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Properties
public extension UIButton {
    
    /// FDFoundation: Image of disabled state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_imageForDisabled: UIImage? {
        get {
            return image(for: .disabled)
        }
        set {
            setImage(newValue, for: .disabled)
        }
    }
    
    /// FDFoundation: Image of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_imageForHighlighted: UIImage? {
        get {
            return image(for: .highlighted)
        }
        set {
            setImage(newValue, for: .highlighted)
        }
    }
    
    /// FDFoundation: Image of normal state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_imageForNormal: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    /// FDFoundation: Image of selected state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }
    
    /// FDFoundation: Title color of disabled state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_titleColorForDisabled: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }
    
    /// FDFoundation: Title color of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_titleColorForHighlighted: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }
    
    /// FDFoundation: Title color of normal state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_titleColorForNormal: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    /// FDFoundation: Title color of selected state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_titleColorForSelected: UIColor? {
        get {
            return titleColor(for: .selected)
        }
        set {
            setTitleColor(newValue, for: .selected)
        }
    }
    
    /// FDFoundation: Title of disabled state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_titleForDisabled: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }
    
    /// FDFoundation: Title of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_titleForHighlighted: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }
    
    /// FDFoundation: Title of normal state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_titleForNormal: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    /// FDFoundation: Title of selected state for button; also inspectable from Storyboard.
    @IBInspectable public var fd_titleForSelected: String? {
        get {
            return title(for: .selected)
        }
        set {
            setTitle(newValue, for: .selected)
        }
    }
    
}

// MARK: - Methods
public extension UIButton {
    
    private var fd_states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    /// FDFoundation: Set image for all states.
    ///
    /// - Parameter image: UIImage.
    public func fd_setImageForAllStates(_ image: UIImage) {
        fd_states.forEach { self.setImage(image, for: $0) }
    }
    
    /// FDFoundation: Set title color for all states.
    ///
    /// - Parameter color: UIColor.
    public func fd_setTitleColorForAllStates(_ color: UIColor) {
        fd_states.forEach { self.setTitleColor(color, for: $0) }
    }
    
    /// FDFoundation: Set title for all states.
    ///
    /// - Parameter title: title string.
    public func fd_setTitleForAllStates(_ title: String) {
        fd_states.forEach { self.setTitle(title, for: $0) }
    }
    
    /// FDFoundation: Center align title text and image on UIButton
    ///
    /// - Parameter spacing: spacing between UIButton title text and UIButton Image.
    public func fd_centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
}


