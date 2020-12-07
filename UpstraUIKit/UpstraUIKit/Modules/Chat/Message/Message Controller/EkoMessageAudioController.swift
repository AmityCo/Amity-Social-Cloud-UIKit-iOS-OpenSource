//
//  EkoMessageAudioController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 2/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

// Manage audio message
final class EkoMessageAudioController {
    
    private let channelId: String
    private weak var repository: EkoMessageRepository?
    
    private var token: EkoNotificationToken?
    private var message: EkoObject<EkoMessage>?
    
    init(channelId: String, repository: EkoMessageRepository?) {
        self.channelId = channelId
        self.repository = repository
    }
    
    func create(completion: @escaping () -> Void) {
        guard let audio = EkoAudioRecorder.shared.getDataFile() else {
            print("› [UpstraUIKit]: Audio file not found")
            return
        }

        message = repository?.createAudioMessage(withChannelId: channelId, audio: audio, fileName: EkoAudioRecorder.shared.fileName, parentId: nil, tags: nil)
        token = message?.observe { [weak self] (collection, error) in
            guard error == nil, let message = collection.object else {
                self?.token = nil
                return
            }
            EkoAudioRecorder.shared.updateFilename(withFilename: message.messageId)
            completion()
        }
    }
}
