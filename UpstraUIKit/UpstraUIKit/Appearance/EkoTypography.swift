//
//  EkoTypography.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 10/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

// Note
// See more:
// https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/
// https://uxdesign.cc/a-five-minute-guide-to-better-typography-for-ios-4e3c2715ceb4
// https://docs.sendbird.com/ios/ui_kit_themes#3_fontset_4_customize_font

public struct EkoTypography {
    let headerLine: UIFont
    let title: UIFont
    let bodyBold: UIFont
    let body: UIFont
    let captionBold: UIFont
    let caption: UIFont
    
    public init(headerLine: UIFont = .systemFont(ofSize: 20, weight: .bold),
                title: UIFont = .systemFont(ofSize: 17, weight: .semibold),
                bodyBold: UIFont = .systemFont(ofSize: 15, weight: .semibold),
                body: UIFont = .systemFont(ofSize: 15, weight: .regular),
                captionBold: UIFont = .systemFont(ofSize: 13, weight: .semibold),
                caption: UIFont = .systemFont(ofSize: 13, weight: .regular) ) {
        self.headerLine = headerLine
        self.title = title
        self.bodyBold = bodyBold
        self.body = body
        self.captionBold = captionBold
        self.caption = caption
    }
}

class EkoFontSet {
    static private(set) var currentTypography: EkoTypography = EkoTypography()
    static func set(typography: EkoTypography) {
        currentTypography = typography
    }
    static var headerLine: UIFont {
        return currentTypography.headerLine
    }
    static var title: UIFont {
        return currentTypography.title
    }
    static var bodyBold: UIFont {
        return currentTypography.bodyBold
    }
    static var body: UIFont {
        return currentTypography.body
    }
    static var captionBold: UIFont {
        return currentTypography.captionBold
    }
    static var caption: UIFont {
        return currentTypography.caption
    }
}
