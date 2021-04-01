//
//  EkoRecentChatScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 8/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

struct EkoChannelModel {
    let channelId: String
    let displayName: String
    let memberCount: Int
    let unreadCount: Int
    let lastActivity: Date
    let channelType: EkoChannelType
    
    init(object: EkoChannel) {
        self.channelId = object.channelId
        self.displayName = object.displayName ?? EkoLocalizedStringSet.anonymous.localizedString
        self.memberCount = object.memberCount
        self.unreadCount = object.unreadCount
        self.lastActivity = object.lastActivity
        self.channelType = object.channelType
    }
}

final class EkoRecentChatScreenViewModel: EkoRecentChatScreenViewModelType {
    weak var delegate: EkoRecentChatScreenViewModelDelegate?
    
    enum Route {
        case messageView(channelId: String)
    }
    
    // MARK: - Repository
    private let channelRepository: EkoChannelRepository
    
    // MARK: - Collection
    private var channelsCollection: EkoCollection<EkoChannel>?
    
    // MARK: - Token
    private var channelsToken: EkoNotificationToken?
    
    init() {
        channelRepository = EkoChannelRepository(client: UpstraUIKitManagerInternal.shared.client)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - DataSource
    private var channels: [EkoChannelModel] = []
    
    func channel(at indexPath: IndexPath) -> EkoChannelModel {
        return channels[indexPath.row]
    }
    
    func numberOfRow(in section: Int) -> Int {
        return channels.count
    }
}

// MARK: - Action
extension EkoRecentChatScreenViewModel {
    
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

private extension EkoRecentChatScreenViewModel {
    
    func getChannelList() {
        let builder = EkoConversationChannelQueryBuilder(includingTags: [], excludingTags: [], includeDeleted: false)
        channelsCollection = channelRepository
            .channelCollection()
            .conversation(with: builder)
            .query()
        channelsToken = channelsCollection?.observe { [weak self] (collection, change, error) in
                self?.prepareDataSource()
        }
    }
    
    func prepareDataSource() {
        guard let collection = channelsCollection else { return }
        var _channels: [EkoChannelModel] = []
        for index in 0..<collection.count() {
            guard let channel = collection.object(at: UInt(index)) else { return }
            let model = EkoChannelModel(object: channel)
            _channels.append(model)
        }
        channels = _channels
        delegate?.screenViewModelLoadingState(for: .loaded)
        delegate?.screenViewModelDidGetChannel()
        delegate?.screenViewModelEmptyView(isEmpty: channels.isEmpty)
    }
}
