//
//  EkoPostFeedTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 23/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

enum EkoPostFeedReferenceType {
    case post
    case comment(commentId: String)
}

protocol EkoPostFeedTableViewCellDelegate: class {
    func cellNeedLayout(_ cell: EkoPostFeedTableViewCell)
    func cellDidTapDisplayName(_ cell: EkoPostFeedTableViewCell, userId: String)
    func cellDidTapCommunityName(_ cell: EkoPostFeedTableViewCell, communityId: String)
    func cellDidTapAvatar(_ cell: EkoPostFeedTableViewCell, userId: String)
    func cellDidTapLike(_ cell: EkoPostFeedTableViewCell, referenceType: EkoPostFeedReferenceType)
    func cellDidTapComment(_ cell: EkoPostFeedTableViewCell, referenceType: EkoPostFeedReferenceType)
    func cellDidTapOption(_ cell: EkoPostFeedTableViewCell, referenceType: EkoPostFeedReferenceType)
    func cellDidTapViewAll(_ cell: EkoPostFeedTableViewCell)
    func cell(_ cell: EkoPostFeedTableViewCell, didTapImage image: EkoImage)
    func cell(_ cell: EkoPostFeedTableViewCell, didTapFile file: EkoFile)
    func cell(_ cell: EkoPostFeedTableViewCell, didUpdate post: EkoPostModel)
    func cell(_ cell: EkoPostFeedTableViewCell, didTapLabel label: EkoExpandableLabel)
    func cell(_ cell: EkoPostFeedTableViewCell, willExpand label: EkoExpandableLabel)
    func cell(_ cell: EkoPostFeedTableViewCell, didExpand label: EkoExpandableLabel)
    func cell(_ cell: EkoPostFeedTableViewCell, willCollapse label: EkoExpandableLabel)
    func cell(_ cell: EkoPostFeedTableViewCell, didCollapse label: EkoExpandableLabel)
}

public class EkoPostFeedTableViewCell: UITableViewCell, Nibbable {
    
    weak var actionDelegate: EkoPostFeedTableViewCellDelegate?
    
    @IBOutlet private weak var avatarView: EkoAvatarView!
    @IBOutlet private weak var displayNameButton: UIButton!
    @IBOutlet private weak var communityNameButton: UIButton!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var contentLabel: EkoExpandableLabel!
    @IBOutlet private weak var galleryView: EkoGalleryCollectionView!
    @IBOutlet private weak var optionButton: UIButton!
    @IBOutlet private weak var likeButton: EkoButton!
    @IBOutlet private weak var commentButton: EkoButton!
    @IBOutlet private weak var shareButton: EkoButton!
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var actionStackView: UIStackView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var secondSeparatorView: UIView!
    @IBOutlet private weak var badgeContainerView: UIView!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private weak var badgeTitleLabel: UILabel!
    @IBOutlet private weak var bottomPanelButton: UIButton!
    @IBOutlet private weak var fileView: EkoFileTableView!
    @IBOutlet private weak var firstCommentView: EkoCommentView!
    @IBOutlet private weak var secondCommentView: EkoCommentView!
    @IBOutlet private weak var topContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var avatarViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var badgeViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var galleryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var fileViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topContainerHeightConstraint: NSLayoutConstraint!
    private var post: EkoPostModel?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        displayNameButton.titleLabel?.font = EkoFontSet.title
        displayNameButton.tintColor = EkoColorSet.base
        communityNameButton.titleLabel?.font = EkoFontSet.title
        communityNameButton.tintColor = EkoColorSet.base
        subtitleLabel.font = EkoFontSet.caption
        galleryView.actionDelegate = self
        galleryView.contentMode = .scaleAspectFill
        galleryView.layer.cornerRadius = 4
        galleryView.clipsToBounds = true
        contentLabel.font = EkoFontSet.body
        contentLabel.shouldCollapse = false
        contentLabel.textReplacementType = .character
        contentLabel.numberOfLines = 8
        contentLabel.isExpanded = false
        contentLabel.delegate = self
        badgeImageView.contentMode = .scaleAspectFit
        badgeImageView.image = EkoIconSet.iconBadgeModerator
        badgeTitleLabel.text = "\(EkoLocalizedStringSet.moderator) • "
        badgeTitleLabel.textColor = EkoColorSet.base.blend(.shade1)
        badgeTitleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        likeButton.setTitle(EkoLocalizedStringSet.liked, for: .selected)
        likeButton.setTitle(EkoLocalizedStringSet.like, for: .normal)
        likeButton.setTintColor(EkoColorSet.primary, for: .selected)
        likeButton.setTintColor(EkoColorSet.base.blend(.shade2), for: .normal)
        likeButton.setTitleColor(EkoColorSet.primary, for: .selected)
        likeButton.setTitleColor(EkoColorSet.base.blend(.shade2), for: .normal)
        commentButton.tintColor = EkoColorSet.base.blend(.shade2)
        commentButton.setTitleColor(EkoColorSet.base.blend(.shade2), for: .normal)
        shareButton.isHidden = true
        separatorView.backgroundColor = EkoColorSet.base.blend(.shade4)
        secondSeparatorView.backgroundColor = EkoColorSet.base.blend(.shade4)
        optionButton.tintColor = EkoColorSet.base
        warningLabel.text = EkoLocalizedStringSet.PostDetail.joinCommunityMessage
        warningLabel.font = EkoFontSet.body
        warningLabel.textColor = EkoColorSet.base.blend(.shade2)
        firstCommentView.backgroundColor = EkoColorSet.backgroundColor
        secondCommentView.backgroundColor = EkoColorSet.backgroundColor
        
        likeButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        commentButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        shareButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
    }
    
    func configure(item: EkoPostModel, shouldContentExpand: Bool, shouldCommunityNameHide: Bool, isFirstCell: Bool) {
        self.post = item
        let isFileAttached = !(item.images.isEmpty && item.files.isEmpty)
        avatarView.setImage(withImageId: item.avatarId, placeholder: EkoIconSet.defaultAvatar)
        avatarView.actionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.actionDelegate?.cellDidTapAvatar(strongSelf, userId: item.postedUserId)
        }
        displayNameButton.contentEdgeInsets = .zero
        displayNameButton.setTitle(item.displayName, for: .normal)
        communityNameButton.contentEdgeInsets = .zero
        communityNameButton.setTitle(item.communityDisplayName, for: .normal)
        communityNameButton.isHidden = shouldCommunityNameHide || item.communityDisplayName == nil
        subtitleLabel.text = item.subtitle
        contentLabel.numberOfLines = isFileAttached ? 3 : 8
        contentLabel.text = item.text
        contentLabel.isExpanded = shouldContentExpand
        likeButton.isSelected = item.isLiked
        likeLabel.isHidden = item.reactionsCount == 0
        likeLabel.text = String.localizedStringWithFormat(EkoLocalizedStringSet.likes, item.reactionsCount.formatUsingAbbrevation())
        commentLabel.isHidden = item.allCommentCount == 0
        commentLabel.text = String.localizedStringWithFormat(EkoLocalizedStringSet.comments, item.allCommentCount.formatUsingAbbrevation())
        
        let isReactionExisted = item.reactionsCount == 0 && item.allCommentCount == 0
        topContainerHeightConstraint.constant = isReactionExisted ? 0 : 40
        optionButton.isHidden = !item.isCommentable
        actionStackView.isHidden = !item.isCommentable
        warningLabel.isHidden = item.isCommentable
        separatorView.isHidden = isReactionExisted && item.isCommentable
        
        galleryView.configure(images: item.images)
        galleryViewHeightConstraint.constant = item.images.isEmpty ? 0 : UIScreen.main.bounds.width
        fileView.actionDelegate = self
        fileView.configure(files: item.files)
        fileView.isExpanded = false
        fileViewHeightConstraint.constant = item.files.isEmpty ? 0 : EkoFileTableView.height(for: item.files.count, isEdtingMode: false, isExpanded: false)
        avatarViewTopConstraint.constant = 12.0
        topContentViewTopConstraint.constant = isFirstCell ? 0 : 8
        if item.isAdmin {
            badgeContainerView.isHidden = item.postAsModerator
            badgeViewWidthConstraint.isActive = item.postAsModerator
        } else {
            badgeContainerView.isHidden = true
            badgeViewWidthConstraint.isActive = true
        }
        setupCommentPreview(comments: item.latestComments)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.isExpanded = false
        contentLabel.text = nil
        avatarView.image = nil
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
    
    private func setupCommentPreview(comments: [EkoCommentModel]) {
        let latestComents = Array(comments.suffix(2))
        let shouldActionShow = post?.isCommentable ?? false
        if latestComents.count > 0 {
            let comment = latestComents[0]
            firstCommentView.configure(with: comment, layout: .commentPreview(shouldActionShow: shouldActionShow))
            firstCommentView.delegate = self
            firstCommentView.contentLabel.delegate = self
            firstCommentView.isHidden = false
        } else {
            firstCommentView.isHidden = true
        }
        if latestComents.count > 1 {
            let comment = latestComents[1]
            secondCommentView.configure(with: comment, layout: .commentPreview(shouldActionShow: shouldActionShow))
            secondCommentView.delegate = self
            secondCommentView.contentLabel.delegate = self
            secondCommentView.isHidden = false
        } else {
            secondCommentView.isHidden = true
        }
    }
    
    @IBAction func tapDisplayName(_ sender: Any) {
        guard let userId = post?.postedUserId else { return }
        actionDelegate?.cellDidTapDisplayName(self, userId: userId)
    }
    
    @IBAction func tapCommunityName(_ sender: Any) {
        guard let communityId = post?.communityId else { return }
        actionDelegate?.cellDidTapCommunityName(self, communityId: communityId)
    }
    
    @IBAction func tapLike(_ sender: Any) {
        actionDelegate?.cellDidTapLike(self, referenceType: .post)
    }
    
    @IBAction func tapComment(_ sender: Any) {
        actionDelegate?.cellDidTapComment(self, referenceType: .post)
    }
    
    @IBAction func tapShare(_ sender: Any) {
        assertionFailure()
    }
    
    @IBAction func tapOption(_ sender: Any) {
        actionDelegate?.cellDidTapOption(self, referenceType: .post)
    }
    
    @IBAction func tapBottomPanel(_ sender: Any) {
        actionDelegate?.cellDidTapComment(self, referenceType: .post)
    }
    
}
extension EkoPostFeedTableViewCell: EkoGalleryCollectionViewDelegate {
    
