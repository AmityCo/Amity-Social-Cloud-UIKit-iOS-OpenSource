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

enum AmityMediaState {
    
    case uploading(progress: Double)
    case uploadedImage(data: AmityImageData)
    case uploadedVideo(data: AmityVideoData)
    case localAsset(PHAsset)
    case image(UIImage)
    case localURL(url: URL)
    case downloadableImage(imageData: AmityImageData, placeholder: UIImage)
    case downloadableVideo(videoData: AmityVideoData, thumbnailUrl: String?)
    case none
    case error
    
}

enum AmityMediaType {
    case image
    case video
}

public class AmityMedia: Equatable, Hashable {
    
    let id = UUID().uuidString
    var state: AmityMediaState
    var type: AmityMediaType
    
    var image: AmityImageData?
    var video: AmityVideoData?
    
    /// This property carry over when the state change from .localAsset to .uploadedVideo.
    var localAsset: PHAsset?
    
    /// This property carry over when the state change from .localURL to .uploadedVideo.
    var localUrl: URL?
    
    /// Thumbnail image that is generated from local video url.
    ///
    /// This property is valid, when the media.
    /// - 1. `state == .localURL` or `state == .uploaded`
    /// - 2. `type == .video`
    var generatedThumbnailImage: UIImage?
    
    init(state: AmityMediaState, type: AmityMediaType) {
        self.state = state
        self.type = type
    }
    
    private func showImage(from asset: PHAsset, in imageView: UIImageView, size preferredSize: CGSize?) {
    
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
    
    }
    
    func loadImage(to imageView: UIImageView, preferredSize: CGSize? = nil) {
        
        switch state {
        case .image(let image):
            imageView.image = image
            
        case .localAsset(let asset):
            showImage(from: asset, in: imageView, size: preferredSize)
            
        case .downloadableImage(let imageData, let placeholder):
            imageView.loadImage(with: imageData.fileURL, size: .medium, placeholder: placeholder)
            
        case .downloadableVideo(_ , let thumbnailUrl):
            if let thumbnailUrl = thumbnailUrl {
                imageView.loadImage(
                    with: thumbnailUrl,
                    size: .medium,
                    placeholder: AmityIconSet.videoThumbnailPlaceholder
                )
            } else {
                imageView.image = AmityIconSet.videoThumbnailPlaceholder
            }
            
        case .uploadedImage(let imageData):
            imageView.loadImage(with: imageData.fileURL, size: .medium, placeholder: nil)
            
        case .uploadedVideo:
            if let asset = localAsset {
                showImage(from: asset, in: imageView, size: preferredSize)
            } else if let generatedThumbnailImage = generatedThumbnailImage {
                imageView.image = generatedThumbnailImage
            } else {
                assertionFailure("Unexpected state, .uploadedVideo must have a preview image to show.")
            }
            
        case .localURL(let url):
            switch type {
            case .image:
                let image = UIImage(contentsOfFile: url.path)
                imageView.image = image
            case .video:
                imageView.image = generatedThumbnailImage
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
        case .downloadableImage, .downloadableVideo, .uploadedImage, .uploadedVideo, .none, .uploading, .error, .localURL:
            assertionFailure("This function for uploading process")
            completion?(.failure(AmityError.unknown))
        }
    }
    
    // MARK: - Hasable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Equatable
    public static func == (lhs: AmityMedia, rhs: AmityMedia) -> Bool {
        return lhs.id == rhs.id
    }
    
}

