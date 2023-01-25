//
//  AmityCommentModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 12/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
/**
 Amity Comment model
 */
public struct AmityCommentModel {
    let id: String
    let displayName: String
    let fileURL: String
    let avatarCustomURL: String
    let text: String
    let isDeleted: Bool
    let isEdited: Bool
    var createdAt: Date
    var updatedAt: Date
    let childrenNumber: Int
    let childrenComment: [AmityCommentModel]
    let parentId: String?
    let userId: String
    let isAuthorGlobalBanned: Bool
    private let myReactions: [String]
    let metadata: [String: Any]?
    let mentionees: [AmityMentionees]?
    
    // Due to AmityChat 4.0.0 requires comment object for editing and deleting
    // So, this is a workaroud for passing the original object.
    let comment: AmityComment
    
    init(comment: AmityComment) {
        id = comment.commentId
        displayName = comment.user?.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString
        fileURL = comment.user?.getAvatarInfo()?.fileURL ?? ""
        avatarCustomURL = comment.user?.avatarCustomUrl ?? ""
        text = comment.data?["text"] as? String ?? ""
        isDeleted = comment.isDeleted
        isEdited = comment.isEdited
        createdAt = comment.createdAt
        updatedAt = comment.updatedAt
        childrenNumber = Int(comment.childrenNumber)
        parentId = comment.parentId
        userId = comment.userId
        myReactions = comment.myReactions
        childrenComment = comment.childrenComments.map { AmityCommentModel(comment: $0) }
        self.comment = comment
        isAuthorGlobalBanned = comment.user?.isGlobalBan ?? false
        metadata = comment.metadata
        mentionees = comment.mentionees
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
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    
    var isParent: Bool {
        return parentId == nil
    }
    
}
