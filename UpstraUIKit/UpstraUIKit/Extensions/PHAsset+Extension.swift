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
        
        let contentMode: PHImageContentMode = targetSize == nil ? .default : .aspectFill
        manager.requestImage(for: self, targetSize: targetSize ?? PHImageManagerMaximumSize, contentMode: contentMode, options: options) { (result, info) in
            if let result = result, let imageData = result.pngData(), let pngImage = UIImage(data: imageData) {
                completion?(.success(pngImage))
            } else {
                completion?(.failure(AmityError.unknown))
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
                
                guard let editingInput = contentEditingInput, let imageURL = editingInput.fullSizeImageURL as URL? else {
                    completion(nil)
                    return
                }
                
                // For now BE supports .JPG, .JPEG, .PNG image formats
                // Convert the image to png in case the image is another format
                let absoluteString = imageURL.absoluteString.lowercased()
                if absoluteString.hasSuffix(".jpg") || absoluteString.hasSuffix(".jpeg") || absoluteString.hasSuffix(".png") {
                    completion(imageURL)
                    return
                }
                
                if let url = AmityMediaConverter.convertImage(fromPath: imageURL.absoluteString) {
                    completion(url)
                    return
                }
                
                completion(nil)
            })
        case .video:
            PHCachingImageManager().requestAVAsset(forVideo: self, options: nil) { asset, audioMix, info in
                if let asset = asset as? AVURLAsset {
                    let absoluteString = asset.url.absoluteString.lowercased()
                    
                    // Convert the video to mp4
                    guard !absoluteString.hasSuffix(".mp4") else {
                        completion(asset.url)
                        return
                    }
                    
                    AmityMediaConverter.convertVideo(asset: asset) { url in
                        completion(url)
                    }
                } else {
                    completion(nil)
                }
            }
        default:
            completion(nil)
        }
    }
    
}

