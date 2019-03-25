//
//  ButtonUtils.swift
//  FDPhotoAlbum
//
//  Created by Chunyang Li 李春阳 on 2019/3/19.
//

import UIKit

extension UIButton {
    public func setTitle(_ title: String?, for states: [UIControl.State]) {
        for s in states {
            self.setTitle(title, for: s)
        }
    }
    
    public func setTitleColor(_ color: UIColor?, for states: [UIControl.State]) {
        for s in states {
            self.setTitleColor(color, for: s)
        }
    }
    
    public func setTitleShadowColor(_ color: UIColor?, for states: [UIControl.State]) {
        for s in states {
            self.setTitleShadowColor(color, for: s)
        }
    }
    
    public func setImage(_ image: UIImage?, for states: [UIControl.State]) {
        for s in states {
            self.setImage(image, for: s)
        }
    }
    
    public func setBackgroundImage(_ image: UIImage?, for states: [UIControl.State]) {
        for s in states {
            self.setBackgroundImage(image, for: s)
        }
    }
    
    public func setAttributedTitle(_ title: NSAttributedString?, for states: [UIControl.State]) {
        for s in states {
            self.setAttributedTitle(title, for: s)
        }
    }
    
    public func title(for states: [UIControl.State]) -> [String] {
        var titles: [String] = []
        for s in states {
            titles.append(self.title(for: s) ?? "")
        }
        return titles
    }
    
    public func titleColor(for states: [UIControl.State]) -> [UIColor] {
        var colors: [UIColor] = []
        for s in states {
            colors.append(self.titleColor(for: s) ?? UIColor.white.withAlphaComponent(0.0))
        }
        return colors
    }
    
    public func titleShadowColor(for states: [UIControl.State]) -> [UIColor] {
        var colors: [UIColor] = []
        for s in states {
            colors.append(self.titleShadowColor(for: s) ?? UIColor.white.withAlphaComponent(0.0))
        }
        return colors
    }
    
    
    public func image(for states: [UIControl.State]) -> [UIImage] {
        var images: [UIImage] = []
        for s in states {
            images.append(self.image(for: s) ?? UIImage())
        }
        return images
    }
    
    public func backgroundImage(for states: [UIControl.State]) -> [UIImage] {
        var images: [UIImage] = []
        for s in states {
            images.append(self.backgroundImage(for: s) ?? UIImage())
        }
        return images
    }
    
    public func attributedTitle(for states: [UIControl.State]) -> [NSAttributedString] {
        var strings: [NSAttributedString] = []
        for s in states {
            strings.append(self.attributedTitle(for: s) ?? NSAttributedString())
        }
        return strings
    }
}
