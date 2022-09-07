//
//  AmityEventHandler.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK
import Photos

/// Global event handler for function overriding
///
/// Events which are interacted on AmityUIKIt will trigger following functions
/// These all functions having its default behavior
///
/// - Parameter
///   - `source` uses to identify the class where the event come from
///   - `id` uses to identify the model we interacted with
///
/// - How it works?
///    1. A `userDidTap` function has been overriden
///    2. User avatar is tapped and `userDidTap` get called
///    3. Code within `userDidTap` get executed depends on what you write
///

open class AmityExtensionEventHandler {
    
    public static var shared = AmityExtensionEventHandler()
    
    public init() { }
    
    /// TrueID finish post from Today
    open func finishPostEvent(_ callbackModel: CommunityPostEventModel) {}
    open func dismissTargetPickerEvent() {}
}
