//
//  EkoPostFooterProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/10/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

/// A default protocol of footer post
public protocol EkoPostFooterProtocol: UITableViewCell {
    var delegate: EkoPostFooterDelegate? { get set }
    var post: EkoPostModel? { get }
    
    func display(post: EkoPostModel)
}

/// A default delegate of footer post
public protocol EkoPostFooterDelegate: class {
    func didPerformAction(_ cell: EkoPostFooterProtocol, action: EkoPostFooterAction)
}

/// A default action of footer post
public enum EkoPostFooterAction {
    case tapLike
    case tapComment
    case tapShare
}
