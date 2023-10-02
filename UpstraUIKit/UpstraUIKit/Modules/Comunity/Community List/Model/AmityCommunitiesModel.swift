//
//  AmityCommunitiesModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 24/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

struct AmityCommunityModel {
    let communityId: String
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
    let avatarURL: String
    let isPostReviewEnabled: Bool
    let participation: AmityCommunityParticipation
    
    var object: AmityCommunity
    
    init(object: AmityCommunity) {
        self.object = object
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
        self.category = object.categories.first?.name ?? AmityLocalizedStringSet.General.general.localizedString
        self.categoryId = object.categoryIds.first
        self.avatarURL = object.avatar?.fileURL ?? ""
        self.participation = object.participation
        self.isPostReviewEnabled = object.isPostReviewEnabled
    }
    
    /// Returns pending post count.
    var pendingPostCount: Int {
        return object.getPostCount(feedType: .reviewing)
    }
    
    /// Returns published post count
    var publishedPostCount: Int {
        return object.getPostCount(feedType: .published)
    }
    
    /// Returns declined post count.
    var declinedPostCount: Int {
        return object.getPostCount(feedType: .declined)
    }
}
