//
//  AmityPostGalleryTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/8/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

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
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        galleryCollectionView.configure(images: [])
        contentLabel.isExpanded = false
        contentLabel.text = nil
    }
    
    public func display(post: AmityPostModel, indexPath: IndexPath) {
        self.post = post
        self.indexPath = indexPath
        galleryCollectionView.configure(images: post.images)
        
        contentLabel.text = post.text
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
    
    func galleryView(_ view: AmityGalleryCollectionView, didTapImage image: AmityImage, reference: UIImageView) {
        delegate?.didPerformAction(self, action: .tapImage(image: image))
    }

}

// MARK: AmityPhotoViewerControllerDelegate
extension AmityPostGalleryTableViewCell: AmityPhotoViewerControllerDelegate {
    
    public func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: AmityPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: galleryCollectionView.selectedImageIndex, animated: false)
    }

    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, didScrollToPhotoAt index: Int) {
        galleryCollectionView.selectedImageIndex = index
        photoViewerController.titleLabel.text = "\(index + 1)/\(galleryCollectionView.images.count)"
    }

    func simplePhotoViewerController(_ viewController: AmityPhotoViewerController, savePhotoAt index: Int) {
//        UIImageWriteToSavedPhotosAlbum(images[index], nil, nil, nil)
    }

}

// MARK: AmityPhotoViewerControllerDataSource
extension AmityPostGalleryTableViewCell: AmityPhotoViewerControllerDataSource {
    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, configureCell cell: AmityPhotoCollectionViewCell, forPhotoAt index: Int) {
        //
    }
    
    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        return nil
    }
    
    public func numberOfItems(in photoViewerController: AmityPhotoViewerController) -> Int {
        return galleryCollectionView.images.count
    }
    
    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        let image = galleryCollectionView.images[index]
        
        if case .downloadable(let fileURL, _) = image.state {
            imageView.loadImage(with: fileURL, size: .full, placeholder: nil, optimisticLoad: true)
        } else {
            image.loadImage(to: imageView)
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
    
}
