//
//  EkoCommentFetchCommentPostController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommentFetchCommentPostControllerProtocol {
    func getCommentsForPostId(withReferenceId postId: String, referenceType: EkoCommentReferenceType, filterByParentId isParent: Bool, parentId: String?, orderBy: EkoOrderBy, includeDeleted: Bool, completion: ((Result<[EkoCommentModel], EkoError>) -> Void)?)
}

class EkoCommentFetchCommentPostController: EkoCommentFetchCommentPostControllerProtocol {
    
    private let repository = EkoCommentRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var token: EkoNotificationToken?
    private var collection: EkoCollection<EkoComment>?
    
    func getCommentsForPostId(withReferenceId postId: String, referenceType: EkoCommentReferenceType, filterByParentId isParent: Bool, parentId: String?, orderBy: EkoOrderBy, includeDeleted: Bool, completion: ((Result<[EkoCommentModel], EkoError>) -> Void)?) {
        
        token?.invalidate()
        collection = repository.comments(withReferenceId: postId, referenceType: referenceType, filterByParentId: isParent, parentId: parentId, orderBy: orderBy, includeDeleted: includeDeleted)
        
        token = collection?.observe { [weak self] (commentCollection, change, error) in
            guard let strongSelf = self else { return }
            if let error = EkoError(error: error) {
                completion?(.failure(error))
            } else {
                completion?(.success(strongSelf.prepareData()))
            }
        }
    }
        
    private func prepareData() -> [EkoCommentModel] {
        guard let collection = collection else { return [] }
        var models = [EkoCommentModel]()
        for i in 0..<collection.count() {
            guard let comment = collection.object(at: i) else { continue }
            let model = EkoCommentModel(comment: comment)
            models.append(model)
        }
        return models
    }
}
