//
//  AmityPostHeaderProtocol.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/10/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

/// A default protocol of header post
public protocol AmityPostHeaderProtocol: UITableViewCell, AmityCellIdentifiable {
    var delegate: AmityPostHeaderDelegate? { get set }
    var post: AmityPostModel? { get }
    
    func display(post: AmityPostModel)
}

/// A default delegate of header post
public protocol AmityPostHeaderDelegate: AnyObject {
    func didPerformAction(_ cell: AmityPostHeaderProtocol, action: AmityPostHeaderAction)
}

/// An default action of header post
public enum AmityPostHeaderAction {
    case tapAvatar
    case tapDisplayName
    case tapCommunityName
    case tapOption
}
