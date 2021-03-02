//
//  EkoPostPreviewCommentProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/10/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

protocol EkoPostPreviewCommentProtocol: UITableViewCell {
    var delegate: EkoPostPreviewCommentDelegate? { get set }
    var post: EkoPostModel? { get }
    
    func display(post: EkoPostModel, comment: EkoCommentModel?)
}

protocol EkoPostPreviewCommentDelegate: class {
    func didPerformAction(_ cell: EkoPostPreviewCommentProtocol, action: EkoPostPreviewCommentAction)
}

enum EkoPostPreviewCommentAction {
    case tapAvatar(comment: EkoCommentModel)
    case tapLike(comment: EkoCommentModel)
    case tapOption(comment: EkoCommentModel)
    case tapReply(comment: EkoCommentModel)
    case tapExpandableLabel(label: EkoExpandableLabel)
    case willExpandExpandableLabel(label: EkoExpandableLabel)
    case didExpandExpandableLabel(label: EkoExpandableLabel)
    case willCollapseExpandableLabel(label: EkoExpandableLabel)
    case didCollapseExpandableLabel(label: EkoExpandableLabel)
}
