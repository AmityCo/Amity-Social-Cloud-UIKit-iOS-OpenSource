//
//  PHAsset+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import Photos
import UIKit

extension PHAsset {
    
    func getImage(targetSize: CGSize? = nil, completion: ((Result<UIImage, Error>) -> Void)?) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        if let targetSize = targetSize {
            // get image size depends on target size
            manager.requestImage(for: self, targetSize: targetSize, contentMode: .aspectFill, options: options) { (result, info) in
                if let result = result {
                    completion?(.success(result))
                } else {
                    completion?(.failure(AmityError.unknown))
                }
            }
        } else {
            // get maximum image size
            manager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (result, info) in
                if let result = result {
                    completion?(.success(result))
                } else {
                    completion?(.failure(AmityError.unknown))
                }
            }
        }
    }
    
    func getURL(completion: @escaping (_ responseURL : URL?) -> Void) {
        switch mediaType {
        case .image:
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.isNetworkAccessAllowed = true
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completion(contentEditingInput?.fullSizeImageURL as URL?)
            })
        case .video:
            PHCachingImageManager().requestAVAsset(forVideo: self, options: nil) { asset, audioMix, info in
                if let asset = asset as? AVURLAsset {
                    completion(asset.url)
                } else {
                    completion(nil)
                }
            }
        default:
            completion(nil)
        }
    }
    
}

