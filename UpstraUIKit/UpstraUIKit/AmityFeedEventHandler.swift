//
//  AmityFeedEventHandler.swift
//  AmityUIKit
//
//  Created by Hamlet on 27.01.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation

/// Share event handler for feed
///
/// Events which are interacted on AmityUIKIt will trigger following functions
/// These all functions having its default behavior
///
open class AmityFeedEventHandler {
    
    static var shared = AmityFeedEventHandler()
    
    public init() { }
    
    
    /// Event to share a post
    /// It will be triggered when more option is tapped
    ///
    /// A default behavior is presenting a `AmityActivityController`
    open func sharePostDidTap(from source: AmityViewController, postId: String) {
        let viewController = AmityActivityController.make(activityItems: [postId])
        source.present(viewController, animated: true, completion: nil)
    }
    
    /// Event to share a post
    /// It will be triggered when share to group option is tapped
    ///
    /// A default behavior is presenting group list
    open func sharePostToGroupDidTap(from source: AmityViewController, postId: String) {
    }
    
    /// Event to share a post
    /// It will be triggered when share to my timeline option is tapped
    ///
    /// A default behavior is share the post to my timeline
    open func sharePostToMyTimelineDidTap(from source: AmityViewController, postId: String) {
    }
}
