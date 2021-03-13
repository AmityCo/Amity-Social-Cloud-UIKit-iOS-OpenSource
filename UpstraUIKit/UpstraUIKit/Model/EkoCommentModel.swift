//
//  EkoCommentModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 12/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat
/**
 Eko Comment model
 */
public struct EkoCommentModel {
    let id: String
    let displayName: String
    let fileId: String
    let text: String
    let isDeleted: Bool
    let isEdited: Bool
    var createdAt: Date
    var updatedAt: Date
    let childrenNumber: Int
    let childrenComment: [EkoCommentModel]
    let parentId: String?
    let userId: String
    private let myReactions: [String]
    
    // Due to EkoChat 4.0.0 requires comment object for editing and deleting
    // So, this is a workaroud for passing the original object.
    let comment: EkoComment
    
    init(comment: EkoComment) {
        id = comment.commentId
        displayName = comment.user?.displayName ?? EkoLocalizedStringSet.anonymous.localizedString
        fileId = comment.user?.avatarFileId ?? ""
        text = comment.data?["text"] as? String ?? ""
        isDeleted = comment.isDeleted
        isEdited = comment.isEdited
        createdAt = comment.createdAt
        updatedAt = comment.updatedAt
        childrenNumber = Int(comment.childrenNumber)
        parentId = comment.parentId
        userId = comment.userId
        myReactions = comment.myReactions as? [String] ?? []
        childrenComment = comment.childrenComments.map { EkoCommentModel(comment: $0) }
        self.comment = comment
    }
    
    var isChildrenExisted: Bool {
        return comment.childrenNumber > 0
    }
    
    var reactionsCount: Int {
        return Int(comment.reactionsCount)
    }
    
    var isLiked: Bool {
        return myReactions.contains("like")
    }
    
    var isOwner: Bool {
        return userId == UpstraUIKitManagerInternal.shared.client.currentUserId
    }
    
    var isParent: Bool {
        return parentId == nil
    }
    
}
