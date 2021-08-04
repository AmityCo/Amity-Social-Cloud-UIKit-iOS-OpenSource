//
//  AmityFeedDataSource.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

/// This protocol for providing to custom post
public protocol AmityFeedDataSource: AnyObject {
    func getUIComponentForPost(post: AmityPostModel, at index: Int) -> AmityPostComposable?
}


