//
//  UIImage+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 20/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func setTintColor(_ color: UIColor) -> UIImage {
        if #available(iOS 13.0, *) {
            return self.withTintColor(color)
        } else {
            return self
        }
    }
    
    func thumbnail(pixel: Int = 1000) -> UIImage? {
        
        guard let imageData = self.pngData() else { return nil }
        var thumbnail: UIImage?
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: pixel
            ] as CFDictionary
        
        imageData.withUnsafeBytes { [weak self] ptr in
            guard let strongSelf = self else { return }
            guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return
            }
            if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, imageData.count) {
                let source = CGImageSourceCreateWithData(cfData, nil)!
                let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
                thumbnail = UIImage(cgImage: imageReference, scale: strongSelf.scale, orientation: strongSelf.imageOrientation)
            }
        }
        
        return thumbnail
    }
    
    func scalePreservingAspectRatio(targetSize: CGSize = CGSize(width: 1600, height: 1600)) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // If the current size is smaller than target size, returns the current size.
        guard scaleFactor < 1 else { return self }
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
}
