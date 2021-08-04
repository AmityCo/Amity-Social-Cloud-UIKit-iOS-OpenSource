//
//  AmityFollowInfoModel.swift
//  AmityUIKit
//
//  Created by Hamlet on 17.06.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import AmitySDK

struct AmityFollowInfo {
    let status: AmityFollowStatus?
    let followerCount: Int
    let followingCount: Int
    let pendingCount: Int?
    
    init(followInfo: AmityMyFollowInfo) {
        status = nil
        followerCount = Int(followInfo.followersCount)
        followingCount = Int(followInfo.followingCount)
        pendingCount = Int(followInfo.pendingCount)
    }
    
    init(followInfo: AmityUserFollowInfo) {
        status = followInfo.status
        followerCount = Int(followInfo.followersCount)
        followingCount = Int(followInfo.followingCount)
        pendingCount = nil
    }
}
