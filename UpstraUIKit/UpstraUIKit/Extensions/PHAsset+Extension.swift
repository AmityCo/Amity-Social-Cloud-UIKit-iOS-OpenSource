//
//  PHAsset+Extension.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
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
                    completion?(.failure(EkoError.unknown))
                }
            }
        } else {
            // get maximum image size
            manager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (result, info) in
                if let result = result {
                    completion?(.success(result))
                } else {
                    completion?(.failure(EkoError.unknown))
                }
            }
        }
    }
    
}

