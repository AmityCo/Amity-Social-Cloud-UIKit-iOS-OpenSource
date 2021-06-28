//
//  AmityPostFetchFeedController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/14/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public enum AmityPostFeedType: Equatable {
    case globalFeed
    case myFeed
    case userFeed(userId: String)
    case communityFeed(communityId: String)
}

protocol AmityPostFetchFeedControllerProtocol {
    func fetch(withFeedType type: AmityPostFeedType, completion: ((Result<[AmityPostModel], AmityError>) -> Void)?)
    func loadMore() -> Bool
}

final class AmityPostFetchFeedDataController: AmityPostFetchFeedControllerProtocol {
    
    private let repository = AmityFeedRepository(client: AmityUIKitManagerInternal.shared.client)
    private var collection: AmityCollection<AmityPost>?
    private var token: AmityNotificationToken?
    private var participation: AmityCommunityParticipation?
    
    func loadMore() -> Bool {
        guard let collection = collection else { return false }
        switch collection.loadingStatus {
        case .loaded:
            if collection.hasNext {
                collection.nextPage()
                return true
            }
            return false
        default:
            return false
        }
    }
    
    func fetch(withFeedType type: AmityPostFeedType, completion: ((Result<[AmityPostModel], AmityError>) -> Void)?) {
        switch type {
        case .globalFeed:
            collection = repository.getGlobalFeed()
        case .myFeed:
            collection = repository.getMyFeedSorted(by: .lastCreated, includeDeleted: false)
        case .userFeed(let userId):
            // If current userId is passing through .userFeed, handle this case as .myFeed type.
            if userId == AmityUIKitManagerInternal.shared.currentUserId {
                collection = repository.getMyFeedSorted(by: .lastCreated, includeDeleted: false)
            } else {
                collection = repository.getUserFeed(userId, sortBy: .lastCreated, includeDeleted: false)
            }
        case .communityFeed(let communityId):
            collection = repository.getCommunityFeed(withCommunityId: communityId, sortBy: .lastCreated, includeDeleted: false)
        }
        
        token?.invalidate()
        token = collection?.observe { [weak self] (collection, change, error) in
            guard let strongSelf = self else { return }
            if let error = AmityError(error: error) {
                completion?(.failure(error))
            } else {
                completion?(.success(strongSelf.prepareDataSource(feedType: type)))
            }
        }
    }
    
    private func prepareDataSource(feedType: AmityPostFeedType) -> [AmityPostModel] {
        guard let collection = collection else { return [] }
        
        var models = [AmityPostModel]()
        for i in 0..<collection.count() {
            guard let post = collection.object(at: i) else { continue }
            let model = AmityPostModel(post: post)
            if let communityId = model.targetCommunity?.communityId {
                participation = AmityCommunityParticipation(client: AmityUIKitManagerInternal.shared.client, andCommunityId: communityId)
                model.isModerator = participation?.getMember(withId: post.postedUserId)?.communityRoles.contains(.moderator) ?? false
                if case .communityFeed(let feedCommunityId) = feedType {
                    model.appearance.shouldShowCommunityName = communityId != feedCommunityId
                }
            }
            models.append(model)
        }
        return models
    }
}
