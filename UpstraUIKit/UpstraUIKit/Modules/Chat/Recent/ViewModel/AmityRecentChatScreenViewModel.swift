//
//  AmityRecentChatScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 8/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

struct AmityChannelModel {
    let channelId: String
    let displayName: String
    let memberCount: Int
    let unreadCount: Int
    let lastActivity: Date
    let channelType: AmityChannelType
    
    init(object: AmityChannel) {
        self.channelId = object.channelId
        self.displayName = object.displayName ?? AmityLocalizedStringSet.anonymous.localizedString
        self.memberCount = object.memberCount
        self.unreadCount = object.unreadCount
        self.lastActivity = object.lastActivity
        self.channelType = object.channelType
    }
}

final class AmityRecentChatScreenViewModel: AmityRecentChatScreenViewModelType {
    weak var delegate: AmityRecentChatScreenViewModelDelegate?
    
    enum Route {
        case messageView(channelId: String)
    }
    
    // MARK: - Repository
    private let channelRepository: AmityChannelRepository
    
    // MARK: - Collection
    private var channelsCollection: AmityCollection<AmityChannel>?
    
    // MARK: - Token
    private var channelsToken: AmityNotificationToken?
    
    init() {
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
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
}

// MARK: - Action
extension AmityRecentChatScreenViewModel {
    
    func viewDidLoad() {
        getChannelList()
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

}

private extension AmityRecentChatScreenViewModel {
    
    func getChannelList() {
        let builder = AmityConversationChannelQueryBuilder(includingTags: [], excludingTags: [], includeDeleted: false)
        channelsCollection = channelRepository
            .getChannels()
            .conversation(with: builder)
            .query()
        channelsToken = channelsCollection?.observe { [weak self] (collection, change, error) in
                self?.prepareDataSource()
        }
    }
    
    func prepareDataSource() {
        guard let collection = channelsCollection else { return }
        var _channels: [AmityChannelModel] = []
        for index in 0..<collection.count() {
            guard let channel = collection.object(at: UInt(index)) else { return }
            let model = AmityChannelModel(object: channel)
            _channels.append(model)
        }
        channels = _channels
        delegate?.screenViewModelLoadingState(for: .loaded)
        delegate?.screenViewModelDidGetChannel()
        delegate?.screenViewModelEmptyView(isEmpty: channels.isEmpty)
    }
}
