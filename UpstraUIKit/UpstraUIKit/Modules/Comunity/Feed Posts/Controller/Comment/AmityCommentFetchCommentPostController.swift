//
//  AmityCommentFetchCommentPostController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommentFetchCommentPostControllerProtocol {
    func getCommentsForPostId(withReferenceId postId: String, referenceType: AmityCommentReferenceType, filterByParentId isParent: Bool, parentId: String?, orderBy: AmityOrderBy, includeDeleted: Bool, completion: ((Result<[AmityCommentModel], AmityError>) -> Void)?)
}

class AmityCommentFetchCommentPostController: AmityCommentFetchCommentPostControllerProtocol {
    
    private let repository = AmityCommentRepository(client: AmityUIKitManagerInternal.shared.client)
    private var token: AmityNotificationToken?
    private var collection: AmityCollection<AmityComment>?
    
    func getCommentsForPostId(withReferenceId postId: String, referenceType: AmityCommentReferenceType, filterByParentId isParent: Bool, parentId: String?, orderBy: AmityOrderBy, includeDeleted: Bool, completion: ((Result<[AmityCommentModel], AmityError>) -> Void)?) {
        
        token?.invalidate()
        collection = repository.getCommentsWithReferenceId(postId, referenceType: referenceType, filterByParentId: isParent, parentId: parentId, orderBy: orderBy, includeDeleted: includeDeleted)
        
        token = collection?.observe { [weak self] (commentCollection, change, error) in
            guard let strongSelf = self else { return }
            if let error = AmityError(error: error) {
                completion?(.failure(error))
            } else {
                completion?(.success(strongSelf.prepareData()))
            }
        }
    }
        
    private func prepareData() -> [AmityCommentModel] {
        guard let collection = collection else { return [] }
        var models = [AmityCommentModel]()
        for i in 0..<collection.count() {
            guard let comment = collection.object(at: i) else { continue }
            let model = AmityCommentModel(comment: comment)
            models.append(model)
        }
        return models
    }
}
