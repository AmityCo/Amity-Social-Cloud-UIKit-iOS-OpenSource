//
//  AmityCommentView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 23/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityCommentViewLayout {
    case comment(contentExpanded: Bool, shouldActionShow: Bool, shouldLineShow: Bool)
    case commentPreview(contentExpanded: Bool, shouldActionShow: Bool)
    case reply(contentExpanded: Bool, shouldActionShow: Bool, shouldLineShow: Bool)
}

enum AmityCommentViewAction {
    case avatar
    case like
    case reply
    case option
    case viewReply
}

protocol AmityCommentViewDelegate: AnyObject {
    func commentView(_ view: AmityCommentView, didTapAction action: AmityCommentViewAction)
}

class AmityCommentView: AmityView {
    
    @IBOutlet private weak var avatarView: AmityAvatarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: AmityExpandableLabel!
    @IBOutlet private var labelContainerView: UIView!
    @IBOutlet private weak var actionStackView: UIStackView!
    @IBOutlet private weak var likeButton: AmityButton!
    @IBOutlet weak var likeButtonWidth: NSLayoutConstraint!
    @IBOutlet private weak var replyButton: AmityButton!
    @IBOutlet weak var replyButtonWidth: NSLayoutConstraint!
    @IBOutlet private weak var optionButton: UIButton!
    @IBOutlet private weak var viewReplyButton: AmityButton!
    @IBOutlet weak var viewReplyButtonWidth: NSLayoutConstraint!
    @IBOutlet private weak var separatorLineView: UIView!
    @IBOutlet private weak var leadingAvatarImageViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topAvatarImageViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bannedImageView: UIImageView!
    @IBOutlet private weak var bannedImageViewWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: AmityCommentViewDelegate?
    private(set) var comment: AmityCommentModel?
    
