//
//  UploadImageMessageOperation.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 17/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

class UploadImageMessageOperation: AsyncOperation {
    
    private let subChannelId: String
    private let media: AmityMedia
    private weak var repository: AmityMessageRepository?
    
    private var token: AmityNotificationToken?
    
    init(subChannelId: String, media: AmityMedia, repository: AmityMessageRepository) {
        self.subChannelId = subChannelId
        self.media = media
        self.repository = repository
    }
    
    deinit {
        token = nil
    }

    override func main() {
        
        guard let repository = repository else {
            finish()
            return
        }
        
        let channelId = self.subChannelId
        
        // Perform actual task on main queue.
        DispatchQueue.main.async { [weak self] in
            self?.media.getImageForUploading { result in
                switch result {
                case .success(let image):
                    
                    // save image to temp directory and send local url path for uploading
                    let imageName = "\(UUID().uuidString).jpg"
                    
                    let imageUrl = FileManager.default.temporaryDirectory.appendingPathComponent(imageName)
                    let data = image.scalePreservingAspectRatio().jpegData(compressionQuality: 0.8)
                    try? data?.write(to: imageUrl)
                    
                    let createOptions = AmityImageMessageCreateOptions(subChannelId: channelId, imageURL: imageUrl, fullImage: true)
                    
                    repository.createImageMessage(options: createOptions) { message, error in
                        guard error == nil, let message = message else {
                            return
                        }
                        self?.token = repository.getMessage(message.messageId).observe { (liveObject, error) in
                            guard error == nil, let message = liveObject.object else {
                                self?.token = nil
                                self?.finish()
                                return
                            }
                            switch message.syncState {
                            case .syncing, .default:
                                // We don't cache local file URL as sdk handles itself
                                break
                            case .synced, .error:
                                self?.token = nil
                                self?.finish()
                            @unknown default:
                                fatalError()
                            }
                        }
                    }
                    
                case .failure:
                    self?.finish()
                }
            }
            
        }
        
    }
    
}

