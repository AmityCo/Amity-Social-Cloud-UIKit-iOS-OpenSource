//
//  AmityChatEventHandler.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 8/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import UIKit
import AmitySDK

public class AmityChatHandler {
    public static var shared = AmityChatHandler()
    var channelsToken: AmityNotificationToken?
    var channelsCollection: AmityCollection<AmityChannel>?
    var channelRepository: AmityChannelRepository
    
    public init() {
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    // MARK: - Public function
    open func getNotiCountFromAPI(completion: @escaping(_ completion:Result<Int,Error>) -> () ) {
        customAPIRequest.getChatBadgeCount(userId: AmityUIKitManagerInternal.shared.currentUserId) { result in
            switch result {
            case .success(let badgeCount):
                completion(.success(badgeCount))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    open func getUnreadCountFromASC(completion: @escaping(_ completion:Result<Int,Error>) -> () ) {
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
        let query = AmityChannelQuery()
        query.types = [AmityChannelQueryType.conversation]
        query.filter = .userIsMember
        query.includeDeleted = false
        channelsCollection = channelRepository.getChannels(with: query)
        channelsToken?.invalidate()
        channelsToken = channelsCollection?.observe { [weak self] (collectionFromObserve, change, error) in
            if error != nil {
                completion(.failure(error!))
            }
            guard let collection = self?.channelsCollection else { return }
            var unreadCount: Int = 0
            for index in 0..<collection.count() {
                guard let channel = collection.object(at: UInt(index)) else { return }
                let model = AmityChannelModel(object: channel)
                unreadCount += model.unreadCount
            }
            
            completion(.success(unreadCount))
        }
    }
}
