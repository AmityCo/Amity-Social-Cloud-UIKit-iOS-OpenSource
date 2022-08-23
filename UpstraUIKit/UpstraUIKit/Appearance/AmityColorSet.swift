//
//  AmityColorSet.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

public struct AmityColorSet {
    
    public static var primary: UIColor {
        return AmityThemeManager.currentTheme.primary
    }
    public static var secondary: UIColor {
        return AmityThemeManager.currentTheme.secondary
    }
    public static var alert: UIColor {
        return AmityThemeManager.currentTheme.alert
    }
    public static var highlight: UIColor {
        return AmityThemeManager.currentTheme.highlight
    }
    public static var base: UIColor {
        return AmityThemeManager.currentTheme.base
    }
    public static var baseInverse: UIColor {
        return AmityThemeManager.currentTheme.baseInverse
    }
    public static var messageBubble: UIColor {
        return AmityThemeManager.currentTheme.messageBubble
    }
    public static var messageBubbleInverse: UIColor {
        return AmityThemeManager.currentTheme.messageBubbleInverse
    }
    public static var backgroundColor: UIColor {
        return UIColor.white
    }
    
}
