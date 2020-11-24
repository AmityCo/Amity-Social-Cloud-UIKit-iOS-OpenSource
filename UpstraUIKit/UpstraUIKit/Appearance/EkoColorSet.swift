//
//  EkoColorSet.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

struct EkoColorSet {
    
    static var primary: UIColor {
        return EkoThemeManager.currentTheme.primary
    }
    static var secondary: UIColor {
        return EkoThemeManager.currentTheme.secondary
    }
    static var alert: UIColor {
        return EkoThemeManager.currentTheme.alert
    }
    static var highlight: UIColor {
        return EkoThemeManager.currentTheme.highlight
    }
    static var base: UIColor {
        return EkoThemeManager.currentTheme.base
    }
    static var baseInverse: UIColor {
        return EkoThemeManager.currentTheme.baseInverse
    }
    static var messageBubble: UIColor {
        return EkoThemeManager.currentTheme.messageBubble
    }
    static var messageBubbleInverse: UIColor {
        return EkoThemeManager.currentTheme.messageBubbleInverse
    }
    
    static var backgroundColor: UIColor {
        return UIColor.white
    }
    
}
