//
//  AmityCommentEditorController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommentEditorControllerProtocol {
    func delete(withCommentId commentId: String, completion: AmityRequestCompletion?)
    func edit(withComment comment: AmityCommentModel, text: String, metadata: [String : Any]?, mentionees: AmityMentioneesBuilder?, completion: AmityRequestCompletion?)
}

final class AmityCommentEditorController: AmityCommentEditorControllerProtocol {
    
    private var editor: AmityCommentEditor?
    private var commentRepository: AmityCommentRepository?
    func delete(withCommentId commentId: String, completion: AmityRequestCompletion?) {
        commentRepository = AmityCommentRepository(client: AmityUIKitManagerInternal.shared.client)
        commentRepository?.deleteComment(withId: commentId, hardDelete: false, completion: completion)
    }
        
    func edit(withComment comment: AmityCommentModel, text: String, metadata: [String : Any]?, mentionees: AmityMentioneesBuilder?, completion: AmityRequestCompletion?) {
        commentRepository = AmityCommentRepository(client: AmityUIKitManagerInternal.shared.client)
        let options = AmityCommentUpdateOptions(text: text, metadata: metadata, mentioneesBuilder: mentionees)
        
        // Map completion to AmityCommentRequestCompletion
        let mappedCompletion: (AmityComment?, Error?) -> Void = { comment, error in
            if let error {
                completion?(false, error)
            } else if comment != nil {
                completion?(true, nil)
            }
        }
        
        commentRepository?.updateComment(withId: comment.id, options: options, completion: mappedCompletion)
    }
}
