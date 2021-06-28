//
//  AmityImage.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 1/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
import Photos
import UIKit

enum AmityImageState: Equatable {
    case uploading(progress: Double)
    case uploaded(data: AmityImageData)
    case localAsset(PHAsset)
    case image(UIImage)
    case localURL(url: URL)
    case downloadable(fileURL: String, placeholder: UIImage)
    case none
    case error
    
    static func == (lhs: AmityImageState, rhs: AmityImageState) -> Bool {
        switch (lhs, rhs) {
        case (.uploaded, .uploaded):
            return true
        default:
            return false
        }
    }
    
}

public class AmityImage: Equatable, Hashable {
    let id = UUID().uuidString
    var state: AmityImageState
    
    init(state: AmityImageState) {
        self.state = state
    }
    
    func loadImage(to imageView: UIImageView, preferredSize: CGSize? = nil) {
        switch state {
        case .image(let image):
            imageView.image = image
            
        case .localAsset(let asset):
            let targetSize = preferredSize ?? imageView.bounds.size
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.version = .current
            option.resizeMode = .none
            option.deliveryMode = .highQualityFormat
            option.isNetworkAccessAllowed = true
            
            manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: option, resultHandler: { (result, info) in
                if let result = result {
                    imageView.image = result
                }
            })
            
        case .downloadable(let fileURL, let placeholder):
            imageView.loadImage(with: fileURL, size: .medium, placeholder: placeholder)
            
        case .uploaded(let imageData):
            imageView.loadImage(with: imageData.fileURL, size: .medium, placeholder: nil)
            
        case .localURL(let url):
            DispatchQueue.main.async {
                let image = UIImage(contentsOfFile: url.path)
                imageView.image = image
            }
            
        case .none, .error, .uploading:
            break
        }
    }
    
    func getLocalURLForUploading(completion: @escaping (URL?) -> Void) {
        switch state {
        case .localURL(let url):
            completion(url)
            
        case .localAsset(let asset):
            asset.getURL(completion: completion)
            
        default:
            completion(nil)
        }
    }
    
    func getImageForUploading(completion: ((Result<UIImage, Error>) -> Void)?) {
        switch state {
        case .localAsset(let asset):
            asset.getImage(completion: completion)
        case .image(let image):
            completion?(.success(image))
            
        case .downloadable, .uploaded, .none, .uploading, .error, .localURL:
            assertionFailure("This function for uploading process")
            completion?(.failure(AmityError.unknown))
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: AmityImage, rhs: AmityImage) -> Bool {
        return lhs.id == rhs.id
    }
}
