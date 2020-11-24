//
//  EkoCommentTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 14/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

protocol EkoCommentTableViewCellDelegate: class {
    func commentCellDidTapReadMore(_ cell: EkoCommentTableViewCell)
    func commentCellDidTapLike(_ cell: EkoCommentTableViewCell)
    func commentCellDidTapReply(_ cell: EkoCommentTableViewCell)
    func commentCellDidTapOption(_ cell: EkoCommentTableViewCell)
    func commentCellDidTapAvatar(_ cell: EkoCommentTableViewCell, userId: String)
}

class EkoCommentTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private var commentView: EkoCommentView!
    
    weak var actionDelegate: EkoCommentTableViewCellDelegate?
    
    var labelDelegate: EkoExpandableLabelDelegate? {
        get {
            return commentView.contentLabel.delegate
        }
        set {
            commentView.contentLabel.delegate = newValue
        }
    }
    
    func configure(with comment: EkoCommentModel, layout: EkoCommentViewLayout) {
        commentView.configure(with: comment, layout: layout)
        commentView.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}

extension EkoCommentTableViewCell: EkoCommentViewDelegate {
    
    func commentView(_ view: EkoCommentView, didTapAction action: EkoCommentViewAction) {
        switch action {
        case .avatar:
            actionDelegate?.commentCellDidTapAvatar(self, userId: commentView.comment?.userId ?? "")
        case .like:
            actionDelegate?.commentCellDidTapLike(self)
        case .option:
            actionDelegate?.commentCellDidTapOption(self)
        case .reply:
            actionDelegate?.commentCellDidTapReply(self)
        }
    }
    
}
