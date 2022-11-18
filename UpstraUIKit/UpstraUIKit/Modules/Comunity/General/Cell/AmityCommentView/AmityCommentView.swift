//
//  AmityCommentView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 23/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

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
    @IBOutlet private weak var replyButton: AmityButton!
    @IBOutlet private weak var optionButton: UIButton!
    @IBOutlet private weak var viewReplyButton: AmityButton!
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
        replyButton.setTitle(AmityLocalizedStringSet.General.reply.localizedString, for: .normal)
        replyButton.setTitleFont(AmityFontSet.captionBold)
        replyButton.setImage(AmityIconSet.iconReply, for: .normal)
        replyButton.tintColor = AmityColorSet.base.blend(.shade2)
        replyButton.setTitleColor(AmityColorSet.primary, for: .selected)
        replyButton.setTitleColor(AmityColorSet.base.blend(.shade2), for: .normal)
        replyButton.addTarget(self, action: #selector(replyButtonTap), for: .touchUpInside)
        replyButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
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
    }
    
    func configure(with comment: AmityCommentModel, layout: AmityCommentView.Layout) {
        self.comment = comment
        
        if comment.isEdited {
            timeLabel.text = String.localizedStringWithFormat(AmityLocalizedStringSet.PostDetail.postDetailCommentEdit.localizedString, comment.createdAt.relativeTime)
        } else {
            timeLabel.text = comment.createdAt.relativeTime
        }
        avatarView.setImage(withImageURL: comment.fileURL, placeholder: AmityIconSet.defaultAvatar)
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
        
        contentLabel.isExpanded = layout.isExpanded
        actionStackView.isHidden = !layout.shouldActionShow
        viewReplyButton.isHidden = !layout.shouldShowViewReplyButton(for: comment)
        leadingAvatarImageViewConstraint.constant = layout.space.avatarLeading
        topAvatarImageViewConstraint.constant = layout.space.aboveAvatar
        
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
    
    open class func height(with comment: AmityCommentModel, layout: AmityCommentView.Layout, boundingWidth: CGFloat) -> CGFloat {
        
        let topSpace: CGFloat = 65 + layout.space.aboveAvatar
        
        let contentHeight: CGFloat = {
            let maximumLines = layout.isExpanded ? 0 : 8
            let leftSpace: CGFloat = layout.space.avatarLeading + layout.space.avatarViewWidth + 8 + 12
            let rightSpace: CGFloat = 12 + 16
            let labelBoundingWidth = boundingWidth - leftSpace - rightSpace
            let height = AmityExpandableLabel.height(
                for: comment.text,
                font: AmityFontSet.body,
                boundingWidth: labelBoundingWidth,
                maximumLines: maximumLines
            )
            return height
        } ()
        
        
        let bottomStackHeight: CGFloat = {
            var bottomStackViews: [CGFloat] = []
            if layout.shouldActionShow {
                let actionButtonHeight: CGFloat = 22
                bottomStackViews += [actionButtonHeight]
            }
            if layout.shouldShowViewReplyButton(for: comment) {
                let viewReplyHeight: CGFloat = 28
                bottomStackViews += [viewReplyHeight]
            }
            let spaceBetweenElement: CGFloat = 12
            let numberOfSpaceBetweenElements: CGFloat = CGFloat(max(bottomStackViews.count - 1, 0))
            let bottomStackViewHeight = bottomStackViews.reduce(0, +) + (spaceBetweenElement * numberOfSpaceBetweenElements)
            return bottomStackViewHeight
        } ()

        
        return topSpace
        + contentHeight
        + layout.space.belowContent
        + layout.space.aboveStack
        + bottomStackHeight
        + layout.space.belowStack
        
    }
    
}
