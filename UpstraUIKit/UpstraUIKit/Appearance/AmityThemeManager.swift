//
//  AmityThemeManager.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 7/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

class AmityThemeManager {
    private var lightTheme = AmityTheme()
    private var darkTheme = AmityTheme()
    private var interfaceStyle: AmityInterfaceStyle = .light
    private var currentTheme: AmityTheme {
        return interfaceStyle == .dark ? darkTheme : lightTheme
    }
    
    private static let defaultManager = AmityThemeManager()
    
    static var currentTheme: AmityTheme {
        return defaultManager.currentTheme
    }
    
    static func set(theme: AmityTheme, for interfaceStyle: AmityInterfaceStyle = .light) {
        if interfaceStyle == .dark {
            defaultManager.darkTheme = theme
        } else {
            defaultManager.lightTheme = theme
        }
    }
    
}
