//
//  AmityCommunitySettingsCreateMenuViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol AmityCommunitySettingsCreateMenuViewModelProtocol {
    func createSettingsItems(shouldNotificationItemShow: Bool, isNotificationEnabled: Bool, _ completion: (([AmitySettingsItem]) -> Void)?)
}

final class AmityCommunitySettingsCreateMenuViewModel: AmityCommunitySettingsCreateMenuViewModelProtocol {
    
   
    // MARK: - Properties
    private let community: AmityCommunityModel
    
    // MARK: - Controller
    private let userRolesController: AmityCommunityUserRolesControllerProtocol
    
    private let dispatchCounter = DispatchGroup()
    private var shouldShowEditProfileItem: Bool = false
    private var shouldShowCloseItem: Bool = false
    
    init(community: AmityCommunityModel, userRolesController: AmityCommunityUserRolesControllerProtocol) {
        self.community = community
        self.userRolesController = userRolesController
    }
    
    func createSettingsItems(shouldNotificationItemShow: Bool, isNotificationEnabled: Bool, _ completion: (([AmitySettingsItem]) -> Void)?) {
        // Lock for the first task.
        dispatchCounter.enter()

        // Lock for the second task.
        dispatchCounter.enter()
        
        retrieveEditCommunityPermission { [weak self] in
            self?.dispatchCounter.leave()
        }
        
        retrieveDeleteCommunityPermission { [weak self] in
            self?.dispatchCounter.leave()
        }
        
        dispatchCounter.notify(queue: .main) { [weak self] in
            self?.prepareDataSource(shouldNotificationItemShow: shouldNotificationItemShow, isNotificationEnabled: isNotificationEnabled, completion)
        }
    }
    
    private func prepareDataSource(shouldNotificationItemShow: Bool, isNotificationEnabled: Bool, _ completion: (([AmitySettingsItem]) -> Void)?) {
        var settingsItems = [AmitySettingsItem]()
        
        // get user roles
        let isModerator = userRolesController.getUserRoles(withUserId: AmityUIKitManagerInternal.shared.currentUserId, role: .moderator) || userRolesController.getUserRoles(withUserId: AmityUIKitManagerInternal.shared.currentUserId, role: .communityModerator)
        
        // MARK: Create basic item
        let basicInfoHeader = AmitySettingsItem.HeaderContent(title: AmityCommunitySettingsItem.basicInfo.title)
        settingsItems.append(.header(content: basicInfoHeader))
        
        // MARK: Create edit profile item
        if shouldShowEditProfileItem || isModerator {
            let itemEditProfileContent = AmitySettingsItem.NavigationContent(identifier: AmityCommunitySettingsItem.editProfile.identifier,
                                                                           icon: AmityCommunitySettingsItem.editProfile.icon,
                                                                           title: AmityCommunitySettingsItem.editProfile.title,
                                                                           description: AmityCommunitySettingsItem.editProfile.description)
            settingsItems.append(.navigationContent(content: itemEditProfileContent))
        }
        
        // MARK: Create member item
        let itemMemberContent = AmitySettingsItem.NavigationContent(identifier: AmityCommunitySettingsItem.members.identifier,
                                                                  icon: AmityCommunitySettingsItem.members.icon,
                                                                  title: AmityCommunitySettingsItem.members.title,
                                                                  description: AmityCommunitySettingsItem.members.description)
        settingsItems.append(.navigationContent(content: itemMemberContent))
        
        // MARK: Create notification item
        if shouldNotificationItemShow {
            let itemNotificationDesc = isNotificationEnabled ? AmityLocalizedStringSet.General.on : AmityLocalizedStringSet.General.off
            let itemNotificationContent = AmitySettingsItem.NavigationContent(identifier: AmityCommunitySettingsItem.notification.identifier,
                                                                            icon: AmityCommunitySettingsItem.notification.icon,
                                                                            title: AmityCommunitySettingsItem.notification.title,
                                                                            description: itemNotificationDesc.localizedString)
            settingsItems.append(.navigationContent(content: itemNotificationContent))
            // add separator
            settingsItems.append(.separator)
        }
        
        // MARK: Create Community Permission
        if shouldShowEditProfileItem || isModerator {
            let communityPermissionHeader = AmitySettingsItem.HeaderContent(title: AmityCommunitySettingsItem.communityPermissionHeader.title)
            settingsItems.append(.header(content: communityPermissionHeader))
            
            // MARK: Create post review item
            let itemPostReviewContent = AmitySettingsItem.NavigationContent(identifier: AmityCommunitySettingsItem.postReview.identifier,
                                                                      icon: AmityCommunitySettingsItem.postReview.icon,
                                                                      title: AmityCommunitySettingsItem.postReview.title,
                                                                      description: AmityCommunitySettingsItem.postReview.description)
            settingsItems.append(.navigationContent(content: itemPostReviewContent))
        }
        
        // MARK: Create leave community item
        // everyone can leave community
        let leaveContent = AmitySettingsItem.TextContent(identifier: AmityCommunitySettingsItem.leaveCommunity.identifier,
                                                       icon: nil,
                                                       title: AmityCommunitySettingsItem.leaveCommunity.title,
                                                       description: nil,
                                                       titleTextColor: AmityColorSet.alert)
        settingsItems.append(.textContent(content: leaveContent))
        settingsItems.append(.separator)
        
        // MARK: Create close community item
        if shouldShowCloseItem || isModerator {
            
            let closeContent = AmitySettingsItem.TextContent(identifier: AmityCommunitySettingsItem.closeCommunity.identifier,
                                                           icon: nil,
                                                           title: AmityCommunitySettingsItem.closeCommunity.title,
                                                           description: AmityCommunitySettingsItem.closeCommunity.description,
                                                           titleTextColor: AmityColorSet.alert)
            settingsItems.append(.textContent(content: closeContent))
            settingsItems.append(.separator)
        }
        
        completion?(settingsItems)
    }

    // Retrieve edit community permission
    private func retrieveEditCommunityPermission(_ completion: (() -> Void)?) {
        AmityUIKitManagerInternal.shared.client.hasPermission(.editCommunity, forCommunity: community.communityId) { [weak self] (status) in
            self?.shouldShowEditProfileItem = status
            completion?()
        }
    }

    // Retrieve delete community permission
    private func retrieveDeleteCommunityPermission(_ completion: (() -> Void)?) {
        AmityUIKitManagerInternal.shared.client.hasPermission(.deleteCommunity, forCommunity: community.communityId) { [weak self] (status) in
            self?.shouldShowCloseItem = status
            completion?()
        }
    }
    
}
