//
//  AmityCommunityRepositoryManager.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 20/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityRepositoryManagerProtocol {
    func retrieveCommunity(_ completion: ((Result<AmityCommunityModel, AmityError>) -> Void)?)
    func join(_ completion: ((AmityError?) -> Void)?)
}

final class AmityCommunityRepositoryManager: AmityCommunityRepositoryManagerProtocol {
    
    private let communityRepository: AmityCommunityRepository
    private let communityId: String
    private var token: AmityNotificationToken?
    private var communityObject: AmityObject<AmityCommunity>?
    private let feedRepository: AmityFeedRepository
    private var feedToken: AmityNotificationToken?
    
    init(communityId: String) {
        self.communityId = communityId
        communityRepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
        feedRepository = AmityFeedRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    func retrieveCommunity(_ completion: ((Result<AmityCommunityModel, AmityError>) -> Void)?) {
        communityObject = communityRepository.getCommunity(withId: communityId)
        token = communityObject?.observe { [weak self] community, error in
            if community.dataStatus == .fresh {
                self?.token?.invalidate()
                self?.token = nil
            }
            guard let object = community.object else {
                if let error = AmityError(error: error) {
                    completion?(.failure(error))
                }
                return
            }
            
            let model = AmityCommunityModel(object: object)
            completion?(.success(model))
        }
    }
    
    func join(_ completion: ((AmityError?) -> Void)?) {
        communityRepository.joinCommunity(withId: communityId) { (success, error) in
            if success {
                completion?(nil)
            } else {
                completion?(AmityError(error: error) ?? .unknown)
            }
        }
    }
}
