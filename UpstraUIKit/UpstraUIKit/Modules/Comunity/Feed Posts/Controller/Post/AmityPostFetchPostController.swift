//
//  AmityPostFetchPostController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityPostFetchPostControllerProtocol {
    func getPostForPostId(withPostId postId: String, completion: ((Result<AmityPostModel, AmityError>) -> Void)?)
}

final class AmityPostFetchPostController: AmityPostFetchPostControllerProtocol {
    
    private let repository = AmityPostRepository(client: AmityUIKitManagerInternal.shared.client)
    private var postObject: AmityObject<AmityPost>?
    private var token: AmityNotificationToken?
    
    func getPostForPostId(withPostId postId: String, completion: ((Result<AmityPostModel, AmityError>) -> Void)?) {
        postObject = repository.getPost(withId: postId)
        token = postObject?.observe { [weak self] (_, error) in
            guard let strongSelf = self else { return }
            if let error = AmityError(error: error) {
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
    
    private func prepareData() -> AmityPostModel? {
        guard let _post = postObject?.object else { return nil }
        let post = AmityPostModel(post: _post)
        if let communityId = post.targetCommunity?.communityId {
            let participation = AmityCommunityParticipation(client: AmityUIKitManagerInternal.shared.client, andCommunityId: communityId)
            post.isModerator = participation.getMember(withId: post.postedUserId)?.hasModeratorRole ?? false
        }
        return post
    }
}
