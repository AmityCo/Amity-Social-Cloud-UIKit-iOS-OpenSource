//
//  AmityPostSharePermission.swift
//  AmityUIKit
//
//  Created by Hamlet on 26.01.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation

class AmityPostSharePermission {

    static func canSharePost(post: AmityPostModel) -> Bool {
        return !getPermittedSharingTargets(post: post).isEmpty
    }
    
    static func canShareToMyTimeline(post: AmityPostModel) -> Bool {
        let targets = getPermittedSharingTargets(post: post)
        let currentUserId = AmityUIKitManagerInternal.shared.client.currentUserId
        return !(targets.contains(.originFeed) && post.postTargetType == .community && post.postedUserId != currentUserId && targets.contains(.myFeed)) || targets.contains(.myFeed)
    }
    
    static func canSharePostToExternal(post: AmityPostModel) -> Bool {
        let targets = getPermittedSharingTargets(post: post)
        return targets.contains(.external)
    }
    
    static func canSharePostToGroup(post: AmityPostModel) -> Bool {
        let targets = getPermittedSharingTargets(post: post)
        return targets.contains(.publicCommunity) || targets.contains(.privateCommunity)
    }
    
    private static func getPermittedSharingTargets(post: AmityPostModel) -> Set<AmityPostSharingTarget> {
        switch post.postTargetType {
        case .user:
            return post.isOwner ? AmityFeedUISettings.shared.myFeedSharingTargets : AmityFeedUISettings.shared.userFeedSharingTargets
        case .community:
            return (post.targetCommunity?.isPublic ?? false) ? AmityFeedUISettings.shared.publicCommunitySharingTargets : AmityFeedUISettings.shared.privateCommunitySharingTargets
        @unknown default:
            return []
        }
    }
}
