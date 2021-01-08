//
//  String+Extension.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 4/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

extension String {
    /// Apply to bold text
    /// - Parameters:
    ///   - listString: List string for make to bold
    ///   - color: normal color and bold color
    ///   - font: normal font and bold font
    /// - Returns: NSAttributedString
    func applyBold(with listString: [String],
                       color: UIColor,
                       font: (normal: UIFont, bold: UIFont)) -> NSAttributedString {
        let boldString = NSMutableAttributedString(string: self, attributes: [.foregroundColor: color,
                                                                              .font: font.normal])
        for index in 0..<listString.count {
            boldString.addAttributes([.font: font.bold], range: (self as NSString).range(of: listString[index]))
        }
        return boldString
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
