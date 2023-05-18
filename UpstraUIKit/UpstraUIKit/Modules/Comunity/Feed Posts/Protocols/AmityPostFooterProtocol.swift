//
//  AmityPostFooterProtocol.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/10/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

/// A default protocol of footer post
public protocol AmityPostFooterProtocol: UITableViewCell, AmityCellIdentifiable {
    var delegate: AmityPostFooterDelegate? { get set }
    var post: AmityPostModel? { get }
    
    func display(post: AmityPostModel)
}

/// A default delegate of footer post
public protocol AmityPostFooterDelegate: AnyObject {
    func didPerformAction(_ cell: AmityPostFooterProtocol, action: AmityPostFooterAction)
}

/// A default action of footer post
public enum AmityPostFooterAction {
    case tapLike
    case tapComment
    case tapShare
    case tapReactionDetails
}
