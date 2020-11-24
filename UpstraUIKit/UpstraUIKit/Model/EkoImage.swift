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
    
    func loadImage(to imageView: UIImageView) {
        let preferredSize = imageView.frame.size
        switch state {
        case .image(let image):
            imageView.image = image
            
        case .localAsset(let asset):
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.version = .current
            option.isNetworkAccessAllowed = true
            
            manager.requestImage(for: asset, targetSize: preferredSize, contentMode: .aspectFill, options: option, resultHandler: { (result, info) in
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
    
    func image(preferredSize: CGSize = .zero) -> UIImage {
        switch state {
        case .localAsset(let asset):
            
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.version = .current
            option.isNetworkAccessAllowed = true
            option.isSynchronous = true
            option.deliveryMode = .highQualityFormat
            option.resizeMode = .exact
            
            var image = UIImage()
            manager.requestImage(for: asset, targetSize: preferredSize, contentMode: .aspectFit, options: option, resultHandler: { (result, info) in
                if let result = result {
                    image = result
                }
            })
            #warning("This function is working synchronously and need to be improved.")
            return image
            
        case .downloadable(_, let placeholder):
            return placeholder
            
        case .image(let image):
            return image
            
        case .uploaded, .none:
            return UIImage()
            
        case .uploading, .error:
            fatalError()
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: EkoImage, rhs: EkoImage) -> Bool {
        return lhs.id == rhs.id
    }
}
