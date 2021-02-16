//
//  UploadImageMessageOperation.swift
//  UpstraUIKit
//
//  Created by Nutchaphon Rewik on 17/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

class UploadImageMessageOperation: AsyncOperation {
    
    private let channelId: String
    private let image: EkoImage
    private weak var repository: EkoMessageRepository?
    
    private var token: EkoNotificationToken?
    
    init(channelId: String, image: EkoImage, repository: EkoMessageRepository) {
        self.channelId = channelId
        self.image = image
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
        
        let channelId = self.channelId
        
        // Perform actual task on main queue.
        DispatchQueue.main.async { [weak self] in
            // Get image for uploading
            self?.image.getImageForUploading { result in
                switch result {
                case .success(let image):
                    self?.token = repository
                        .createImageMessage(withChannelId: channelId, image: image, caption: nil, fullImage: true)
                        .observe { (collection, error) in
                            guard error == nil, let message = collection.object else {
                                self?.token = nil
                                self?.finish()
                                return
                            }
                            switch message.syncState {
                            case .syncing:
                                EkoMediaService.shared.saveCacheImage(image, for: message.messageId)
                            case .default:
                                break
                            case .synced, .error:
                                self?.token = nil
                                self?.finish()
                            @unknown default:
                                fatalError()
                            }
                    }
                case .failure:
                    self?.finish()
                }
            }
        }
        
    }
    
}

