//
//  AmityRecentChatScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 8/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public struct AmityChannelModel {
    let channelId: String
    let displayName: String
    let memberCount: Int
    let unreadCount: Int
    let avatarURL: String
    let lastActivity: Date
    let channelType: AmityChannelType
    let avatarFileId: String?
    let participation: AmityChannelParticipation
    let metadata: [String:Any]
    var recentMessage: String
    
    init(object: AmityChannel) {
        self.channelId = object.channelId
        self.avatarURL = object.getAvatarInfo()?.fileURL ?? ""
        self.displayName = object.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString
        self.memberCount = object.memberCount
        self.unreadCount = object.unreadCount
        self.lastActivity = object.lastActivity
        self.participation = object.participation
        self.channelType = object.channelType
        self.avatarFileId = object.getAvatarInfo()?.fileURL
        self.metadata = object.metadata ?? [:]
        self.recentMessage = AmityLocalizedStringSet.RecentMessage.noMessage.localizedString
    }
    
    var isConversationChannel: Bool {
        return channelType == .conversation
    }
    
    func getOtherUserId() -> String {
        if let userIds = metadata["userIds"] as? [String] {
            for id in userIds {
                if id != AmityUIKitManagerInternal.shared.client.currentUserId {
                    return id
                }
            }
        }
        return ""
    }
}

class RecentChatAvatarArray {
    static var shared = RecentChatAvatarArray()
    var avatarArray: [RecentChatAvatar] = []
}

struct RecentChatAvatar {
    let channelId: String
    let avatarURL: String
    let displayName: String
    let isCustom: Bool
    
    init(channelId: String, avatarURL: String, displayName: String, isCustom: Bool){
        self.channelId = channelId
        self.avatarURL = avatarURL
        self.displayName = displayName
        self.isCustom = isCustom
    }
}


final class AmityRecentChatScreenViewModel: AmityRecentChatScreenViewModelType {
    weak var delegate: AmityRecentChatScreenViewModelDelegate?
    
    
    enum Route {
        case messageView(channelId: String)
    }
    
    // MARK: - Repository
    private let channelRepository: AmityChannelRepository
    private var roleController: AmityChannelRoleController?
    private let userRepository: AmityUserRepository
    
    // MARK: - Collection
    private var channelsCollection: AmityCollection<AmityChannel>?
    private var followingCollection: AmityCollection<AmityFollowRelationship>?
    
    // MARK: - Token
    private var channelsToken: AmityNotificationToken?
    private var existingChannelToken: AmityNotificationToken?
    private var communityToken: AmityNotificationToken?
    private var channelType: AmityChannelType = .conversation
    private var channelToken: AmityNotificationToken?

    private let followManager: AmityUserFollowManager
    private var followToken: AmityNotificationToken?
    private var followersList: [AmityFollowRelationship] = []

