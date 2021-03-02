//
//  EkoPostFetchPostController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoPostFetchPostControllerProtocol {
    func getPostForPostId(withPostId postId: String, completion: ((Result<EkoPostModel, EkoError>) -> Void)?)
}

final class EkoPostFetchPostController: EkoPostFetchPostControllerProtocol {
    
    private let repository = EkoFeedRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var postObject: EkoObject<EkoPost>?
    private var token: EkoNotificationToken?
    
    func getPostForPostId(withPostId postId: String, completion: ((Result<EkoPostModel, EkoError>) -> Void)?) {
        postObject = repository.getPostForPostId(postId)
        token = postObject?.observe { [weak self] (_, error) in
            guard let strongSelf = self else { return }
            if let error = EkoError(error: error) {
                completion?(.failure(error))
            } else {
                if let model = strongSelf.prepareData() {
                    completion?(.success(model))
                } else {
                    completion?(.failure(.unknown))
                }
            }
        }
    }
    
    private func prepareData() -> EkoPostModel? {
        guard let _post = postObject?.object else { return nil }
        let post = EkoPostModel(post: _post)
        if let communityId = post.communityId {
            let participation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
            post.isModerator = participation.getMembership(post.postedUserId)?.communityRoles.contains(.moderator) ?? false
        }
        return post
    }
}
