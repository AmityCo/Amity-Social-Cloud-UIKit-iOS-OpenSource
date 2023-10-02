//
//  AmityPostSharingTarget.swift
//  AmityUIKit
//
//  Created by Hamlet on 21.01.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation

/// Provides sharing targets for posts
public enum AmityPostSharingTarget: CaseIterable {
    /// post can be shared  in the origin feed
    case originFeed
    
    /// post can be shared  in the origin feed
    case myFeed
    
    /// post can be shared  in public community
    case publicCommunity
    
    /// post can be shared  in private community
    case privateCommunity
    
    /// post can be shared  out of application
    case external
}
