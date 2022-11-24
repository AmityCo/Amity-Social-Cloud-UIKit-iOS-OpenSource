//
//  String+Extension.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import SwiftUI

public extension String {
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
    
    var localizedString: String {
        switch AmityUIKitManagerInternal.shared.amityLanguage {
        case "th":
            return NSLocalizedString(self, tableName: "LocalizedThai", bundle: AmityUIKitManager.bundle, value: "", comment: "")
        case "id":
            return NSLocalizedString(self, tableName: "LocalizedIndonesia", bundle: AmityUIKitManager.bundle, value: "", comment: "")
        case "km":
            return NSLocalizedString(self, tableName: "LocalizedCambodia", bundle: AmityUIKitManager.bundle, value: "", comment: "")
        case "fil":
            return NSLocalizedString(self, tableName: "LocalizedPhilippin", bundle: AmityUIKitManager.bundle, value: "", comment: "")
        case "vi":
            return NSLocalizedString(self, tableName: "LocalizedVietnam", bundle: AmityUIKitManager.bundle, value: "", comment: "")
        case "my":
            return NSLocalizedString(self, tableName: "LocalizedMyanmar", bundle: AmityUIKitManager.bundle, value: "", comment: "")
        case "en":
            return NSLocalizedString(self, tableName: "LocalizedEnglish", bundle: AmityUIKitManager.bundle, value: "", comment: "")
        default:
            return NSLocalizedString(self, tableName: "LocalizedEnglish", bundle: AmityUIKitManager.bundle, value: "", comment: "")
        }
    }
    
    var getLocalizedStringEN: String {
        return NSLocalizedString(self, tableName: "LocalizedEnglish", bundle: AmityUIKitManager.bundle, value: "", comment: "")
    }
    
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func removeRegexMatches() -> String {
        if AmityUIKitManagerInternal.shared.jsonRegex.ios {
            let pattern = #"(?:\+?66[689]{1}|0[689]{1})(?:[\-\s0-9]{1}.*)\d"#
            let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
            let stringRange = NSRange(location: 0, length: self.utf16.count)
            let matches = regex.matches(in: self, range: stringRange)
            var result: [[String]] = []
            for match in matches {
                var groups: [String] = []
                let string = (self as NSString).substring(with: match.range)
                groups.append(string)
                if !groups.isEmpty {
                    result.append(groups)
                }
            }
            
            var textString: String = self
            if !result.isEmpty {
                for value in result {
                    for text in value {
                        if self.contains(text) {
                            let stringMarking = text.dropLast(4) + "xxxx"
                            textString = textString.replacingOccurrences(of: text, with: stringMarking)
                        }
                    }
                }
            }
                        
            return textString
        } else {
            return self
        }
    }
    
}
