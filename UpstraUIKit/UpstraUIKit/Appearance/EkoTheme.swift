//
//  EkoTheme.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 11/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

/// Interface style
enum EkoInterfaceStyle {
    case light
    case dark
}

public struct EkoTheme {
    let primary: UIColor
    let secondary: UIColor
    let alert: UIColor
    let highlight: UIColor
    let base: UIColor
    let baseInverse: UIColor
    let messageBubble: UIColor
    let messageBubbleInverse: UIColor
    public init(primary: UIColor? = nil,
                secondary: UIColor? = nil,
                alert: UIColor? = nil,
                highlight: UIColor? = nil,
                base: UIColor? = nil,
                baseInverse: UIColor? = nil,
                messageBubble: UIColor? = nil,
                messageBubbleInverse: UIColor? = nil) {
        self.primary = primary ?? UIColor(hex: "#1054DE")
        self.secondary = secondary ?? UIColor(hex: "#292B32")
        self.alert = alert ?? UIColor(hex: "#FA4D30")
        self.highlight = highlight ?? UIColor(hex: "#1054DE")
        self.base = base ?? UIColor(hex: "#292B32")
        self.baseInverse = baseInverse ?? .white
        self.messageBubble = messageBubble ?? UIColor(hex: "#1054DE")
        self.messageBubbleInverse = messageBubbleInverse ?? UIColor(hex: "#EBECEF")
    }
    
}
