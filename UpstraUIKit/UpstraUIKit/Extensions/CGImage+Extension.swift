//
//  CGImage+Extension.swift
//  AmityUIKit
//
//  Created by Hamlet Kosakyan on 21/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit

extension CGImage {
    func rotate(fromOrientation orientation: CGImagePropertyOrientation)-> CGImage? {
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch orientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: CGFloat(width), y: CGFloat(height))
            transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: CGFloat(height), y: 0)
            transform = transform.rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: CGFloat(width))
            transform = transform.rotated(by: -.pi/2)
        case .up, .upMirrored:
            break
        }

        if let colorSpace = colorSpace, let ctx: CGContext = CGContext(data: nil, width: height, height: width, bitsPerComponent: bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
                
            ctx.concatenate(transform)
            ctx.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
            return ctx.makeImage()
        }
        
        return nil
    }
}
