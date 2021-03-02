//
//  EkoPostHeaderProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/10/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

/// A default protocol of header post
public protocol EkoPostHeaderProtocol: UITableViewCell {
    var delegate: EkoPostHeaderDelegate? { get set }
    var post: EkoPostModel? { get }
    
    func display(post: EkoPostModel, shouldShowOption: Bool)
}

/// A default delegate of header post
public protocol EkoPostHeaderDelegate: class {
    func didPerformAction(_ cell: EkoPostHeaderProtocol, action: EkoPostHeaderAction)
}

/// An default action of header post
public enum EkoPostHeaderAction {
    case tapAvatar
    case tapDisplayName
    case tapCommunityName
    case tapOption
}
