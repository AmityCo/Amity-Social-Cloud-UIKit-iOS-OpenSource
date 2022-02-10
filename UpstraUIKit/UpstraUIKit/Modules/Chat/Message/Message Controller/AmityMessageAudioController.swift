//
//  AmityMessageAudioController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 2/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

// Manage audio message
final class AmityMessageAudioController {
    
    private let channelId: String
    private weak var repository: AmityMessageRepository?
    
    private var token: AmityNotificationToken?
    private var message: AmityObject<AmityMessage>?
    
    init(channelId: String, repository: AmityMessageRepository?) {
        self.channelId = channelId
        self.repository = repository
    }
    
    func create(completion: @escaping () -> Void) {
        
        guard let audioURL = AmityAudioRecorder.shared.getAudioFileURL() else {
            Log.add("Audio file not found")
            return
        }
        
        guard let repository = repository else {
            return
        }
        
        let messageId = repository.createAudioMessage(withChannelId: channelId, audioFile: audioURL, fileName: AmityAudioRecorder.shared.fileName, parentId: nil, tags: nil, completion: nil)
        
        token = repository.getMessage(messageId)?.observe { [weak self] (collection, error) in
            guard error == nil, let message = collection.object else {
                self?.token = nil
                return
            }
            AmityAudioRecorder.shared.updateFilename(withFilename: message.messageId)
            completion()
        }
        
    }
    
}
