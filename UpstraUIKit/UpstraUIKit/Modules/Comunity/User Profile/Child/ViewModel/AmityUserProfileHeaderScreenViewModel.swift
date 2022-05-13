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
    private var existingChannelToken: AmityNotificationToken?
    private var channelToken: AmityNotificationToken?
    private var followToken: AmityNotificationToken?
    private var pendingRequestsToken: AmityNotificationToken?
    private var roleController: AmityChannelRoleController?
    
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
        AmityHUD.show(.loading)
        let builder = AmityConversationChannelBuilder()
        builder.setUserId(userId)
        builder.setDisplayName(user?.displayName ?? "")

        let channel: AmityObject<AmityChannel> = channelRepository.createChannel(with: builder)
        channelToken?.invalidate()
        channelToken = channel.observeOnce { [weak self] channelObject, _ in
            AmityHUD.hide()
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
    
    //Create chat with Community Type
//    public func createChannel() {
//        var allUsers = [user]
//        var currentUser: AmityUserModel?
//        if let user = AmityUIKitManagerInternal.shared.client.currentUser?.object {
//            let userModel = AmityUserModel(user: user)
//            currentUser = userModel
//            allUsers.append(userModel)
//        }
//        let builder = AmityCommunityChannelBuilder()
//        let userIds = allUsers.map{ $0!.userId }
//        let channelId = userIds.sorted().joined(separator: "-")
//        let channelDisplayName = allUsers.map { $0!.displayName }.joined(separator: "-")
//        var userArrayWithDisplayName: [String] = []
//        for name in allUsers{
//            userArrayWithDisplayName.append("\(name!.userId):\(name!.displayName)")
//        }
//        builder.setUserIds(userIds)
//        builder.setId(channelId)
//        let metaData: [String:Any] = [
//            "isDirectChat": allUsers.count == 2,
//            "creatorId": currentUser?.userId ?? "",
//            "sdk_type":"ios",
//            "userIds": userIds,
//            "chatDisplayName": userArrayWithDisplayName
//        ]
//        builder.setMetadata(metaData)
//        builder.setDisplayName(channelDisplayName)
//        builder.setTags(["ch-comm","ios-sdk"])
//        existingChannelToken?.invalidate()
//        existingChannelToken = channelRepository.getChannel(channelId).observe({ [weak self] (channel, error) in
//            guard let weakSelf = self else { return }
//            if error != nil {
//                weakSelf.createNewCommiunityChannel(builder: builder)
//            }
//            guard channel.object != nil else { return }
//            weakSelf.channelRepository.joinChannel(channelId)
//            weakSelf.existingChannelToken?.invalidate()
//            if let channelObject = channel.object {
//                weakSelf.delegate?.screenViewModel(weakSelf, didCreateChannel: channelObject)
//            }
//        })
//
//    }

    func createNewCommiunityChannel(builder: AmityCommunityChannelBuilder) {
        let channelObject = channelRepository.createChannel(with: builder)
        channelToken?.invalidate()
        channelToken = channelObject.observe {[weak self] channelObject, error in
            guard let weakSelf = self else { return }
            if let error = error {
                AmityHUD.show(.error(message: error.localizedDescription))
            }
            if let channelId = channelObject.object?.channelId {
//               let meta = builder.channelMetadata,
//               let creatorId = meta["creatorId"] as? String {
            }
            weakSelf.channelToken?.invalidate()
            if let channel = channelObject.object {
                weakSelf.delegate?.screenViewModel(weakSelf, didCreateChannel: channel)
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
