//
//  EkoPostFetchFeedController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/14/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

public enum EkoPostFeedType: Equatable {
    case globalFeed
    case myFeed
    case userFeed(userId: String)
    case communityFeed(communityId: String)
}

protocol EkoPostFetchFeedControllerProtocol {
    func fetch(withFeedType type: EkoPostFeedType, completion: ((Result<[EkoPostModel], EkoError>) -> Void)?)
    func loadMore() -> Bool
}

final class EkoPostFetchFeedDataController: EkoPostFetchFeedControllerProtocol {
    
    private let repository = EkoFeedRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var collection: EkoCollection<EkoPost>?
    private var token: EkoNotificationToken?
    private var participation: EkoCommunityParticipation?
    
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
    
    func fetch(withFeedType type: EkoPostFeedType, completion: ((Result<[EkoPostModel], EkoError>) -> Void)?) {
        switch type {
        case .globalFeed:
            collection = repository.getGlobalFeed()
        case .myFeed:
            collection = repository.getMyFeedSorted(by: .lastCreated, includeDeleted: false)
        case .userFeed(let userId):
            // If current userId is passing through .userFeed, handle this case as .myFeed type.
            if userId == UpstraUIKitManagerInternal.shared.currentUserId {
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
            if let error = EkoError(error: error) {
                completion?(.failure(error))
            } else {
                completion?(.success(strongSelf.prepareDataSource()))
            }
        }
    }
    
    private func prepareDataSource() -> [EkoPostModel] {
        guard let collection = collection else { return [] }
        
        var models = [EkoPostModel]()
        for i in 0..<collection.count() {
            guard let post = collection.object(at: i) else { continue }
            let model = EkoPostModel(post: post)
            if let communityId = model.communityId {
                participation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
                model.isModerator = participation?.getMembership(post.postedUserId)?.communityRoles.contains(.moderator) ?? false
            }
            models.append(model)
        }
        return models
    }
}
