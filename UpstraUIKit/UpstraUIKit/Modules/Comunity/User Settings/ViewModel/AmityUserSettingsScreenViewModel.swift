//
//  AmityUserSettingsScreenViewModel.swift
//  AmityUIKit
//
//  Created by Hamlet on 28.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import AmitySDK

final class AmityUserSettingsScreenViewModel: AmityUserSettingsScreenViewModelType {
    
    weak var delegate: AmityUserSettingsScreenViewModelDelegate?
    
    // MARK: - Controller
    private let userNotificationController: AmityUserNotificationSettingsControllerProtocol
    
    // MARK: - SubViewModel
    private var menuViewModel: AmityUserSettingsCreateMenuViewModelProtocol?
    
    // MARK: - Properties
    private(set) var user: AmityUser?
    let userId: String
    private let userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
    private var userToken: AmityNotificationToken?
    private let followManager: AmityUserFollowManager
    private var flagger: AmityUserFlagger?
    private var isFlaggedByMe: Bool?
    private var followStatus: AmityFollowStatus?
    private var dispatchGroup = DispatchGroup()
    
    init(userId: String, userNotificationController: AmityUserNotificationSettingsControllerProtocol) {
        self.userId = userId
        self.userNotificationController = userNotificationController
        followManager = userRepository.followManager
    }
}

// MARK: - Action
extension AmityUserSettingsScreenViewModel {
    func unfollowUser() {
        followManager.unfollowUser(withUserId: userId) { [weak self] success, response, error in
            guard let strongSelf = self else { return }
            
            if !success {
                strongSelf.delegate?.screenViewModelDidUnfollowUserFail()
                return
            }
            
            strongSelf.followStatus = AmityFollowStatus.none
            strongSelf.createMenuViewModel()
            strongSelf.delegate?.screenViewModelDidUnfollowUser()
        }
    }
    
    func reportUser() {
        guard let user = user else { return }
        flagger = AmityUserFlagger(client: AmityUIKitManagerInternal.shared.client, userId: user.userId)
        flagger?.flag { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
            } else {
                strongSelf.isFlaggedByMe = !(strongSelf.isFlaggedByMe ?? false)
                strongSelf.createMenuViewModel()
                strongSelf.delegate?.screenViewModelDidFlagUserSuccess()
            }
        }
    }

    func unreportUser() {
        guard let user = user else { return }
        flagger = AmityUserFlagger(client: AmityUIKitManagerInternal.shared.client, userId: user.userId)
        flagger?.unflag { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
            } else {
                self?.isFlaggedByMe = !(self?.isFlaggedByMe ?? false)
                self?.createMenuViewModel()
                strongSelf.delegate?.screenViewModelDidUnflagUserSuccess()
            }
        }
    }
    
    func fetchUserSettings() {
        userToken = userRepository.getUser(userId).observe { [weak self] user, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.userToken?.invalidate()
                strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
                return
            }
            
            if let user = user.object {
                let amityUser = AmityUserModel(user: user)
                strongSelf.user = user
                strongSelf.delegate?.screenViewModel(strongSelf, didGetUserSuccess: amityUser)
                strongSelf.retrieveSettingsMenu()
            }
            
            strongSelf.userToken?.invalidate()
        }
    }
}

private extension AmityUserSettingsScreenViewModel {
    func getReportUserStatus(completion: (() -> Void)?) {
        guard let user = user else { return }
        flagger = AmityUserFlagger(client: AmityUIKitManagerInternal.shared.client, userId: user.userId)
        flagger?.isFlaggedByMe(completion: { [weak self] isFlaggedByMe in
            self?.isFlaggedByMe = isFlaggedByMe
            completion?()
        })
    }
    
    func getFollowInfo(completion: (() -> Void)?) {
        followManager.getUserFollowInfo(withUserId: userId) { [weak self] success, object, error in
            guard let result = object else { return }
            
            self?.followStatus = result.status
            completion?()
        }
    }
    
    func createMenuViewModel() {
        menuViewModel = AmityUserSettingsCreateMenuViewModel()
        menuViewModel?.createSettingsItems(shouldNotificationItemShow: false, isNotificationEnabled: false, isOwner: userId == AmityUIKitManagerInternal.shared.client.currentUserId, isReported: isFlaggedByMe ?? false, isFollowing: followStatus == .accepted, { [weak self] (items) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.screenViewModel(strongSelf, didGetSettingMenu: items)
        })
    }
    
    func retrieveSettingsMenu() {
        if userId == AmityUIKitManagerInternal.shared.client.currentUserId {
            createMenuViewModel()
            return
        }
        
        dispatchGroup.enter()
        getReportUserStatus { [weak self] in
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getFollowInfo { [weak self] in
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.createMenuViewModel()
        }
    }
}
