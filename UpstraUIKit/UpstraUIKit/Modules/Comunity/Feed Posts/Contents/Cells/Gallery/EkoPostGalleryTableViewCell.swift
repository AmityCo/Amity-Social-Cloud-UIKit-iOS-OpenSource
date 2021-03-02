//
//  EkoPostGalleryTableViewCell.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

public final class EkoPostGalleryTableViewCell: UITableViewCell, Nibbable, EkoPostProtocol {
    weak var delegate: EkoPostDelegate?
    
    private enum Constant {
        static let CONTENT_MAXIMUM_LINE = 8
        static let CONTENT_ATTACH_MAXIMUM_LINE = 3
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var galleryCollectionView: EkoGalleryCollectionView!
    @IBOutlet private var contentLabel: EkoExpandableLabel!
    
    // MARK: - Properties
    private(set) var post: EkoPostModel?
    private(set) var indexPath: IndexPath?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.isExpanded = false
        contentLabel.text = nil
    }
    
    func display(post: EkoPostModel, shouldExpandContent: Bool, indexPath: IndexPath) {
        self.post = post
        self.indexPath = indexPath
        galleryCollectionView.configure(images: post.images)
        
        contentLabel.text = post.text
        contentLabel.isExpanded = shouldExpandContent
        contentLabel.numberOfLines = !post.images.isEmpty ? Constant.CONTENT_ATTACH_MAXIMUM_LINE : Constant.CONTENT_MAXIMUM_LINE
    }
    
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
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
        contentLabel.font = EkoFontSet.body
        contentLabel.textColor = EkoColorSet.base
        contentLabel.delegate = self
        contentLabel.shouldCollapse = false
        contentLabel.textReplacementType = .character
        contentLabel.numberOfLines = Constant.CONTENT_MAXIMUM_LINE
        contentLabel.isExpanded = false
        
    }
    
    // MARK: - Perform Action
    private func performAction(action: EkoPostAction) {
        delegate?.didPerformAction(self, action: action)
    }
}

// MARK: EkoGalleryCollectionViewDelegate
extension EkoPostGalleryTableViewCell: EkoGalleryCollectionViewDelegate {
    
    func galleryView(_ view: EkoGalleryCollectionView, didRemoveImageAt index: Int) {
        
    }
    
    func galleryView(_ view: EkoGalleryCollectionView, didTapImage image: EkoImage, reference: UIImageView) {
        delegate?.didPerformAction(self, action: .tapImage(image: image))
    }

}

// MARK: EkoPhotoViewerControllerDelegate
extension EkoPostGalleryTableViewCell: EkoPhotoViewerControllerDelegate {
    
    public func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: EkoPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: galleryCollectionView.selectedImageIndex, animated: false)
    }

    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, didScrollToPhotoAt index: Int) {
        galleryCollectionView.selectedImageIndex = index
        photoViewerController.titleLabel.text = "\(index + 1)/\(galleryCollectionView.images.count)"
    }

    func simplePhotoViewerController(_ viewController: EkoPhotoViewerController, savePhotoAt index: Int) {
//        UIImageWriteToSavedPhotosAlbum(images[index], nil, nil, nil)
    }

}

// MARK: EkoPhotoViewerControllerDataSource
extension EkoPostGalleryTableViewCell: EkoPhotoViewerControllerDataSource {
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, configureCell cell: EkoPhotoCollectionViewCell, forPhotoAt index: Int) {
        //
    }
    
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        return nil
    }
    
    public func numberOfItems(in photoViewerController: EkoPhotoViewerController) -> Int {
        return galleryCollectionView.images.count
    }
    
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        let image = galleryCollectionView.images[index]
        if case .downloadable(let fileId, let placeholder) = image.state {
            imageView.setImage(withFileId: fileId, placeholder: placeholder)
        } else {
            image.loadImage(to: imageView)
        }
    }
}

extension EkoPostGalleryTableViewCell: EkoExpandableLabelDelegate {
    
    public func willExpandLabel(_ label: EkoExpandableLabel) {
        performAction(action: .willExpandExpandableLabel(label: label))
    }
    
    public func didExpandLabel(_ label: EkoExpandableLabel) {
        performAction(action: .didExpandExpandableLabel(label: label))
    }
    
    public func willCollapseLabel(_ label: EkoExpandableLabel) {
        performAction(action: .willCollapseExpandableLabel(label: label))
    }
    
    public func didCollapseLabel(_ label: EkoExpandableLabel) {
        performAction(action: .didCollapseExpandableLabel(label: label))
    }
    
    public func expandableLabeldidTap(_ label: EkoExpandableLabel) {
        performAction(action: .tapExpandableLabel(label: label))
    }
    
}
