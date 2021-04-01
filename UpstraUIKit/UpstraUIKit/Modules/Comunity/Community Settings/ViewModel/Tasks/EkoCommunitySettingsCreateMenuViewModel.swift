//
//  EkoCommunitySettingsCreateMenuViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

protocol EkoCommunitySettingsCreateMenuViewModelProtocol {
    func createSettingsItems(shouldNotificationItemShow: Bool, isNotificationEnabled: Bool, _ completion: (([EkoSettingsItem]) -> Void)?)
}

final class EkoCommunitySettingsCreateMenuViewModel: EkoCommunitySettingsCreateMenuViewModelProtocol {
    
   
    // MARK: - Properties
    private let community: EkoCommunityModel
    
    private let dispatchCounter = DispatchGroup()
    private var shouldShowEditProfileItem: Bool = false
    private var shouldShowCloseItem: Bool = false
    
    init(community: EkoCommunityModel) {
        self.community = community
    }
    
    func createSettingsItems(shouldNotificationItemShow: Bool, isNotificationEnabled: Bool, _ completion: (([EkoSettingsItem]) -> Void)?) {
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
    
    private func prepareDataSource(shouldNotificationItemShow: Bool, isNotificationEnabled: Bool, _ completion: (([EkoSettingsItem]) -> Void)?) {
        var settingsItems = [EkoSettingsItem]()
        
        // MARK: Create basic item
        let basicInfoHeader = EkoSettingsItem.HeaderContent(title: EkoCommunitySettingsItem.basicInfo.title)
        settingsItems.append(.header(content: basicInfoHeader))
        
        // MARK: Create edit profile item
        if shouldShowEditProfileItem || self.community.isCreator {
            let itemEditProfileContent = EkoSettingsItem.NavigationContent(identifier: EkoCommunitySettingsItem.editProfile.identifier,
                                                                           icon: EkoCommunitySettingsItem.editProfile.icon,
                                                                           title: EkoCommunitySettingsItem.editProfile.title,
                                                                           description: EkoCommunitySettingsItem.editProfile.description)
            settingsItems.append(.navigationContent(content: itemEditProfileContent))
        }
        
        // MARK: Create member item
        let itemMemberContent = EkoSettingsItem.NavigationContent(identifier: EkoCommunitySettingsItem.members.identifier,
                                                                  icon: EkoCommunitySettingsItem.members.icon,
                                                                  title: EkoCommunitySettingsItem.members.title,
                                                                  description: EkoCommunitySettingsItem.members.description)
        settingsItems.append(.navigationContent(content: itemMemberContent))
        
        // MARK: Create notification item
        if shouldNotificationItemShow {
            let itemNotificationDesc = isNotificationEnabled ? EkoLocalizedStringSet.on : EkoLocalizedStringSet.off
            let itemNotificationContent = EkoSettingsItem.NavigationContent(identifier: EkoCommunitySettingsItem.notification.identifier,
                                                                            icon: EkoCommunitySettingsItem.notification.icon,
                                                                            title: EkoCommunitySettingsItem.notification.title,
                                                                            description: itemNotificationDesc.localizedString)
            settingsItems.append(.navigationContent(content: itemNotificationContent))
            // add separator
            settingsItems.append(.separator)
        }
        
        // MARK: Create leave community item
        // everyone can leave community
        let leaveContent = EkoSettingsItem.TextContent(identifier: EkoCommunitySettingsItem.leaveCommunity.identifier,
                                                       icon: nil,
                                                       title: EkoCommunitySettingsItem.leaveCommunity.title,
                                                       description: nil,
                                                       titleTextColor: EkoColorSet.alert)
        settingsItems.append(.textContent(content: leaveContent))
        settingsItems.append(.separator)
        
        // MARK: Create close community item
        if shouldShowCloseItem || self.community.isCreator {
            
            let closeContent = EkoSettingsItem.TextContent(identifier: EkoCommunitySettingsItem.closeCommunity.identifier,
                                                           icon: nil,
                                                           title: EkoCommunitySettingsItem.closeCommunity.title,
                                                           description: EkoCommunitySettingsItem.closeCommunity.description,
                                                           titleTextColor: EkoColorSet.alert)
            settingsItems.append(.textContent(content: closeContent))
            settingsItems.append(.separator)
        }
        
        completion?(settingsItems)
    }

    // Retrieve edit community permission
    private func retrieveEditCommunityPermission(_ completion: (() -> Void)?) {
        UpstraUIKitManagerInternal.shared.client.hasPermission(.editCommunity, forCommunity: community.communityId) { [weak self] (status) in
            self?.shouldShowEditProfileItem = status
            completion?()
        }
    }

    // Retrieve delete community permission
    private func retrieveDeleteCommunityPermission(_ completion: (() -> Void)?) {
        UpstraUIKitManagerInternal.shared.client.hasPermission(.deleteCommunity, forCommunity: community.communityId) { [weak self] (status) in
            self?.shouldShowCloseItem = status
            completion?()
        }
    }
    
}
