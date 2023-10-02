//
//  AmityPostReviewSettingsCommunityViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 13/7/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityPostReviewSettingsCommunityViewModelProtocol {
    func getCommunity(_ completion: ((Result<AmityCommunityModel, AmityError>) -> Void)?)
}

final class AmityPostReviewSettingsCommunityViewModel: AmityPostReviewSettingsCommunityViewModelProtocol {
    
    private weak var communityRepository: AmityCommunityRepository?
    private var token: AmityNotificationToken?
    private var community: AmityObject<AmityCommunity>?
    private let communityId: String
    
    init(communityId: String,
         communityRepository: AmityCommunityRepository) {
        self.communityId = communityId
        self.communityRepository = communityRepository
    }
    
    func getCommunity(_ completion: ((Result<AmityCommunityModel, AmityError>) -> Void)?) {
        community = communityRepository?.getCommunity(withId: communityId)
        token = community?.observe { [weak self] (community, error) in
            if community.dataStatus == .fresh {
                self?.token?.invalidate()
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
    }
}
