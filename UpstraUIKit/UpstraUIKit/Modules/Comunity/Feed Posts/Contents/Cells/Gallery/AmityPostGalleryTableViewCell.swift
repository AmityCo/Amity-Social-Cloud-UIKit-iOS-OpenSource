//
//  AmityPostGalleryTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/8/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public final class AmityPostGalleryTableViewCell: UITableViewCell, Nibbable, AmityPostProtocol {
    public weak var delegate: AmityPostDelegate?
    
    private enum Constant {
        static let contentMaximumLine = 3
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var galleryCollectionView: AmityGalleryCollectionView!
    @IBOutlet private var contentLabel: AmityExpandableLabel!
    
    // MARK: - Properties
    public private(set) var post: AmityPostModel?
    public private(set) var indexPath: IndexPath?
    
    private var mentions: [AmityMention] = []
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        galleryCollectionView.configure(medias: [])
        contentLabel.isExpanded = false
        contentLabel.text = nil
        post = nil
        mentions = []
    }
    
    public func display(post: AmityPostModel, indexPath: IndexPath) {
        self.post = post
        self.indexPath = indexPath
        galleryCollectionView.configure(medias: post.medias)
        
        if let metadata = post.metadata, let mentionees = post.mentionees {
            let attributes = AmityMentionManager.getAttributes(fromText: post.text, withMetadata: metadata, mentionees: mentionees)
            contentLabel.setText(post.text, withAttributes: attributes)
        } else {
            contentLabel.text = post.text
        }
        
        contentLabel.isExpanded = post.appearance.shouldContentExpand
    }
    
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        setupGalleryView()
        setupContentLabel()
    }
    
    private func setupGalleryView() {
        galleryCollectionView.contentMode = .scaleAspectFill
        galleryCollectionView.layer.cornerRadius = 4
        galleryCollectionView.clipsToBounds = true
        galleryCollectionView.actionDelegate = self
    }
    
    private func setupContentLabel() {
        contentLabel.font = AmityFontSet.body
        contentLabel.textColor = AmityColorSet.base
        contentLabel.delegate = self
        contentLabel.shouldCollapse = false
        contentLabel.textReplacementType = .character
        contentLabel.numberOfLines = Constant.contentMaximumLine
        contentLabel.isExpanded = false
        
    }
    
    // MARK: - Perform Action
    private func performAction(action: AmityPostAction) {
        delegate?.didPerformAction(self, action: action)
    }
}

// MARK: AmityGalleryCollectionViewDelegate
extension AmityPostGalleryTableViewCell: AmityGalleryCollectionViewDelegate {
    
    func galleryView(_ view: AmityGalleryCollectionView, didRemoveImageAt index: Int) {
        
    }
    
    func galleryView(_ view: AmityGalleryCollectionView, didTapMedia media: AmityMedia, reference: UIImageView) {
        
        delegate?.didPerformAction(self, action: .tapMedia(media: media))
        
    }

}

// MARK: AmityPhotoViewerControllerDelegate
extension AmityPostGalleryTableViewCell: AmityPhotoViewerControllerDelegate {
    
    public func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: AmityPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: galleryCollectionView.selectedImageIndex, animated: false)
    }

    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, didScrollToPhotoAt index: Int) {
        galleryCollectionView.selectedImageIndex = index
        photoViewerController.titleLabel.text = "\(index + 1)/\(galleryCollectionView.medias.count)"
    }
    
    public func photoViewerControllerDidReceiveTapGesture(_ photoViewerController: AmityPhotoViewerController) {
        
        let currentIndex = photoViewerController.currentPhotoIndex
        let media = galleryCollectionView.medias[currentIndex]
        
        delegate?.didPerformAction(
            self,
            action: .tapMediaInside(media: media, photoViewer: photoViewerController)
        )
        
    }

    func simplePhotoViewerController(_ viewController: AmityPhotoViewerController, savePhotoAt index: Int) {
//        UIImageWriteToSavedPhotosAlbum(images[index], nil, nil, nil)
    }

}

// MARK: AmityPhotoViewerControllerDataSource
extension AmityPostGalleryTableViewCell: AmityPhotoViewerControllerDataSource {
    
    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, configureCell cell: AmityPhotoCollectionViewCell, forPhotoAt index: Int) {
        
        let media = galleryCollectionView.medias[index]
        
        switch media.type {
        case .image:
            cell.zoomEnabled = true
            cell.playImageView.isHidden = true
        case .video:
            cell.zoomEnabled = false
            cell.playImageView.isHidden = false
        }
        
    }
    
    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        return nil
    }
    
    public func numberOfItems(in photoViewerController: AmityPhotoViewerController) -> Int {
        return galleryCollectionView.medias.count
    }
    
    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        
        let media = galleryCollectionView.medias[index]
        
        switch media.state {
        case .downloadableImage(let imageData, _):
            imageView.loadImage(
                with: imageData.fileURL,
                size: .full,
                placeholder: nil,
                optimisticLoad: true
            )
        case .downloadableVideo(_, let thumbnailUrl):
            if let thumbnailUrl = thumbnailUrl {
                imageView.loadImage(
                    with: thumbnailUrl,
                    size: .full,
                    placeholder: AmityIconSet.videoThumbnailPlaceholder,
                    optimisticLoad: true
                )
            } else {
                imageView.image = AmityIconSet.videoThumbnailPlaceholder
            }
            
        default:
            media.loadImage(to: imageView)
        }
        
    }
    
}

extension AmityPostGalleryTableViewCell: AmityExpandableLabelDelegate {
    
    public func willExpandLabel(_ label: AmityExpandableLabel) {
        performAction(action: .willExpandExpandableLabel(label: label))
    }
    
    public func didExpandLabel(_ label: AmityExpandableLabel) {
        performAction(action: .didExpandExpandableLabel(label: label))
    }
    
    public func willCollapseLabel(_ label: AmityExpandableLabel) {
        performAction(action: .willCollapseExpandableLabel(label: label))
    }
    
    public func didCollapseLabel(_ label: AmityExpandableLabel) {
        performAction(action: .didCollapseExpandableLabel(label: label))
    }
    
    public func expandableLabeldidTap(_ label: AmityExpandableLabel) {
        performAction(action: .tapExpandableLabel(label: label))
    }
    
    public func didTapOnMention(_ label: AmityExpandableLabel, withUserId userId: String) {
        performAction(action: .tapOnMentionWithUserId(userId: userId))
    }
}
