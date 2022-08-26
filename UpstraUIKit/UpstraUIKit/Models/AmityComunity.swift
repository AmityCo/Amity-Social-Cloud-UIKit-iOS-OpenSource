//
//  AmityComunity.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 31/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

public enum ShortcutPostType {
    case shortcut
    case gallery
    case none
}

public struct CommunityPostEventModel {
    public let isSuccessToPost: Bool
    public let userID: String
    public let communityID: String?
    public let postID: String
    public let postType: ShortcutPostType
    
    init(isSuccess: Bool, userId: String, commuId: String? = nil, postId: String, postType: ShortcutPostType = .none) {
        self.isSuccessToPost = isSuccess
        self.userID = userId
        self.communityID = commuId
        self.postID = postId
        self.postType = postType
    }
}
