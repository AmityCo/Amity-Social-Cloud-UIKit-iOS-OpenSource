//
//  AmityBlendColor.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 21/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

enum ColorBlendingOption: CGFloat, CaseIterable {
    case shade1 = 25
    case shade2 = 40
    case shade3 = 50
    case shade4 = 75
}

extension UIColor {
    
    func blend(_ option: ColorBlendingOption) -> UIColor {
        
        let luminant = option.rawValue
        let key = AmityColorCache.shared.key(for: self, lum: luminant)
        
        if let color = AmityColorCache.shared.getColor(key: key) {
            return color
        } else {
            var hslColor = rgbToHsl()
            hslColor.lum += option.rawValue
            let blendedColor = hslToRgb(h: hslColor.hue, s: hslColor.sat, l: hslColor.lum)
            AmityColorCache.shared.setColor(key: key, color: blendedColor)
            return blendedColor
        }
    }
    
    // Color will be blended with HSL system
    // by adding a lightness value within range 0 - 100
    // https://css-tricks.com/converting-color-spaces-in-javascript
    private func hslToRgb(h: CGFloat, s: CGFloat, l: CGFloat) -> UIColor {
        let h = h
        let s = s / 100
        let l = l / 100
        let c: CGFloat = (1 - abs(2 * l - 1)) * s
        let x: CGFloat = c * (1 - abs((h / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = l - c/2
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        if (0 <= h && h < 60) {
            r = c; g = x; b = 0;
        } else if (60 <= h && h < 120) {
            r = x; g = c; b = 0;
        } else if (120 <= h && h < 180) {
            r = 0; g = c; b = x;
        } else if (180 <= h && h < 240) {
            r = 0; g = x; b = c;
        } else if (240 <= h && h < 300) {
            r = x; g = 0; b = c;
        } else if (300 <= h && h < 360) {
            r = c; g = 0; b = x;
        }
        r = min(r + m, 1)
        g = min(g + m, 1)
        b = min(b + m, 1)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    private func rgbToHsl() -> (hue: CGFloat, sat: CGFloat, lum: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        
        // Find greatest and smallest channel values
        let cmin = min(r,g,b)
        let cmax = max(r,g,b)
        let delta = cmax - cmin
        var h: CGFloat = 0
        var s: CGFloat = 0
        var l: CGFloat = 0
        // Calculate hue
        if (delta == 0) {
            // No difference
            h = 0
        } else if (cmax == r) {
            // Red is max
            h = ((g - b) / delta).truncatingRemainder(dividingBy: 6)
        } else if (cmax == g) {
            // Green is max
            h = (b - r) / delta + 2
        } else {
            // Blue is max
            h = (r - g) / delta + 4
        }
        h = round(h * 60)
        // Make negative hues positive behind 360°
        if (h < 0) {
            h += 360
        }
        // Calculate lightness
        l = (cmax + cmin) / 2
        
        // Calculate saturation
        s = delta == 0 ? 0 : delta / (1 - abs(2 * l - 1))
        
        // Multiply l and s by 100
        s = round(s * 100)
        l = round(l * 100)
        
        return (hue: h, sat: s, lum: l)
    }
    
}

private class AmityColorCache {
    
    private let cache = NSCache<NSString, UIColor>()
    static let shared = AmityColorCache()
    
    func getColor(key: String) -> UIColor? {
        let color = cache.object(forKey: key as NSString)
        return color
    }
    
    func setColor(key: String, color: UIColor) {
        cache.setObject(color, forKey: key as NSString)
    }
    
    func key(for color: UIColor, lum: CGFloat) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        let keyPattern = "\(r)_\(g)_\(b)_\(lum)"
        return keyPattern
    }
    
}
