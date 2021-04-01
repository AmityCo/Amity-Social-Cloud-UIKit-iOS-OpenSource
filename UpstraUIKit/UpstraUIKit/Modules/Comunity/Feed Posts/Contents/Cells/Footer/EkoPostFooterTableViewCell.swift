//
//  EkoPostFooterTableViewCell.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/5/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

/// `EkoPostFooterTableViewCell` for providing a footer of `Post`
public final class EkoPostFooterTableViewCell: UITableViewCell, Nibbable, EkoPostFooterProtocol {
    
    public weak var delegate: EkoPostFooterDelegate?

    // MARK: - IBOutlet Properties
    @IBOutlet private var topContainerView: UIView!
    @IBOutlet private var likeLabel: UILabel!
    @IBOutlet private var commentLabel: UILabel!
    @IBOutlet private var shareLabel: UILabel!
    @IBOutlet private var actionStackView: UIStackView!
    @IBOutlet private var likeButton: EkoButton!
    @IBOutlet private var commentButton: EkoButton!
    @IBOutlet private var shareButton: EkoButton!
    @IBOutlet private var separatorView: [UIView]!
    @IBOutlet private var warningLabel: UILabel!
    
    // MARK: - Properties
    private(set) public var post: EkoPostModel?
    public var indexPath: IndexPath?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupWarningLabel()
        setupLikeButton()
        setupCommentButton()
        setupShareButton()
    }
    
    public func display(post: EkoPostModel) {
        self.post = post
        likeButton.isSelected = post.isLiked
        likeLabel.isHidden = post.reactionsCount == 0
        let reactionsPrefix = post.reactionsCount > 1 ? EkoLocalizedStringSet.likesPlural.localizedString : EkoLocalizedStringSet.likesSingular.localizedString
        likeLabel.text = String.localizedStringWithFormat(reactionsPrefix,
                                                          post.reactionsCount.formatUsingAbbrevation())
        commentLabel.isHidden = post.allCommentCount == 0
        let commentPrefix = post.allCommentCount > 1 ? EkoLocalizedStringSet.commentsPlural.localizedString :
            EkoLocalizedStringSet.commentsSingular.localizedString
        commentLabel.text = String.localizedStringWithFormat(commentPrefix,
                                                             post.allCommentCount.formatUsingAbbrevation())
        
        let isReactionExisted = post.reactionsCount == 0 && post.allCommentCount == 0
        actionStackView.isHidden = !post.isCommentable
        warningLabel.isHidden = post.isCommentable
        topContainerView.isHidden = isReactionExisted
        
        shareButton.isHidden = !EkoPostSharePermission.canSharePost(post: post)
        shareLabel.isHidden = post.sharedCount == 0
        let sharePrefix = post.sharedCount > 1 ? EkoLocalizedStringSet.sharesPlural.localizedString :
            EkoLocalizedStringSet.sharesSingular.localizedString
        shareLabel.text = String.localizedStringWithFormat(sharePrefix, post.sharedCount)
    }
    
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        // separator
        separatorView.forEach { $0.backgroundColor = EkoColorSet.secondary.blend(.shade4) }
    }
    
    private func setupWarningLabel() {
        // warning
        warningLabel.isHidden = true
        warningLabel.text = EkoLocalizedStringSet.PostDetail.joinCommunityMessage.localizedString
        warningLabel.font = EkoFontSet.body
        warningLabel.textColor = EkoColorSet.base.blend(.shade2)
    }
    
    private func setupLikeButton() {
        // like button
        likeButton.setTitle(EkoLocalizedStringSet.liked.localizedString, for: .selected)
        likeButton.setTitle(EkoLocalizedStringSet.like.localizedString, for: .normal)
        likeButton.setTitleColor(EkoColorSet.primary, for: .selected)
        likeButton.setTitleColor(EkoColorSet.base.blend(.shade2), for: .normal)
        likeButton.setImage(EkoIconSet.iconLike, for: .normal)
        likeButton.setImage(EkoIconSet.iconLikeFill, for: .selected)
        likeButton.setTintColor(EkoColorSet.primary, for: .selected)
        likeButton.setTintColor(EkoColorSet.base.blend(.shade2), for: .normal)
        likeButton.setTitleFont(EkoFontSet.bodyBold)
        likeButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        
        // like badge
        likeLabel.textColor = EkoColorSet.base.blend(.shade2)
        likeLabel.font = EkoFontSet.caption
    }
    private func setupCommentButton() {
        // comment button
        commentButton.tintColor = EkoColorSet.base.blend(.shade2)
        commentButton.setTitleColor(EkoColorSet.base.blend(.shade2), for: .normal)
        commentButton.setImage(EkoIconSet.iconComment, for: .normal)
        commentButton.setTintColor(EkoColorSet.base.blend(.shade2), for: .normal)
        commentButton.setTitleFont(EkoFontSet.bodyBold)
        commentButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        
        // comment badge
        commentLabel.textColor = EkoColorSet.base.blend(.shade2)
        commentLabel.font = EkoFontSet.caption
    }
    
    private func setupShareButton() {
        // share button
        shareButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        shareButton.setTitleFont(EkoFontSet.bodyBold)
        
        // share
        shareLabel.textColor = EkoColorSet.base.blend(.shade2)
        shareLabel.font = EkoFontSet.caption
    }
 
    // MARK: - Perform Action
    private func performAction(action: EkoPostFooterAction) {
        delegate?.didPerformAction(self, action: action)
    }
    
}

private extension EkoPostFooterTableViewCell {
    
    @IBAction func likeTap() {
        performAction(action: .tapLike)
    }
    
    @IBAction func commentTap() {
        performAction(action: .tapComment)
    }
    
    @IBAction func shareTap() {
        performAction(action: .tapShare)
    }
    
    @IBAction func panelTap() {
        performAction(action: .tapComment)
    }
    
}
