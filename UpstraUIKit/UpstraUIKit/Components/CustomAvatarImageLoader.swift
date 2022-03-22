//
//  CustomAvatarImageLoader.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 14/3/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import UIKit

public class CustomAvatarImageLoader {
    
    private let cache = NSCache<NSString, UIImage>()
    static let shared = CustomAvatarImageLoader()
    
    func loadImage(from url: String, completion: ((Result<UIImage, Error>) -> Void)?) {
        let cacheKey = NSString(string: url)
        
        let imageURL = URL(string: url)
        
        if let image = cache.object(forKey: cacheKey) {
            completion?(.success(image))
            return
        }
        
        guard let _imageURL = imageURL else {
            completion?(.failure(AmityError.unknown))
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: _imageURL),
               let image = UIImage(data: data) {
                self?.cache.setObject(image, forKey: cacheKey)
                print("Load custom url avatar success.")
                completion?(.success(image))
            } else {
                print("Load custom url avatar fail.")
                completion?(.failure(AmityError.unknown))
            }
        }
    }
    
}
