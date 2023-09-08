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
    case reactionDetails
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
    @IBOutlet private weak var reactionDetailContainerView: UIView!
    @IBOutlet private weak var reactionDetailLikeIcon: UIImageView!
    @IBOutlet private weak var reactionDetailLabel: UILabel!
    @IBOutlet private weak var reactionDetailButton: UIButton!
    @IBOutlet private var badgeStackView: UIStackView!
    @IBOutlet private var badgeIconImageView: UIImageView!
    @IBOutlet private var badgeLabel: UILabel!
    
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
        
        reactionDetailLabel.text = ""
        reactionDetailLabel.font = AmityFontSet.caption
        reactionDetailLabel.textColor = AmityColorSet.base.blend(.shade2)
        reactionDetailButton.addTarget(self, action: #selector(onReactionDetailButtonTap), for: .touchUpInside)
        
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
        
        // badge
        badgeLabel.text = AmityLocalizedStringSet.General.moderator.localizedString + " • "
        badgeLabel.font = AmityFontSet.captionBold
        badgeLabel.textColor = AmityColorSet.base.blend(.shade1)
        badgeIconImageView.image = AmityIconSet.iconBadgeModerator

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
        let likeButtonTitle = comment.isLiked ? AmityLocalizedStringSet.General.liked.localizedString : AmityLocalizedStringSet.General.like.localizedString
        likeButton.setTitle(likeButtonTitle, for: .normal)
        
        replyButton.isHidden = layout.type == .reply
        separatorLineView.isHidden = true
        
        if comment.reactionsCount > 0 {
            reactionDetailContainerView.isHidden = false
            reactionDetailButton.isEnabled = true
            reactionDetailLabel.text = comment.reactionsCount.formatUsingAbbrevation()
        } else {
            reactionDetailButton.isEnabled = false
            reactionDetailContainerView.isHidden = true
        }
        
        badgeStackView.isHidden = !comment.isModerator
        
        contentLabel.isExpanded = layout.isExpanded
        
        toggleActionVisibility(comment: comment, layout: layout)
        
        viewReplyButton.isHidden = !layout.shouldShowViewReplyButton(for: comment)
        leadingAvatarImageViewConstraint.constant = layout.space.avatarLeading
        topAvatarImageViewConstraint.constant = layout.space.aboveAvatar
    }
    
    func toggleActionVisibility(comment: AmityCommentModel, layout: AmityCommentView.Layout) {
        let actionButtons = [likeButton, replyButton, optionButton]
        
        if layout.shouldShowActions {
            actionButtons.forEach { $0?.isHidden = false }
            actionStackView.isHidden = false
        } else {
            // Only show reactions count label if present
            if comment.reactionsCount > 0 {
                actionStackView.isHidden = false
                actionButtons.forEach { $0?.isHidden = true }
            } else {
                actionStackView.isHidden = true
            }
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
    
    @objc private func onReactionDetailButtonTap() {
        delegate?.commentView(self, didTapAction: .reactionDetails)
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
            // If actions should be shown OR actions should not be shown but comment reaction detail label should be shown.
            if layout.shouldShowActions || (!layout.shouldShowActions && comment.reactionsCount > 0) {
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
