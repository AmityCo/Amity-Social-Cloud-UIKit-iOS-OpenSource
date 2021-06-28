//
//  AmityPostController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityPostControllerProtocol: AmityPostFetchFeedControllerProtocol,
                                      AmityPostFetchPostControllerProtocol,
                                      AmityPostDeleteControllerProtocol,
                                      AmityPostFlaggerControllerProtocol,
                                      AmityPostUpdateControllerProtocol { }

final class AmityPostController: AmityPostControllerProtocol {

    private let fetchFeedController: AmityPostFetchFeedControllerProtocol = AmityPostFetchFeedDataController()
    private let fetchPostController: AmityPostFetchPostControllerProtocol = AmityPostFetchPostController()
    private let deleteController: AmityPostDeleteControllerProtocol = AmityPostDeleteController()
    private let flaggerController: AmityPostFlaggerControllerProtocol = AmityPostFlaggerController()
    private let updateController: AmityPostUpdateControllerProtocol = AmityPostUpdateController()
    
}

// MARK: - Fetch feed
extension AmityPostController {
    func fetch(withFeedType type: AmityPostFeedType, completion: ((Result<[AmityPostModel], AmityError>) -> Void)?) {
        fetchFeedController.fetch(withFeedType: type, completion: completion)
    }
    
    func loadMore() -> Bool {
        return fetchFeedController.loadMore()
    }
}

// MARK: - Fetch Post
extension AmityPostController {
    func getPostForPostId(withPostId postId: String, completion: ((Result<AmityPostModel, AmityError>) -> Void)?) {
        fetchPostController.getPostForPostId(withPostId: postId, completion: completion)
    }
}

// MARK: - Delete
extension AmityPostController {
    func delete(withPostId postId: String, parentId: String?, completion: AmityRequestCompletion?) {
        deleteController.delete(withPostId: postId, parentId: parentId, completion: completion)
    }
}

// MARK: - Flagger (Report/Unreport/Status)
extension AmityPostController {
    func report(withPostId postId: String, completion: AmityRequestCompletion?) {
        flaggerController.report(withPostId: postId, completion: completion)
    }
    
    func unreport(withPostId postId: String, completion: AmityRequestCompletion?) {
        flaggerController.unreport(withPostId: postId, completion: completion)
    }
    
    func getReportStatus(withPostId postId: String, completion: @escaping (Bool) -> Void) {
        flaggerController.getReportStatus(withPostId: postId, completion: completion)
    }
}

// MARK: - Post update
extension AmityPostController {
    func update(withPostId postId: String, text: String, completion: AmityRequestCompletion?) {
        updateController.update(withPostId: postId, text: text, completion: completion)
    }
}
