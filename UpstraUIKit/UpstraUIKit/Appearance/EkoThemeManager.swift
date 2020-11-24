//
//  EkoThemeManager.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 7/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

class EkoThemeManager {
    private var lightTheme = EkoTheme()
    private var darkTheme = EkoTheme()
    private var interfaceStyle: EkoInterfaceStyle = .light
    private var currentTheme: EkoTheme {
        return interfaceStyle == .dark ? darkTheme : lightTheme
    }
    
    private static let defaultManager = EkoThemeManager()
    
    static var currentTheme: EkoTheme {
        return defaultManager.currentTheme
    }
    
    static func set(theme: EkoTheme, for interfaceStyle: EkoInterfaceStyle = .light) {
        if interfaceStyle == .dark {
            defaultManager.darkTheme = theme
        } else {
            defaultManager.lightTheme = theme
        }
    }
    
}
