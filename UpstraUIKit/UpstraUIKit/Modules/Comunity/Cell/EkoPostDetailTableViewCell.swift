//
//  EkoPostDetailTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 24/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

protocol EkoPostDetailTableViewCellDelegate: class {
    func postTableViewCellDidTapLike(_ cell: EkoPostDetailTableViewCell)
    func postTableViewCellDidTapComment(_ cell: EkoPostDetailTableViewCell)
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, didUpdate post: EkoPostModel)
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, didTapDisplayName userId: String)
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, disTapCommunityName communityId: String)
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, didTapImage image: EkoImage)
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, didTapFile file: EkoFile)
}

public class EkoPostDetailTableViewCell: UITableViewCell, Nibbable {
    
    @IBOutlet weak var avatarView: EkoAvatarView!
    @IBOutlet weak var displayNameButton: UIButton!
    @IBOutlet weak var communityNameButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet public weak var contentLabel: EkoExpandableLabel!
    @IBOutlet weak var galleryView: EkoGalleryCollectionView!
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var actionStackView: UIStackView!
    @IBOutlet private weak var likeButton: EkoButton!
    @IBOutlet private weak var commentButton: EkoButton!
    @IBOutlet private weak var shareButton: EkoButton!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var badgeContainerView: UIView!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private weak var badgeTitleLabel: UILabel!
    @IBOutlet private weak var bottomPanelButton: UIButton!
    
    weak var actionDelegate: EkoPostDetailTableViewCellDelegate?
    var galleryDelegate: EkoGalleryCollectionViewDelegate? {
        get {
            return galleryView.actionDelegate
        }
        set {
            return galleryView.actionDelegate = newValue
        }
    }
    
    @IBOutlet weak var galleryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fileViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerHeightConstraint: NSLayoutConstraint!
    // We have 2 constraint for subtitle label. One with title label & one with badge view
    @IBOutlet var subtitleLeadingToBadgeViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fileView: EkoFileTableView!
    @IBOutlet private weak var topContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var avatarViewTopConstraint: NSLayoutConstraint!
    private var post: EkoPostModel?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        avatarView.avatarShape = EkoSettings.avatarShape
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
        badgeImageView.contentMode = .scaleAspectFit
        badgeImageView.image = EkoIconSet.iconBadgeModerator
        badgeTitleLabel.text = "\(EkoLocalizedStringSet.moderator.localizedString) • "
        badgeTitleLabel.textColor = EkoColorSet.base.blend(.shade1)
        badgeTitleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        likeButton.setTitle(EkoLocalizedStringSet.liked.localizedString, for: .selected)
        likeButton.setTitle(EkoLocalizedStringSet.like.localizedString, for: .normal)
        likeButton.setTintColor(EkoColorSet.primary, for: .selected)
        likeButton.setTintColor(EkoColorSet.base.blend(.shade2), for: .normal)
        likeButton.setTitleColor(EkoColorSet.primary, for: .selected)
        likeButton.setTitleColor(EkoColorSet.base.blend(.shade2), for: .normal)
        commentButton.tintColor = EkoColorSet.base.blend(.shade2)
        commentButton.setTitleColor(EkoColorSet.base.blend(.shade2), for: .normal)
        shareButton.isHidden = true
        warningLabel.text = EkoLocalizedStringSet.PostDetail.joinCommunityMessage.localizedString
        warningLabel.font = EkoFontSet.body
        warningLabel.textColor = EkoColorSet.base.blend(.shade2)
        
        likeButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        commentButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        shareButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
    }
    
    func configureDetail(item: EkoPostModel) {
        self.post = item
        let isFileAttached = !(item.images.isEmpty && item.files.isEmpty)
        avatarView.setImage(withImageId: item.avatarId, placeholder: EkoIconSet.defaultAvatar)
        displayNameButton.contentEdgeInsets = .zero
        displayNameButton.setTitle(item.displayName, for: .normal)
        communityNameButton.contentEdgeInsets = .zero
        communityNameButton.setTitle(item.communityDisplayName, for: .normal)
        communityNameButton.isHidden = item.communityDisplayName == nil
        subtitleLabel.text = item.subtitle
        contentLabel.numberOfLines = isFileAttached ? 3 : 8
        contentLabel.text = item.text
        contentLabel.isExpanded = true
        likeButton.isSelected = item.isLiked
        likeLabel.isHidden = item.reactionsCount == 0
        likeLabel.text = String.localizedStringWithFormat(EkoLocalizedStringSet.likes.localizedString, item.reactionsCount.formatUsingAbbrevation())
        commentLabel.isHidden = item.allCommentCount == 0
        commentLabel.text = String.localizedStringWithFormat(EkoLocalizedStringSet.comments.localizedString, item.allCommentCount.formatUsingAbbrevation())
        
        let isReactionExisted = item.reactionsCount == 0 && item.allCommentCount == 0
        topContainerHeightConstraint.constant = isReactionExisted ? 0 : 40
        actionStackView.isHidden = !item.isCommentable
        warningLabel.isHidden = item.isCommentable
        separatorView.isHidden = isReactionExisted && item.isCommentable
        
        galleryView.configure(images: item.images)
        galleryViewHeightConstraint.constant = item.images.isEmpty ? 0 : UIScreen.main.bounds.width
        fileView.actionDelegate = self
        fileView.configure(files: item.files)
        fileView.isExpanded = true
        fileViewHeightConstraint.constant = item.files.isEmpty ? 0 : EkoFileTableView.height(for: item.files.count, isEdtingMode: false, isExpanded: true)
        avatarViewTopConstraint.constant = 0.0
        topContentViewTopConstraint.constant = 0.0
        badgeContainerView.isHidden = !item.isModerator
        subtitleLeadingToBadgeViewConstraint.isActive = item.isModerator
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.isExpanded = false
        contentLabel.text = nil
        avatarView.image = nil
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
    
    @IBAction func tapDisplayName(_ sender: Any) {
        guard let userId = post?.postedUserId else { return }
        actionDelegate?.postTableViewCell(self, didTapDisplayName: userId)
    }
    
    @IBAction func tapCommunityName(_ sender: Any) {
        guard let communityId = post?.communityId else { return }
        actionDelegate?.postTableViewCell(self, disTapCommunityName: communityId)
    }
    
    @IBAction func tapLike(_ sender: Any) {
        actionDelegate?.postTableViewCellDidTapLike(self)
    }
    
    @IBAction func tapComment(_ sender: Any) {
        actionDelegate?.postTableViewCellDidTapComment(self)
    }
    
    @IBAction func tapShare(_ sender: Any) {
        fatalError()
    }
    
    @IBAction func tapBottomPanel(_ sender: Any) {
        actionDelegate?.postTableViewCellDidTapComment(self)
    }
    
}

extension EkoPostDetailTableViewCell: EkoFileTableViewDelegate {
    
    func fileTableView(_ view: EkoFileTableView, didTapAt index: Int) {
        guard 0..<fileView.files.count ~= index else { return }
        let file = fileView.files[index]
        actionDelegate?.postTableViewCell(self, didTapFile: file)
    }
    
    func fileTableViewDidDeleteData(_ view: EkoFileTableView, at index: Int) {
        // Do nothing
    }
    
    func fileTableViewDidUpdateData(_ view: EkoFileTableView) {
        // Do nothing
    }
    
    func fileTableViewDidTapViewAll(_ view: EkoFileTableView) {
        // Do nothing
    }
    
}

extension EkoPostDetailTableViewCell: EkoGalleryCollectionViewDelegate {
    
    func galleryView(_ view: EkoGalleryCollectionView, didRemoveImageAt index: Int) {
        //
    }
    
    func galleryView(_ view: EkoGalleryCollectionView, didTapImage image: EkoImage, reference: UIImageView) {
        actionDelegate?.postTableViewCell(self, didTapImage: image)
    }

}

extension EkoPostDetailTableViewCell: EkoPhotoViewerControllerDataSource {
    
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

extension EkoPostDetailTableViewCell: EkoPhotoViewerControllerDelegate {
    
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
