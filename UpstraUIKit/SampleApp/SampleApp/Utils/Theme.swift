//
//  Theme.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 23/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmityUIKit

enum Preset: Int {
    case defaultPreset
    case preset1
    case preset2
    case preset3
    case preset4
    
    var theme: AmityTheme {
        switch self {
        case .defaultPreset:
            return AmityTheme()
        case .preset1:
            return AmityTheme(primary: UIColor(hex: "#18033A"))
        case .preset2:
            return AmityTheme(primary: UIColor(hex: "#DE1029"), secondary: UIColor(hex: "#32343d"))
        case .preset3:
            return AmityTheme(primary: UIColor(hex: "#0BDB91"), highlight: UIColor(hex: "#25d7f4"), messageBubble: UIColor(hex: "#25F4AA"))
        case .preset4:
            return AmityTheme(primary: .white)
        }
    }
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt64 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt64(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
