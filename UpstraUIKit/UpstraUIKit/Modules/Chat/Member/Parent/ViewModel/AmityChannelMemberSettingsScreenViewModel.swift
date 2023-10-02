//
//  AmityChannelMemberSettingsScreenViewModel.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/11/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation

final class AmityChannelMemberSettingsScreenViewModel: AmityChannelMemberSettingsScreenViewModelType {
    
    // MARK: - Delegate
    weak var delegate: AmityChannelMemberSettingsScreenViewModelDelegate?
    
    // MARK: - Properties
    var channel: AmityChannelModel
    var isModerator: Bool = false
    var shouldShowAddMemberButton: Bool = false
    
    // MARK: - initial
    init(channel: AmityChannelModel) {
        self.channel = channel
    }
}

// MARK: - DataSource
extension AmityChannelMemberSettingsScreenViewModel {
    
}

// MARK: - Action
extension AmityChannelMemberSettingsScreenViewModel {
    func getUserRoles() {
        AmityUIKitManagerInternal.shared.client.hasPermission(.editChannel, forChannel: channel.channelId, completion: { [weak self] hasPermission in
            guard let weakSelf = self else { return }
            weakSelf.isModerator = hasPermission
            weakSelf.delegate?.screenViewModelShouldShowAddButtonBarItem(status: hasPermission)
        })   
    }
}
