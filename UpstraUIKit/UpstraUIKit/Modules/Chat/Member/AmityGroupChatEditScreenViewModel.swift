//
//  GroupChatScreenViewModel.swift
//  AmityUIKit
//
//  Created by min khant on 13/05/2021.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityGroupChatEditorScreenViewModelAction {
    func update(displayName: String)
    func update(avatar: UIImage, completion: @escaping (Bool) -> ())
}

protocol AmityGroupChatEditorViewModelDataSource {
    var channel: AmityChannel? { get }
    func getChannelEditUserPermission(_ completion: ((Bool) -> Void)?)
}

protocol AmityGroupChatEditorScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdate(_ viewModel: AmityGroupChatEditorScreenViewModelType)
    func screenViewModelDidUpdateFailed(_ viewModel: AmityGroupChatEditorScreenViewModelType, withError error: String)
    func screenViewModelDidUpdateSuccess(_ viewModel: AmityGroupChatEditorScreenViewModelType)
    
}

protocol AmityGroupChatEditorScreenViewModelType: AmityGroupChatEditorScreenViewModelAction, AmityGroupChatEditorViewModelDataSource {
    var action: AmityGroupChatEditorScreenViewModelAction { get }
    var dataSource: AmityGroupChatEditorViewModelDataSource { get }
    var delegate: AmityGroupChatEditorScreenViewModelDelegate? { get set }
}

extension AmityGroupChatEditorScreenViewModelType {
    var action: AmityGroupChatEditorScreenViewModelAction { return self }
    var dataSource: AmityGroupChatEditorViewModelDataSource { return self }
}

class AmityGroupChatEditScreenViewModel: AmityGroupChatEditorScreenViewModelType {
    
    private var channelNotificationToken: AmityNotificationToken?
    private let channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
    private var channelUpdateBuilder: AmityChannelUpdateBuilder!
    private let fileRepository = AmityFileRepository(client: AmityUIKitManagerInternal.shared.client)

    var channel: AmityChannel?
    weak var delegate: AmityGroupChatEditorScreenViewModelDelegate?
    var user: AmityUserModel?
    var channelId = String()
    
    init(channelId: String) {
        self.channelId = channelId
        channelUpdateBuilder = AmityChannelUpdateBuilder(channelId: channelId)
        channelNotificationToken = channelRepository.getChannel(channelId)
            .observe({ [weak self] channel, error in
                guard let weakself = self,
                    let channel = channel.object else{ return }
                weakself.channel = channel
                weakself.delegate?.screenViewModelDidUpdate(weakself)
            })
    }
    
    func update(displayName: String) {
        // Update
        channelUpdateBuilder.setDisplayName(displayName)
                
        AmityAsyncAwaitTransformer.toCompletionHandler(asyncFunction: channelRepository.updateChannel, parameters: channelUpdateBuilder) { [weak self] channel, error in
            guard let weakSelf = self else { return }
            
            if let error = error {
                weakSelf.delegate?.screenViewModelDidUpdateFailed(weakSelf, withError: error.localizedDescription)
            } else {
                weakSelf.delegate?.screenViewModelDidUpdateSuccess(weakSelf)
            }
        }
    }
    
    func update(avatar: UIImage, completion: @escaping (Bool) -> ()) {
        // Update user avatar
        fileRepository.uploadImage(avatar, progress: nil) { [weak self] (imageData, error) in
            guard let weakSelf = self else { return }
            weakSelf.channelUpdateBuilder.setAvatar(imageData)
            
            AmityAsyncAwaitTransformer.toCompletionHandler(asyncFunction: weakSelf.channelRepository.updateChannel, parameters: weakSelf.channelUpdateBuilder) { [weak self] channel, error in
                guard let weakSelf = self else { return }
                completion(error == nil)
            }
        }
    }
    
    func getChannelEditUserPermission(_ completion: ((Bool) -> Void)?) {
        AmityUIKitManagerInternal.shared.client.hasPermission(.editChannel, forChannel: channelId, completion: { hasPermission in
            completion?(hasPermission)
        })
    }
}
