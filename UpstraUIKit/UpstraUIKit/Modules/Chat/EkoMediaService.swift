//
//  EkoMediaService.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoMediaService {
    private init() { }
    static let shared = EkoMediaService()
    private let cache = ImageCache()
    private let media = EkoMediaRepository(client: UpstraUIKitManager.shared.client)
    
    func dowloadImage(messageId: String, size: EkoMediaSize, completion: @escaping (UIImage?) -> Void) {
        if let cacheImage = cache.image(forKey: messageId) {
            completion(cacheImage)
        } else {
            media.getImageForMessageId(messageId, size: size) { [weak self] (image, size, error) in
                if let image = image {
                    self?.cache.save(image: image, forKey: messageId)
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    func saveCacheImage(_ image: UIImage, for messageId: String) {
        cache.save(image: image, forKey: messageId)
    }
    
}
