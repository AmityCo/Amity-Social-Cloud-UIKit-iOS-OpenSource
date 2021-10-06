//
//  UIImage+Extension.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 20/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
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
}

extension UIImageView {
    
    // This can be expanded to support error image, placeholder and all
    func setImage(withFileId id: String, placeholder: UIImage?) {
        self.image = placeholder
        UpstraUIKitManagerInternal.shared.fileService.loadImage(with: id, size: .medium) { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
            case .failure(let error):
                Log.add("Error while downloading image with file id: \(id) error: \(error)")
            }
        }
    }
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
