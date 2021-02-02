//
//  EkoPostSharingSettings.swift
//  UpstraUIKit
//
//  Created by Hamlet on 21.01.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import Foundation

/// EkoPostSharingSettings defines three type of targets to make post sharable.

public class EkoPostSharingSettings {
    private let privateCommunity: Set<EkoPostSharingTarget>
    private let publicCommunity: Set<EkoPostSharingTarget>
    private let myFeed: Set<EkoPostSharingTarget>

    /**
         Initializes a new sharing setting with the provided targets.

         - Parameters:
            - privateCommunity: Targets for private community, by defoult allows sharing a post  in the origin feed
            - publicCommunity: Targets for public community, by defoult allows sharing a post to everywhere
            - myFeed: Targets for own posts, by defoult allows sharing a post to everywhere

         - Returns: sharing setting.
    */
    public init(privateCommunity: Set<EkoPostSharingTarget> = [EkoPostSharingTarget.originFeed], publicCommunity: Set<EkoPostSharingTarget> = Set(EkoPostSharingTarget.allCases), myFeed: Set<EkoPostSharingTarget> = Set(EkoPostSharingTarget.allCases)) {
        self.privateCommunity = privateCommunity
        self.publicCommunity = publicCommunity
        self.myFeed = myFeed
    }
    
    /// `privateCommunityPostSharingTarget` function must be called to get defined settings for posts of private community
    public func privateCommunityPostSharingTarget() -> Set<EkoPostSharingTarget> {
        return privateCommunity
    }
    
    /// `publicCommunityPostSharingTarget` function must be called to get defined settings for posts of public community
    public func publicCommunityPostSharingTarget() -> Set<EkoPostSharingTarget> {
        return publicCommunity
    }
    
    /// `myFeedPostSharingTarget` function must be called to get defined settings for own posts
    public func myFeedPostSharingTarget() -> Set<EkoPostSharingTarget> {
        return myFeed
    }
    
    /// `userFeedPostSharingTarget` function must be called to get defined settings all  posts except own
    public func userFeedPostSharingTarget() -> Set<EkoPostSharingTarget> {
        var userFeed = myFeed
        userFeed.remove(.myFeed)
        return userFeed
    }
}
