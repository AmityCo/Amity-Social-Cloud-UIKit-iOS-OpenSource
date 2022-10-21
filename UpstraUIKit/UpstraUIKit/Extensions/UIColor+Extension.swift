//
//  UIColor+Extension.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 2/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

extension UIColor {
    /// This is a function that takes a hex string and returns a UIColor
    /// (You can enter hex strings with either format: #ffffff or ffffff)
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
    
    /// Creates an UIImage instance filled with this color
    func asImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { context in
            self.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
}