    init(channelType: AmityChannelType) {
        self.channelType = channelType
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
        followManager = userRepository.followManager

        RecentChatAvatarArray.shared.avatarArray = []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - DataSource
    private var channels: [AmityChannelModel] = []
    
    func channel(at indexPath: IndexPath) -> AmityChannelModel {
        return channels[indexPath.row]
    }
    
    func numberOfRow(in section: Int) -> Int {
        return channels.count
    }
    
    func isAddMemberBarButtonEnabled() -> Bool {
        return channelType == .community
    }
    
    func numberOfItems() -> Int {
        return followersList.count
    }
    
    func item(at indexPath: IndexPath) -> AmityUserModel? {
        guard let model = getUser(at: indexPath) else { return nil }
        return AmityUserModel(user: model)
    }
    
    func createCommunityChannel(users: [AmitySelectMemberModel]) {
        var allUsers = users
        var currentUser: AmitySelectMemberModel?
        if let user = AmityUIKitManagerInternal.shared.client.currentUser?.object {
            let userModel = AmitySelectMemberModel(object: user)
            currentUser = userModel
            allUsers.append(userModel)
        }
        let builder = AmityCommunityChannelBuilder()
        let userIds = allUsers.map{ $0.userId }
        let channelId = userIds.sorted().joined(separator: "-")
        let channelDisplayName = users.count == 1 ? users.first?.displayName ?? "" : allUsers.map { $0.displayName ?? "" }.joined(separator: "-")
        builder.setUserIds(userIds)
        builder.setId(channelId)
        let metaData: [String:Any] = [
            "isDirectChat": allUsers.count == 2,
            "creatorId": currentUser?.userId ?? "",
            "sdk_type":"ios",
            "userIds": userIds
        ]
        builder.setMetadata(metaData)
        builder.setDisplayName(channelDisplayName)
        builder.setTags(["ch-comm","ios-sdk"])
        existingChannelToken?.invalidate()
        existingChannelToken = channelRepository.getChannel(channelId).observe({ [weak self] (channel, error) in
            guard let weakSelf = self else { return }
            if error != nil {
                /// Might be two reason
                /// 1. Network error
                /// 2. Channel haven't created yet
                weakSelf.createNewCommiunityChannel(builder: builder)
            }
            /// which mean we already have that channel and don't need to creaet new channel
            guard channel.object != nil else { return }
            weakSelf.channelRepository.joinChannel(channelId)
            weakSelf.existingChannelToken?.invalidate()
            weakSelf.delegate?.screenViewModelDidCreateCommunity(channelId: channelId)
            weakSelf.existingChannelToken?.invalidate()
        })
    
    }
    
    private func createNewCommiunityChannel(builder: AmityCommunityChannelBuilder) {
        let channelObject = channelRepository.createChannel(with: builder)
        communityToken?.invalidate()
        communityToken = channelObject.observe {[weak self] channelObject, error in
            guard let weakSelf = self else { return }
            if let error = error {
                weakSelf.delegate?.screenViewModelDidFailedCreateCommunity(error: error.localizedDescription)
            }
            if let channelId = channelObject.object?.channelId {
                weakSelf.communityToken?.invalidate()
                weakSelf.delegate?.screenViewModelDidCreateCommunity(channelId: channelId)
            }
        }
    }
    
    func createConversationChannel(users: [AmitySelectMemberModel]) {
        var allUsers = users
        var currentUser: AmitySelectMemberModel?
        if let user = AmityUIKitManagerInternal.shared.client.currentUser?.object {
            let userModel = AmitySelectMemberModel(object: user)
            currentUser = userModel
            allUsers.append(userModel)
        }
        let builder = AmityConversationChannelBuilder()
        let userIds = users.map{ $0.userId }
        let channelDisplayName = users.count == 1 ? users.first?.displayName ?? "" : allUsers.map { $0.displayName ?? "" }.joined(separator: "-")
        let metaData: [String:Any] = [
            "isDirectChat": allUsers.count == 2,
            "creatorId": currentUser?.userId ?? "",
            "sdk_type":"ios"
        ]
        builder.setMetadata(metaData)
        builder.setUserIds(userIds)
        builder.setDisplayName(channelDisplayName)
        builder.setTags(["ch-comm","ios-sdk"])
        
        
        let channelObject = channelRepository.createChannel(with: builder)
        communityToken?.invalidate()
        DispatchQueue.main.async {
            self.communityToken = channelObject.observe { channelObject, error in
                if let channelId = channelObject.object?.channelId {
                    self.communityToken?.invalidate()
                    self.delegate?.screenViewModelDidCreateCommunity(channelId: channelId)
                }
            }
        }
    }
    
    func createChat(with value: AmityUserModel) {
        AmityHUD.show(.loading)
        let builder = AmityConversationChannelBuilder()
        builder.setUserId(value.userId)
        builder.setDisplayName(value.displayName)

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
}

// MARK: - Action
extension AmityRecentChatScreenViewModel {
    
    func viewDidLoad() {
        getChannelList()
        getFollowsList()
    }
    
    func createChannel(users: [AmitySelectMemberModel]) {
        switch channelType {
        case .community:
            createCommunityChannel(users: users)
        case .conversation:
            createConversationChannel(users: users)
        default:
            break
        }
    }

    func loadMore() {
        guard let collection = channelsCollection else { return }
        
        switch collection.loadingStatus {
        case .loaded:
            if collection.hasNext {
                collection.nextPage()
                delegate?.screenViewModelLoadingState(for: .loading)
            }
        default: break
        }
    }
    
    func join(at indexPath: IndexPath) {
        let channelId = channel(at: indexPath).channelId
        channelRepository.joinChannel(channelId)
        delegate?.screenViewModelRoute(for: .messageView(channelId: channelId))
    }
    
    func hasNextFollowing() {
        
        guard let collection = followingCollection else  { return }
        
        if collection.hasNext{
            collection.nextPage()
            prepareDataSource(error: nil)
        }
    }

}

private extension AmityRecentChatScreenViewModel {
    
    func getFollowsList() {
        followManager.clearAmityFollowRelationshipLocalData()
        followingCollection = followManager.getMyFollowingList(with: .accepted)
        
        followToken?.invalidate()
        followToken = followingCollection?.observe { [weak self] collection, _, error in
            //Stop observe when already get data.
            self?.followToken?.invalidate()
            self?.prepareDataSource(error: error)
        }
    }
    
    func getChannelList() {
        switch channelType {
        case .community:
            let query = AmityChannelQuery()
            query.types = [AmityChannelQueryType.community]
            query.filter = .userIsMember
            query.includeDeleted = false
            channelsCollection = channelRepository.getChannels(with: query)
        case .conversation:
            let query = AmityChannelQuery()
            query.types = [AmityChannelQueryType.conversation]
            query.filter = .userIsMember
            query.includeDeleted = false
            channelsCollection = channelRepository.getChannels(with: query)
        default:
            break
        }
        channelsToken = channelsCollection?.observe { [weak self] (collection, change, error) in
            if collection.dataStatus == .fresh{
                self?.prepareDataSource()
            }
        }
    }
    
    private func prepareDataSource() {
        AmityHUD.hide()
        guard let collection = channelsCollection else {
            return
        }
        var _channels: [AmityChannelModel] = []
        for index in 0..<collection.count() {
            guard let channel = collection.object(at: UInt(index)) else { return }
            let model = AmityChannelModel(object: channel)
            _channels.append(model)
        }
        channels = _channels

        for (index, channel) in channels.enumerated() {
            getRecentMessage(channelModel: channel, index: index) { [weak self] (model, index) in
                self?.channels[index] = model
            }
        }

        delegate?.screenViewModelLoadingState(for: .loaded)
        delegate?.screenViewModelDidGetChannel()
        delegate?.screenViewModelEmptyView(isEmpty: channels.isEmpty)
    }
    
    private func getRecentMessage(channelModel: AmityChannelModel, index: Int, completion: @escaping(_ amityChannelModel: AmityChannelModel, _ index: Int) -> Void ){
            
        var currentChannekModel = channelModel
        let recentMessage = channelModel.metadata["latestMessageNonBlock"] as? [[String:Any]] ?? []
        //If no message yet
        if recentMessage.isEmpty {
            completion(currentChannekModel, index)
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let recentJsonData = try JSONSerialization.data(withJSONObject: recentMessage, options: .prettyPrinted)
            var recentArray = try decoder.decode([AmityRecentMessageModel].self, from: recentJsonData)
            recentArray = recentArray.sorted(by: {$0.channelSegment! > $1.channelSegment!})
            for recentMsg in recentArray {
                switch AmityUIKitManagerInternal.shared.amityLanguage {
                    case "th":
                    if recentMsg.userId == AmityUIKitManagerInternal.shared.currentUserId{
                        currentChannekModel.recentMessage = recentMsg.asOwnerMessageTH ?? AmityLocalizedStringSet.RecentMessage.noMessage.localizedString
                    } else {
                        currentChannekModel.recentMessage = recentMsg.asReceiverMessageTH ?? AmityLocalizedStringSet.RecentMessage.noMessage.localizedString
                    }
                    default:
                    if recentMsg.userId == AmityUIKitManagerInternal.shared.currentUserId{
                        currentChannekModel.recentMessage = recentMsg.asOwnerMessageEN ?? AmityLocalizedStringSet.RecentMessage.noMessage.localizedString
                    } else {
                        currentChannekModel.recentMessage = recentMsg.asReceiverMessageEN ?? AmityLocalizedStringSet.RecentMessage.noMessage.localizedString
                    }
                }
                break
            }
            completion(currentChannekModel, index)
        } catch let error {
            print("[AmitySDK - Recent chat] Empty recent message.")
        }
        
    }
    
}

private extension AmityRecentChatScreenViewModel {
    func getUser(at indexPath: IndexPath) -> AmityUser? {
        let recordAtRow = followersList[indexPath.row]
        return recordAtRow.targetUser
    }
    
    private func prepareDataSource(error: Error?) {
        
        guard let currentCollection = followingCollection else { return }
        
        if let _ = error {
            delegate?.screenViewModelDidGetListFail()
            return
        }
        
        switch currentCollection.dataStatus {
        case .fresh:
            var followers: [AmityFollowRelationship] = []
            for i in 0..<currentCollection.count() {
                guard let follow = currentCollection.object(at: i) else { continue }
                followers.append(follow)
            }
                        
            if followersList.isEmpty {
                followersList = followers
            }
            
            delegate?.screenViewModelDidGetListSuccess()
        case .local:
            var followers: [AmityFollowRelationship] = []
            for i in 0..<currentCollection.count() {
                guard let follow = currentCollection.object(at: i) else { continue }
                followers.append(follow)
            }
            
            for user in followers {
                if !( followersList.contains(where: {$0.targetUserId == user.targetUserId}) ) {
                    followersList.append(user)
                }
            }
            
            delegate?.screenViewModelDidGetListSuccess()
        default: break
        }
    }
}
