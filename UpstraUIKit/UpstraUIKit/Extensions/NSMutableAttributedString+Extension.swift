//
//  NSMutableAttributedString+Extension.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(.foregroundColor, value: color, range: range)
    }

}
