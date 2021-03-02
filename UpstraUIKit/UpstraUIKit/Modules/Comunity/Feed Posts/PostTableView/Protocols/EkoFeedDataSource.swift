//
//  EkoFeedDataSource.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

/// This protocol for providing to custom post
public protocol EkoFeedDataSource: class {
    func getUIComponentForPost(post: EkoPostModel, at index: Int) -> EkoPostComposable?
}


