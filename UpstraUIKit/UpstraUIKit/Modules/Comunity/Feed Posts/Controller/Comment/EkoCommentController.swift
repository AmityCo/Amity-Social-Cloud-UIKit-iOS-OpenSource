//
//  EkoCommentController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommentControllerProtocol: EkoCommentFetchCommentPostControllerProtocol,
                                       EkoCommentCreateControllerProtocol,
                                       EkoCommentEditorControllerProtocol,
                                       EkoCommentFlaggerControllerProtocol { }

final class EkoCommentController: EkoCommentControllerProtocol {
    
    private let fetchCommentPostController: EkoCommentFetchCommentPostControllerProtocol = EkoCommentFetchCommentPostController()
    private let createController: EkoCommentCreateControllerProtocol = EkoCommentCreateController()
    private let editorController: EkoCommentEditorControllerProtocol = EkoCommentEditorController()
    private let flaggerController: EkoCommentFlaggerControllerProtocol = EkoCommentFlaggerController()
    
}

// MARK: - Fetch Comment Post
extension EkoCommentController {
    func getCommentsForPostId(withReferenceId postId: String, referenceType: EkoCommentReferenceType, filterByParentId isParent: Bool, parentId: String?, orderBy: EkoOrderBy, includeDeleted: Bool, completion: ((Result<[EkoCommentModel], EkoError>) -> Void)?) {
        fetchCommentPostController.getCommentsForPostId(withReferenceId: postId, referenceType: referenceType, filterByParentId: isParent, parentId: parentId, orderBy: orderBy, includeDeleted: includeDeleted, completion: completion)
    }
}

// MARK: - Create
extension EkoCommentController {
    func createComment(withReferenceId postId: String, referenceType: EkoCommentReferenceType, parentId: String?, text: String, completion: ((EkoComment?, Error?) -> Void)?) {
        createController.createComment(withReferenceId: postId, referenceType: referenceType, parentId: parentId, text: text, completion: completion)
    }
}

// MARK: - Comment Editor
extension EkoCommentController {
    func delete(withComment comment: EkoCommentModel, completion: EkoRequestCompletion?) {
        editorController.delete(withComment: comment, completion: completion)
    }
    
    func edit(withComment comment: EkoCommentModel, text: String, completion: EkoRequestCompletion?) {
        editorController.edit(withComment: comment, text: text, completion: completion)
    }
}

// MARK: - Flagger
extension EkoCommentController {
    func report(withCommentId commentId: String, completion: EkoRequestCompletion?) {
        flaggerController.report(withCommentId: commentId, completion: completion)
    }
    
    func unreport(withCommentId commentId: String, completion: EkoRequestCompletion?) {
        flaggerController.unreport(withCommentId: commentId, completion: completion)
    }
    
    func getReportStatus(withCommentId commentId: String, completion: @escaping (Bool) -> Void) {
        flaggerController.getReportStatus(withCommentId: commentId, completion: completion)
    }
}
