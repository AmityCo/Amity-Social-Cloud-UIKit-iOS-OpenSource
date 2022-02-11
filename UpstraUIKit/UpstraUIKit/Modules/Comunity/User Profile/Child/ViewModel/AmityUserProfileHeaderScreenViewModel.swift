//
//  AmityUserProfileHeaderScreenViewModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

final class AmityUserProfileHeaderScreenViewModel: AmityUserProfileHeaderScreenViewModelType {
    // MARK: - Properties
    
    weak var delegate: AmityUserProfileHeaderScreenViewModelDelegate?
    
    let userId: String
    private(set) var user: AmityUserModel?
    private(set) var followInfo: AmityFollowInfo?
    private(set) var followStatus: AmityFollowStatus?
    
    private let userRepository: AmityUserRepository
    private let channelRepository: AmityChannelRepository
    private let followManager: AmityUserFollowManager
    private var userToken: AmityNotificationToken?
    private var channelToken: AmityNotificationToken?
    private var followToken: AmityNotificationToken?
    private var pendingRequestsToken: AmityNotificationToken?
    
    // MARK: - Initializer
    
    init(userId: String) {
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
        followManager = userRepository.followManager
        self.userId = userId
    }
}

// MARK: Action
extension AmityUserProfileHeaderScreenViewModel {
    func fetchUserData() {
        userToken?.invalidate()
        userToken = userRepository.getUser(userId).observe { [weak self] object, error in
            guard let strongSelf = self else { return }
            // Due to `observeOnce` doesn't guarantee if the data is fresh or local.
            // So, this is a workaround to execute code specifically for fresh data status.
            switch object.dataStatus {
            case .fresh:
                if let user = object.object {
                    strongSelf.prepareUserData(user: user)
                }
                strongSelf.userToken?.invalidate()
            case .error:
                strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
                strongSelf.userToken?.invalidate()
            case .local:
                if let user = object.object {
                    strongSelf.prepareUserData(user: user)
                }
            case .notExist:
                strongSelf.userToken?.invalidate()
            @unknown default:
                break
            }
        }
    }
    
    func fetchFollowInfo() {
        if userId == AmityUIKitManagerInternal.shared.client.currentUserId {
            followManager.getMyFollowInfo(completion: { [weak self] success, object, error in
                guard let strongSelf = self else { return }
                
                if success, let result = object {
                    strongSelf.handleFollowInfo(followInfo: AmityFollowInfo(followInfo: result))
                } else {
                    strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
                }
            })
            
            return
        }
        
        followManager.getUserFollowInfo(withUserId: userId) { [weak self] success, object, error in
            guard let strongSelf = self else { return }
            
            if success, let result = object {
                strongSelf.handleFollowInfo(followInfo: AmityFollowInfo(followInfo: result))
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
            }
        }
    }
    
    func createChannel() {
        let builder = AmityConversationChannelBuilder()
        builder.setUserId(userId)
        builder.setDisplayName(user?.displayName ?? "")
        
        let channel: AmityObject<AmityChannel> = channelRepository.createChannel(with: builder)
        channelToken?.invalidate()
        channelToken = channel.observeOnce { [weak self] channelObject, _ in
            guard let strongSelf = self else { return }
            switch channelObject.dataStatus {
            case .fresh:
                if let channel = channelObject.object {
                    strongSelf.delegate?.screenViewModel(strongSelf, didCreateChannel: channel)
                }
                strongSelf.channelToken?.invalidate()
            case .local:
                if let channel = channelObject.object {
                    strongSelf.delegate?.screenViewModel(strongSelf, didCreateChannel: channel)
                }
            case .error, .notExist:
                strongSelf.channelToken?.invalidate()
            @unknown default:
                break
            }
        }
    }
    
    func follow() {
        followManager.followUser(withUserId: userId) { [weak self] success, result, error in
            guard let strongSelf = self else { return }
            
            if success, let result = result {
                strongSelf.followStatus = result.status
                strongSelf.delegate?.screenViewModel(strongSelf, didFollowSuccess: result.status)
            } else {
                strongSelf.delegate?.screenViewModelDidFollowFail()
            }
        }
    }
    
    func unfollow() {
        followManager.unfollowUser(withUserId: userId) { [weak self] success, result, error in
            guard let strongSelf = self else { return }
            
            if success, let result = result {
                strongSelf.followStatus = result.status
                strongSelf.delegate?.screenViewModel(strongSelf, didUnfollowSuccess: result.status)
            } else {
                strongSelf.delegate?.screenViewModelDidUnfollowFail()
            }
        }
    }
}

private extension AmityUserProfileHeaderScreenViewModel {
    func handleFollowInfo(followInfo: AmityFollowInfo) {
        self.followInfo = followInfo
        followStatus = followInfo.status
        delegate?.screenViewModel(self, didGetFollowInfo: followInfo)
    }
    
    func prepareUserData(user: AmityUser) {
        let userModel = AmityUserModel(user: user)
        self.user = userModel
        delegate?.screenViewModel(self, didGetUser: userModel)
    }
}
