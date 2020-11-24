//
//  EkoImageCache.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 9/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class ImageCache {
    
    private let cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> (UIImage?) {
        return (cache.object(forKey: key as NSString))
    }

    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func removeCache(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeeAllCache() {
        cache.removeAllObjects()
    }
}
