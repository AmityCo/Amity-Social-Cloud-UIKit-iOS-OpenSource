//
//  AmityCommentController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommentControllerProtocol: AmityCommentFetchCommentPostControllerProtocol,
                                         AmityCommentCreateControllerProtocol,
                                         AmityCommentEditorControllerProtocol,
                                         AmityCommentFlaggerControllerProtocol { }

final class AmityCommentController: AmityCommentControllerProtocol {
    
    private let fetchCommentPostController: AmityCommentFetchCommentPostControllerProtocol = AmityCommentFetchCommentPostController()
    private let createController: AmityCommentCreateControllerProtocol = AmityCommentCreateController()
    private let editorController: AmityCommentEditorControllerProtocol = AmityCommentEditorController()
    private let flaggerController: AmityCommentFlaggerControllerProtocol = AmityCommentFlaggerController()
    
}

// MARK: - Fetch Comment Post
extension AmityCommentController {
    
    var hasMoreComments: Bool {
        fetchCommentPostController.hasMoreComments
    }
    
    func getCommentsForPostId(withReferenceId postId: String, referenceType: AmityCommentReferenceType, filterByParentId isParent: Bool, parentId: String?, orderBy: AmityOrderBy, includeDeleted: Bool, completion: ((Result<[AmityCommentModel], AmityError>) -> Void)?) {
        fetchCommentPostController.getCommentsForPostId(withReferenceId: postId, referenceType: referenceType, filterByParentId: isParent, parentId: parentId, orderBy: orderBy, includeDeleted: includeDeleted, completion: completion)
    }
    
    func loadMoreComments() {
        fetchCommentPostController.loadMoreComments()
    }
}

// MARK: - Create
extension AmityCommentController {
    func createComment(withReferenceId postId: String, referenceType: AmityCommentReferenceType, parentId: String?, text: String, metadata: [String : Any]?, mentionees: AmityMentioneesBuilder?, completion: ((AmityComment?, Error?) -> Void)?) {
        createController.createComment(withReferenceId: postId, referenceType: referenceType, parentId: parentId, text: text, metadata: metadata, mentionees: mentionees, completion: completion)
    }
}

// MARK: - Comment Editor
extension AmityCommentController {
    func delete(withCommentId commentId: String, completion: AmityRequestCompletion?) {
        editorController.delete(withCommentId: commentId, completion: completion)
    }
    
    func edit(withComment comment: AmityCommentModel, text: String, metadata: [String : Any]?, mentionees: AmityMentioneesBuilder?, completion: AmityRequestCompletion?) {
        editorController.edit(withComment: comment, text: text, metadata: metadata, mentionees: mentionees, completion: completion)
    }
}

// MARK: - Flagger
extension AmityCommentController {
    func report(withCommentId commentId: String, completion: AmityRequestCompletion?) {
        flaggerController.report(withCommentId: commentId, completion: completion)
    }
    
    func unreport(withCommentId commentId: String, completion: AmityRequestCompletion?) {
        flaggerController.unreport(withCommentId: commentId, completion: completion)
    }
    
    func getReportStatus(withCommentId commentId: String, completion: ((Bool) -> Void)?) {
        flaggerController.getReportStatus(withCommentId: commentId, completion: completion)
    }
}
