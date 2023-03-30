//
//  AmityPostReviewSettingsScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityPostReviewSettingsScreenViewModel: AmityPostReviewSettingsScreenViewModelType {
    weak var delegate: AmityPostReviewSettingsScreenViewModelDelegate?
    
    // MARK: - Repository
    private let communityRepository: AmityCommunityRepository
    
    // MARK: - Tasks
    private let communityViewModel: AmityPostReviewSettingsCommunityViewModel
    
    let communityId: String
    
    init(communityId: String) {
        self.communityId = communityId
        communityRepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
        communityViewModel = AmityPostReviewSettingsCommunityViewModel(communityId: communityId, communityRepository: communityRepository)
    }
}

// MARK: - DataSource
extension AmityPostReviewSettingsScreenViewModel {
    
}

// MARK: - Action
extension AmityPostReviewSettingsScreenViewModel {
    
    func getCommunity() {
        communityViewModel.getCommunity { [weak self] (result) in
            switch result {
            case .success(let community):
                self?.prepareMenu(community: community)
            case .failure(let error):
                break
            }
        }
    }
    
    private func prepareMenu(community: AmityCommunityModel)  {
        var settingsItems = [AmitySettingsItem]()
        let approveMemberPostContent = AmitySettingsItem.ToggleContent(identifier: AmityPostReviewSettingsItem.approveMemberPost.identifier,
                                                                     iconContent: AmitySettingContentIcon(icon: AmityPostReviewSettingsItem.approveMemberPost.icon),
                                                                     title: AmityPostReviewSettingsItem.approveMemberPost.title,
                                                                     description: AmityPostReviewSettingsItem.approveMemberPost.description,
                                                                     isToggled: community.isPostReviewEnabled)
        settingsItems.append(.toggleContent(content: approveMemberPostContent))
        settingsItems.append(.separator)
        delegate?.screenViewModel(self, didFinishWithAction: .showMenu(settingItem: settingsItems))
    }
    
    func turnOnApproveMemberPost(content: AmitySettingsItem.ToggleContent) {
        performAction(content: .turnOnApproveMemberPost(content: content), isPostReview: true)
    }
    
    func turnOffApproveMemberPost(content: AmitySettingsItem.ToggleContent) {
        performAction(content: .turnOffApproveMemberPost(content: content), isPostReview: false)
    }
    
    private func performAction(content: AmityPostReviewSettingsAction, isPostReview: Bool) {
        if Reachability.shared.isConnectedToNetwork {
            let updateOptions = AmityCommunityUpdateOptions()
            
            updateOptions.setPostSettings(isPostReview ? .adminReviewPostRequired : .anyoneCanPost)
            communityRepository.updateCommunity(withId: communityId, options: updateOptions) { [weak self] (community, error) in
                guard let strongSelf = self else { return }
                if let error = error {
                    strongSelf.delegate?.screenViewModel(strongSelf, didFailWithAction: content)
                } else {
                    
                }
            }
        } else {
            delegate?.screenViewModel(self, didFailWithAction: content)
        }
    }
}
