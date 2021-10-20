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
    func delete(withComment comment: AmityCommentModel, completion: AmityRequestCompletion?)
    func edit(withComment comment: AmityCommentModel, text: String, completion: AmityRequestCompletion?)
}

final class AmityCommentEditorController: AmityCommentEditorControllerProtocol {
    
    private var editor: AmityCommentEditor?
    private var commentRepository: AmityCommentRepository?
    func delete(withComment comment: AmityCommentModel, completion: AmityRequestCompletion?) {
        commentRepository = AmityCommentRepository(client: AmityUIKitManagerInternal.shared.client)
        commentRepository?.deleteComment(withId: comment.comment.commentId, completion: completion)
    }
        
    func edit(withComment comment: AmityCommentModel, text: String, completion: AmityRequestCompletion?) {
        editor = AmityCommentEditor(client: AmityUIKitManagerInternal.shared.client, commentId: comment.comment.commentId)
        editor?.editText(text, completion: completion)
    }
}
