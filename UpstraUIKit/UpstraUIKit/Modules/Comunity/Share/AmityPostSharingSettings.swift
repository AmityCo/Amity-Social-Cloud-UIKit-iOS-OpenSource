//
//  AmityPostSharingSettings.swift
//  AmityUIKit
//
//  Created by Hamlet on 21.01.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation

/// AmityPostSharingSettings defines three type of targets to make post sharable.

public class AmityPostSharingSettings {
    private let privateCommunity: Set<AmityPostSharingTarget>
    private let publicCommunity: Set<AmityPostSharingTarget>
    private let myFeed: Set<AmityPostSharingTarget>

    /**
         Initializes a new sharing setting with the provided targets.

         - Parameters:
            - privateCommunity: Targets for private community, by defoult allows sharing a post  in the origin feed
            - publicCommunity: Targets for public community, by defoult allows sharing a post to everywhere
            - myFeed: Targets for own posts, by defoult allows sharing a post to everywhere

         - Returns: sharing setting.
    */
    public init(privateCommunity: Set<AmityPostSharingTarget> = [AmityPostSharingTarget.originFeed], publicCommunity: Set<AmityPostSharingTarget> = Set(AmityPostSharingTarget.allCases), myFeed: Set<AmityPostSharingTarget> = Set(AmityPostSharingTarget.allCases)) {
        self.privateCommunity = privateCommunity
        self.publicCommunity = publicCommunity
        self.myFeed = myFeed
    }
    
    /// `privateCommunityPostSharingTarget` function must be called to get defined settings for posts of private community
    public func privateCommunityPostSharingTarget() -> Set<AmityPostSharingTarget> {
        return privateCommunity
    }
    
    /// `publicCommunityPostSharingTarget` function must be called to get defined settings for posts of public community
    public func publicCommunityPostSharingTarget() -> Set<AmityPostSharingTarget> {
        return publicCommunity
    }
    
    /// `myFeedPostSharingTarget` function must be called to get defined settings for own posts
    public func myFeedPostSharingTarget() -> Set<AmityPostSharingTarget> {
        return myFeed
    }
    
    /// `userFeedPostSharingTarget` function must be called to get defined settings all  posts except own
    public func userFeedPostSharingTarget() -> Set<AmityPostSharingTarget> {
        var userFeed = myFeed
        userFeed.remove(.myFeed)
        return userFeed
    }
}
