//
//  EkoImage.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 1/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat
import Photos
import UIKit

enum EkoImageState: Equatable {
    case uploading(progress: Double)
    case uploaded(data: EkoImageData)
    case localAsset(PHAsset)
    case image(UIImage)
    case downloadable(fileId: String, placeholder: UIImage)
    case none
    case error
    
    static func == (lhs: EkoImageState, rhs: EkoImageState) -> Bool {
        switch (lhs, rhs) {
        case (.uploaded, .uploaded):
            return true
        default:
            return false
        }
    }
    
}

public class EkoImage: Equatable, Hashable {
    let id = UUID().uuidString
    var state: EkoImageState
    
    init(state: EkoImageState) {
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
            
        case .downloadable(let fileId, let placeholder):
            imageView.setImage(withFileId: fileId, placeholder: placeholder)
            
        case .uploaded(let imageData):
            imageView.setImage(withFileId: imageData.fileId, placeholder: nil)
            
        case .none, .error, .uploading:
            break
        }
    }
    
    func getImageForUploading(completion: ((Result<UIImage, Error>) -> Void)?) {
        switch state {
        case .localAsset(let asset):
            asset.getImage(completion: completion)
        case .image(let image):
            completion?(.success(image))
            
        case .downloadable, .uploaded, .none, .uploading, .error:
            assertionFailure("This function for uploading process")
            completion?(.failure(EkoError.unknown))
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: EkoImage, rhs: EkoImage) -> Bool {
        return lhs.id == rhs.id
    }
}
