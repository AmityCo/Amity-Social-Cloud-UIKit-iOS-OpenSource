//
//  EkoFeedEventHandler.swift
//  UpstraUIKit
//
//  Created by Hamlet on 27.01.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import Foundation

/// Share event handler for feed
///
/// Events which are interacted on UpstraUIKIt will trigger following functions
/// These all functions having its default behavior
///
open class EkoFeedEventHandler {
    
    static var shared = EkoFeedEventHandler()
    
    public init() { }
    
    
    /// Event to share a post
    /// It will be triggered when more option is tapped
    ///
    /// A default behavior is presenting a `EkoActivityController`
    open func sharePostDidTap(from source: EkoViewController, postId: String) {
        let viewController = EkoActivityController.make(activityItems: [postId])
        source.present(viewController, animated: true, completion: nil)
    }
    
    /// Event to share a post
    /// It will be triggered when share to group option is tapped
    ///
    /// A default behavior is presenting group list
    open func sharePostToGroupDidTap(from source: EkoViewController, postId: String) {
    }
    
    /// Event to share a post
    /// It will be triggered when share to my timeline option is tapped
    ///
    /// A default behavior is share the post to my timeline
    open func sharePostToMyTimelineDidTap(from source: EkoViewController, postId: String) {
    }
}
