//
//  EkoPostSharePermission.swift
//  UpstraUIKit
//
//  Created by Hamlet on 26.01.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import Foundation

class EkoPostSharePermission {

    static func canSharePost(post: EkoPostModel) -> Bool {
        return !getPermittedSharingTargets(post: post).isEmpty
    }
    
    static func canShareToMyTimeline(post: EkoPostModel) -> Bool {
        let targets = getPermittedSharingTargets(post: post)
        let currentUserId = UpstraUIKitManagerInternal.shared.client.currentUserId
        return !(targets.contains(.originFeed) && post.postTargetType == .community && post.post.postedUserId != currentUserId && targets.contains(.myFeed)) || targets.contains(.myFeed)
    }
    
    static func canSharePostToExternal(post: EkoPostModel) -> Bool {
        let targets = getPermittedSharingTargets(post: post)
        return targets.contains(.external)
    }
    
    static func canSharePostToGroup(post: EkoPostModel) -> Bool {
        let targets = getPermittedSharingTargets(post: post)
        return targets.contains(.publicCommunity) || targets.contains(.privateCommunity)
    }
    
    private static func getPermittedSharingTargets(post: EkoPostModel) -> Set<EkoPostSharingTarget> {
        switch post.postTargetType {
        case .user:
            return post.isOwner ? EkoFeedUISettings.shared.myFeedSharingTargets : EkoFeedUISettings.shared.userFeedSharingTargets
        case .community:
            return (post.post.targetCommunity?.isPublic ?? false) ? EkoFeedUISettings.shared.publicCommunitySharingTargets : EkoFeedUISettings.shared.privateCommunitySharingTargets
        @unknown default:
            return []
        }
    }
}
