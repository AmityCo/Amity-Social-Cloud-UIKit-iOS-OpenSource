//
//  EkoAttributedString.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

final class EkoAttributedString {
    private var fullText: String = ""
    private var boldText: [String] = []
    private var boldFont: UIFont = UIFont.systemFont(ofSize: 14)
    private var normalFont: UIFont = UIFont.boldSystemFont(ofSize: 16)
    private var color: UIColor = .black
    
    @discardableResult
    func setTitle(_ text: String) -> EkoAttributedString {
        fullText = text
        return self
    }
    
    @discardableResult
    func setBoldText(for text: [String]) -> EkoAttributedString {
        boldText = text
        return self
    }
    
    @discardableResult
    func setBoldFont(for font: UIFont) -> EkoAttributedString {
        boldFont = font
        return self
    }
    
    @discardableResult
    func setNormalFont(for font: UIFont) -> EkoAttributedString {
        normalFont = font
        return self
    }
    
    @discardableResult
    func setColor(for color: UIColor) -> EkoAttributedString {
        self.color = color
        return self
    }
    
    func build() -> NSAttributedString {
        return fullText.applyBold(with: boldText, color: color, font: (normalFont, boldFont))
    }
}
