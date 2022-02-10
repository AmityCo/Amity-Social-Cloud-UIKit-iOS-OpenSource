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
    
    private let channelId: String
    private let media: AmityMedia
    private weak var repository: AmityMessageRepository?
    
    private var token: AmityNotificationToken?
    
    init(channelId: String, media: AmityMedia, repository: AmityMessageRepository) {
        self.channelId = channelId
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
        
        let channelId = self.channelId
        
        // Perform actual task on main queue.
        DispatchQueue.main.async { [weak self] in
            self?.media.getLocalURLForUploading(completion: { (url) in
                guard let imageUrl = url else {
                    self?.finish()
                    return
                }
                let messageId = repository.createImageMessage(withChannelId: channelId, imageFile: imageUrl, caption: nil, fullImage: true, tags: nil, parentId: nil, completion: nil)
                self?.token = repository.getMessage(messageId)?.observe { (liveObject, error) in
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
                
            })

        }
        
    }
    
}