    override func initial() {
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        avatarView.placeholder = AmityIconSet.defaultAvatar
        avatarView.actionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.commentView(strongSelf, didTapAction: .avatar)
        }
        titleLabel.textColor = AmityColorSet.base
        titleLabel.font = AmityFontSet.bodyBold
        timeLabel.textColor = AmityColorSet.base.blend(.shade1)
        timeLabel.font = AmityFontSet.caption
        contentLabel.textColor = AmityColorSet.base
        contentLabel.font = AmityFontSet.body
        contentLabel.numberOfLines = 8
        separatorLineView.backgroundColor  = AmityColorSet.secondary.blend(.shade4)
        labelContainerView.backgroundColor = AmityColorSet.base.blend(.shade4)
        labelContainerView.layer.cornerRadius = 12
        labelContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        likeButton.setTitle(AmityLocalizedStringSet.General.like.localizedString, for: .normal)
        likeButton.setTitleFont(AmityFontSet.captionBold)
        likeButton.setImage(AmityIconSet.iconLike, for: .normal)
        likeButton.setImage(AmityIconSet.iconLikeFill, for: .selected)
        likeButton.setTitleColor(AmityColorSet.primary, for: .selected)
        likeButton.setTitleColor(AmityColorSet.base.blend(.shade2), for: .normal)
        likeButton.setTintColor(AmityColorSet.primary, for: .selected)
        likeButton.setTintColor(AmityColorSet.base.blend(.shade2), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTap), for: .touchUpInside)
        likeButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        likeButtonWidth.constant = (likeButton.titleLabel!.text! as NSString).size().width + 30
        
        replyButton.setTitle(AmityLocalizedStringSet.General.reply.localizedString, for: .normal)
        replyButton.setTitleFont(AmityFontSet.captionBold)
        replyButton.setImage(AmityIconSet.iconReply, for: .normal)
        replyButton.tintColor = AmityColorSet.base.blend(.shade2)
        replyButton.setTitleColor(AmityColorSet.primary, for: .selected)
        replyButton.setTitleColor(AmityColorSet.base.blend(.shade2), for: .normal)
        replyButton.addTarget(self, action: #selector(replyButtonTap), for: .touchUpInside)
        replyButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        replyButton.sizeToFit()
        replyButtonWidth.constant = (replyButton.titleLabel!.text! as NSString).size().width + 30
        
        optionButton.addTarget(self, action: #selector(optionButtonTap), for: .touchUpInside)
        optionButton.tintColor = AmityColorSet.base.blend(.shade2)
        viewReplyButton.setTitle(AmityLocalizedStringSet.General.viewReply.localizedString, for: .normal)
        viewReplyButton.setTitleFont(AmityFontSet.captionBold)
        viewReplyButton.setTitleColor(AmityColorSet.base.blend(.shade1), for: .normal)
        viewReplyButton.setTintColor(AmityColorSet.base.blend(.shade1), for: .normal)
        viewReplyButton.setImage(AmityIconSet.iconReplyInverse, for: .normal)
        viewReplyButton.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        viewReplyButton.clipsToBounds = true
        viewReplyButton.layer.cornerRadius = 4
        viewReplyButton.setInsets(forContentPadding: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 16), imageTitlePadding: 8)
        viewReplyButton.addTarget(self, action: #selector(viewReplyButtonTap), for: .touchUpInside)
        viewReplyButton.sizeToFit()
        viewReplyButtonWidth.constant = (viewReplyButton.titleLabel!.text! as NSString).size().width + 80
    }
    
    func configure(with comment: AmityCommentModel, layout: AmityCommentViewLayout) {
        self.comment = comment
        
        if comment.isEdited {
            timeLabel.text = String.localizedStringWithFormat(AmityLocalizedStringSet.PostDetail.postDetailCommentEdit.localizedString, comment.createdAt.relativeTime)
        } else {
            timeLabel.text = comment.createdAt.relativeTime
        }
        
        if !(comment.avatarCustomURL.isEmpty) {
            avatarView.setImage(withCustomURL: comment.avatarCustomURL,
                                         placeholder: AmityIconSet.defaultAvatar)
        } else {
            avatarView.setImage(withImageURL: comment.fileURL,
                                         placeholder: AmityIconSet.defaultAvatar)
        }
        titleLabel.text = comment.displayName
        
        if comment.isAuthorGlobalBanned {
            bannedImageView.isHidden = false
            bannedImageViewWidthConstraint.constant = 16
            bannedImageView.image = AmityIconSet.CommunitySettings.iconCommunitySettingBanned
        }
        
        if let metadata = comment.metadata, let mentionees = comment.mentionees {
            let attributes = AmityMentionManager.getAttributes(fromText: comment.text, withMetadata: metadata, mentionees: mentionees)
            contentLabel.setText(comment.text, withAttributes: attributes)
        } else {
            contentLabel.text = comment.text
        }
        
        likeButton.isSelected = comment.isLiked
        separatorLineView.isHidden = true
        
        if comment.reactionsCount > 0 {
            likeButton.setTitle(comment.reactionsCount.formatUsingAbbrevation(), for: .normal)
        } else {
            likeButton.setTitle(AmityLocalizedStringSet.General.like.localizedString, for: .normal)
        }
        likeButtonWidth.constant = (likeButton.titleLabel!.text! as NSString).size().width + 30
        
        switch layout {
        case .comment(let contentExpanded, let shouldActionShow,  _):
            contentLabel.isExpanded = contentExpanded
            actionStackView.isHidden = !shouldActionShow
            viewReplyButton.isHidden = true
            replyButton.isHidden = false
            topAvatarImageViewConstraint.constant = 16
            leadingAvatarImageViewConstraint.constant = 16
        case .commentPreview(let contentExpanded, let shouldActionShow):
            contentLabel.isExpanded = contentExpanded
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

    @IBAction func displaynameTap(_ sender: Any) {
        delegate?.commentView(self, didTapAction: .avatar)
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
    
    func prepareForReuse() {
        bannedImageView.image = nil
        comment = nil
    }
}