    func galleryView(_ view: EkoGalleryCollectionView, didRemoveImageAt index: Int) {
        //
    }
    
    func galleryView(_ view: EkoGalleryCollectionView, didTapImage image: EkoImage, reference: UIImageView) {
        actionDelegate?.cell(self, didTapImage: image)
    }

}

extension EkoPostFeedTableViewCell: EkoPhotoViewerControllerDataSource {
    
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, configureCell cell: EkoPhotoCollectionViewCell, forPhotoAt index: Int) {
        //
    }
    
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        return nil
    }
    
    public func numberOfItems(in photoViewerController: EkoPhotoViewerController) -> Int {
        return galleryView.images.count
    }
    
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        let image = galleryView.images[index]
        if case .downloadable(let fileId, let placeholder) = image.state {
            imageView.setImage(withFileId: fileId, placeholder: placeholder)
        } else {
            image.loadImage(to: imageView)
        }
    }
    
}

// MARK: EkoPhotoViewerControllerDelegate
extension EkoPostFeedTableViewCell: EkoPhotoViewerControllerDelegate {
    
    public func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: EkoPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: galleryView.selectedImageIndex, animated: false)
    }

    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, didScrollToPhotoAt index: Int) {
        galleryView.selectedImageIndex = index
        photoViewerController.titleLabel.text = "\(index + 1)/\(galleryView.images.count)"
    }

    func simplePhotoViewerController(_ viewController: EkoPhotoViewerController, savePhotoAt index: Int) {
//        UIImageWriteToSavedPhotosAlbum(images[index], nil, nil, nil)
    }
    
}

extension EkoPostFeedTableViewCell: EkoFileTableViewDelegate {
    
    func fileTableView(_ view: EkoFileTableView, didTapAt index: Int) {
        guard 0..<fileView.files.count ~= index else { return }
        let file = fileView.files[index]
        actionDelegate?.cell(self, didTapFile: file)
    }
    
    func fileTableViewDidDeleteData(_ view: EkoFileTableView, at index: Int) {
        // Do nothing
    }
    
    func fileTableViewDidUpdateData(_ view: EkoFileTableView) {
        // Do nothing
    }
    
    func fileTableViewDidTapViewAll(_ view: EkoFileTableView) {
        actionDelegate?.cellDidTapViewAll(self)
    }
    
}

extension EkoPostFeedTableViewCell: EkoExpandableLabelDelegate {
    
    public func expandableLabeldidTap(_ label: EkoExpandableLabel) {
        actionDelegate?.cell(self, didTapLabel: label)
    }
    
    public func willExpandLabel(_ label: EkoExpandableLabel) {
        actionDelegate?.cell(self, willExpand: label)
    }
    
    public func didExpandLabel(_ label: EkoExpandableLabel) {
        actionDelegate?.cell(self, didExpand: label)
    }
    
    public func willCollapseLabel(_ label: EkoExpandableLabel) {
        actionDelegate?.cell(self, willCollapse: label)
    }
    
    public func didCollapseLabel(_ label: EkoExpandableLabel) {
        actionDelegate?.cell(self, didCollapse: label)
    }
    
}

extension EkoPostFeedTableViewCell: EkoCommentViewDelegate {
    
    func commentView(_ view: EkoCommentView, didTapAction action: EkoCommentViewAction) {
        guard let comment = view.comment else { return }
        switch action {
        case .avatar:
            actionDelegate?.cellDidTapAvatar(self, userId: comment.userId)
        case .like:
            actionDelegate?.cellDidTapLike(self, referenceType: .comment(commentId: comment.id))
        case .option:
            actionDelegate?.cellDidTapOption(self, referenceType: .comment(commentId: comment.id))
        case .reply:
            break
        }
    }
    
}
