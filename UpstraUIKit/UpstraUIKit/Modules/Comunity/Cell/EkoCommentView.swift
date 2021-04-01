//
//  EkoCommentView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 23/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

enum EkoCommentViewLayout {
    case comment(contentExpanded: Bool, shouldActionShow: Bool, shouldLineShow: Bool)
    case commentPreview(shouldActionShow: Bool)
    case reply(contentExpanded: Bool, shouldActionShow: Bool, shouldLineShow: Bool)
}

enum EkoCommentViewAction {
    case avatar
    case like
    case reply
    case option
    case viewReply
}

protocol EkoCommentViewDelegate: class {
    func commentView(_ view: EkoCommentView, didTapAction action: EkoCommentViewAction)
}

class EkoCommentView: EkoView {
    
    @IBOutlet private weak var avatarView: EkoAvatarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: EkoExpandableLabel!
    @IBOutlet private weak var actionStackView: UIStackView!
    @IBOutlet private weak var likeButton: EkoButton!
    @IBOutlet private weak var replyButton: EkoButton!
    @IBOutlet private weak var optionButton: UIButton!
    @IBOutlet private weak var viewReplyButton: EkoButton!
    @IBOutlet private weak var separatorLineView: UIView!
    @IBOutlet private weak var leadingAvatarImageViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topAvatarImageViewConstraint: NSLayoutConstraint!
    
    weak var delegate: EkoCommentViewDelegate?
    private(set) var comment: EkoCommentModel?
    
    override func initial() {
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        avatarView.placeholder = EkoIconSet.defaultAvatar
        avatarView.actionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.commentView(strongSelf, didTapAction: .avatar)
        }
        titleLabel.textColor = EkoColorSet.base
        titleLabel.font = EkoFontSet.bodyBold
        timeLabel.textColor = EkoColorSet.base.blend(.shade1)
        timeLabel.font = EkoFontSet.caption
        contentLabel.textColor = EkoColorSet.base
        contentLabel.font = EkoFontSet.body
        contentLabel.numberOfLines = 8
        separatorLineView.backgroundColor  = EkoColorSet.secondary.blend(.shade4)
        
        likeButton.setTitle(EkoLocalizedStringSet.like.localizedString, for: .normal)
        likeButton.setTitleFont(EkoFontSet.captionBold)
        likeButton.setImage(EkoIconSet.iconLike, for: .normal)
        likeButton.setImage(EkoIconSet.iconLikeFill, for: .selected)
        likeButton.setTitleColor(EkoColorSet.primary, for: .selected)
        likeButton.setTitleColor(EkoColorSet.base.blend(.shade2), for: .normal)
        likeButton.setTintColor(EkoColorSet.primary, for: .selected)
        likeButton.setTintColor(EkoColorSet.base.blend(.shade2), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTap), for: .touchUpInside)
        likeButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        replyButton.setTitle(EkoLocalizedStringSet.reply.localizedString, for: .normal)
        replyButton.setTitleFont(EkoFontSet.captionBold)
        replyButton.setImage(EkoIconSet.iconReply, for: .normal)
        replyButton.tintColor = EkoColorSet.base.blend(.shade2)
        replyButton.setTitleColor(EkoColorSet.primary, for: .selected)
        replyButton.setTitleColor(EkoColorSet.base.blend(.shade2), for: .normal)
        replyButton.addTarget(self, action: #selector(replyButtonTap), for: .touchUpInside)
        replyButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        optionButton.addTarget(self, action: #selector(optionButtonTap), for: .touchUpInside)
        optionButton.tintColor = EkoColorSet.base.blend(.shade2)
        viewReplyButton.setTitle(EkoLocalizedStringSet.viewReply.localizedString, for: .normal)
        viewReplyButton.setTitleFont(EkoFontSet.captionBold)
        viewReplyButton.setTitleColor(EkoColorSet.base.blend(.shade1), for: .normal)
        viewReplyButton.setTintColor(EkoColorSet.base.blend(.shade1), for: .normal)
        viewReplyButton.setImage(EkoIconSet.iconReplyInverse, for: .normal)
        viewReplyButton.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        viewReplyButton.clipsToBounds = true
        viewReplyButton.layer.cornerRadius = 4
        viewReplyButton.setInsets(forContentPadding: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 16), imageTitlePadding: 8)
        viewReplyButton.addTarget(self, action: #selector(viewReplyButtonTap), for: .touchUpInside)
    }
    
    func configure(with comment: EkoCommentModel, layout: EkoCommentViewLayout) {
        self.comment = comment
        
        if comment.isEdited {
            timeLabel.text = String.localizedStringWithFormat(EkoLocalizedStringSet.PostDetail.postDetailCommentEdit.localizedString, comment.createdAt.relativeTime)
        } else {
            timeLabel.text = comment.createdAt.relativeTime
        }
        avatarView.setImage(withImageId: comment.fileId, placeholder: EkoIconSet.defaultAvatar)
        titleLabel.text = comment.displayName
        contentLabel.text = comment.text
        likeButton.isSelected = comment.isLiked
        separatorLineView.isHidden = true
        
        if comment.reactionsCount > 0 {
            likeButton.setTitle(comment.reactionsCount.formatUsingAbbrevation(), for: .normal)
        } else {
            likeButton.setTitle(EkoLocalizedStringSet.like.localizedString, for: .normal)
        }
        
        switch layout {
        case .comment(let contentExpanded, let shouldActionShow,  _):
            contentLabel.isExpanded = contentExpanded
            actionStackView.isHidden = !shouldActionShow
            viewReplyButton.isHidden = true
            replyButton.isHidden = false
            topAvatarImageViewConstraint.constant = 16
            leadingAvatarImageViewConstraint.constant = 16
        case .commentPreview(let shouldActionShow):
            contentLabel.isExpanded = false
            actionStackView.isHidden = !shouldActionShow
            viewReplyButton.isHidden = !comment.isChildrenExisted
            replyButton.isHidden = false
            topAvatarImageViewConstraint.constant = 16
            leadingAvatarImageViewConstraint.constant = 16
        case .reply(let contentExpanded, let shouldActionShow, _):
            contentLabel.isExpanded = contentExpanded
            actionStackView.isHidden = !shouldActionShow
            viewReplyButton.isHidden = true
            replyButton.isHidden = true
            topAvatarImageViewConstraint.constant = 0
            leadingAvatarImageViewConstraint.constant = 52
        }
    }

    @objc private func replyButtonTap() {
        delegate?.commentView(self, didTapAction: .reply)
    }

    @objc private func likeButtonTap() {
        delegate?.commentView(self, didTapAction: .like)
    }

    @objc private func optionButtonTap() {
        delegate?.commentView(self, didTapAction: .option)
    }
    
    @objc private func viewReplyButtonTap() {
        delegate?.commentView(self, didTapAction: .viewReply)
    }
    
}
