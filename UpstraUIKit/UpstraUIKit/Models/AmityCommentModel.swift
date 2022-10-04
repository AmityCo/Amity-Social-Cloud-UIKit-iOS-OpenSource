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
    public let id: String
    public let displayName: String
    public let fileURL: String
    public let avatarCustomURL: String
    public let text: String
    public let isDeleted: Bool
    public let isEdited: Bool
    public var createdAt: Date
    public var updatedAt: Date
    public let childrenNumber: Int
    public let childrenComment: [AmityCommentModel]
    public let parentId: String?
    public let userId: String
    public let isAuthorGlobalBanned: Bool
    private let myReactions: [String]
    public let metadata: [String: Any]?
    public let mentionees: [AmityMentionees]?
    public let role: [String]
    
    // Due to AmityChat 4.0.0 requires comment object for editing and deleting
    // So, this is a workaroud for passing the original object.
    let comment: AmityComment
    
    public init(comment: AmityComment) {
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
        role = comment.user?.roles ?? []
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
