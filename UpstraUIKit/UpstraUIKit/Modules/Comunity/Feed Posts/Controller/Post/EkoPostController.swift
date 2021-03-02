//
//  EkoPostController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoPostControllerProtocol: EkoPostFetchFeedControllerProtocol,
                                    EkoPostFetchPostControllerProtocol,
                                    EkoPostDeleteControllerProtocol,
                                    EkoPostFlaggerControllerProtocol,
                                    EkoPostUpdateControllerProtocol { }

final class EkoPostController: EkoPostControllerProtocol {

    private let fetchFeedController: EkoPostFetchFeedControllerProtocol = EkoPostFetchFeedDataController()
    private let fetchPostController: EkoPostFetchPostControllerProtocol = EkoPostFetchPostController()
    private let deleteController: EkoPostDeleteControllerProtocol = EkoPostDeleteController()
    private let flaggerController: EkoPostFlaggerControllerProtocol = EkoPostFlaggerController()
    private let updateController: EkoPostUpdateControllerProtocol = EkoPostUpdateController()
    
}

// MARK: - Fetch feed
extension EkoPostController {
    func fetch(withFeedType type: EkoPostFeedType, completion: ((Result<[EkoPostModel], EkoError>) -> Void)?) {
        fetchFeedController.fetch(withFeedType: type, completion: completion)
    }
    
    func loadMore() -> Bool {
        return fetchFeedController.loadMore()
    }
}

// MARK: - Fetch Post
extension EkoPostController {
    func getPostForPostId(withPostId postId: String, completion: ((Result<EkoPostModel, EkoError>) -> Void)?) {
        fetchPostController.getPostForPostId(withPostId: postId, completion: completion)
    }
}

// MARK: - Delete
extension EkoPostController {
    func delete(withPostId postId: String, parentId: String?, completion: EkoRequestCompletion?) {
        deleteController.delete(withPostId: postId, parentId: parentId, completion: completion)
    }
}

// MARK: - Flagger (Report/Unreport/Status)
extension EkoPostController {
    func report(withPostId postId: String, completion: EkoRequestCompletion?) {
        flaggerController.report(withPostId: postId, completion: completion)
    }
    
    func unreport(withPostId postId: String, completion: EkoRequestCompletion?) {
        flaggerController.unreport(withPostId: postId, completion: completion)
    }
    
    func getReportStatus(withPostId postId: String, completion: @escaping (Bool) -> Void) {
        flaggerController.getReportStatus(withPostId: postId, completion: completion)
    }
}

// MARK: - Post update
extension EkoPostController {
    func update(withPostId postId: String, text: String, completion: EkoRequestCompletion?) {
        updateController.update(withPostId: postId, text: text, completion: completion)
    }
}
