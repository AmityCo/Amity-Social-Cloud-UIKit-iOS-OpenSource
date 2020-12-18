//
//  EkoCommunitiesModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 24/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

public struct EkoCommunityModel {
    public let communityId: String
    let description: String
    let displayName: String
    let isPublic: Bool
    let isOfficial: Bool
    var isJoined: Bool = false
    let channelId: String
    let postsCount: Int
    var membersCount: Int
    let createdAt: Date
    let metadata: [String: Any]?
    let userId: String
    let tags: [String]
    let category: String
    var categoryId: String?
    let avatarId: String
    var isCreator: Bool {
        return UpstraUIKitManagerInternal.shared.client.currentUserId == userId
    }
    
    init(object: EkoCommunity) {
        self.communityId = object.communityId
        self.description = object.communityDescription
        self.displayName = object.displayName
        self.isPublic = object.isPublic
        self.isOfficial = object.isOfficial
        self.isJoined = object.isJoined
        self.channelId = object.channelId
        self.postsCount = Int(object.postsCount)
        self.membersCount = Int(object.membersCount)
        self.createdAt = object.createdAt
        self.metadata = object.metadata as? [String : String]
        self.userId = object.userId
        self.tags = object.tags ?? []
        self.category = object.categories.first?.name ?? EkoLocalizedStringSet.general
        self.categoryId = object.categoryIds.first
        self.avatarId = object.avatar?.fileId ?? ""
    }
}
