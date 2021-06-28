//
//  AmityGalleryCollectionView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 20/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityGalleryCollectionViewDelegate: class {
    func galleryView(_ view: AmityGalleryCollectionView, didRemoveImageAt index: Int)
    func galleryView(_ view: AmityGalleryCollectionView, didTapImage image: AmityImage, reference: UIImageView)
}

class AmityGalleryCollectionView: UICollectionView {
    
    enum Constant {
        static let paddingSpacing: CGFloat = 16
        static let itemSpacing: CGFloat = 8
        static let maxNumberOfItems: Int = 4
    }
    
    weak var actionDelegate: AmityGalleryCollectionViewDelegate?
    private(set) var images: [AmityImage] = []
    var selectedImageIndex: Int = 0
    
    var isEditable: Bool = false {
        didSet {
            setupLayout()
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupLayout()
        contentInset = UIEdgeInsets(top: Constant.paddingSpacing, left: Constant.paddingSpacing, bottom: Constant.paddingSpacing, right: Constant.paddingSpacing)
        isScrollEnabled = false
        register(UINib(nibName: AmityGalleryCollectionViewCell.identifier, bundle: AmityUIKitManager.bundle), forCellWithReuseIdentifier: AmityGalleryCollectionViewCell.identifier)
        dataSource = self
        delegate = self
    }
    
    private func setupLayout() {
        if #available(iOS 13.0, *) {
            let layout = MosaicLayout()
            layout.isEditingeMode = isEditable
            layout.minimumLineSpacing = Constant.itemSpacing
            layout.minimumInteritemSpacing = Constant.itemSpacing
            collectionViewLayout = layout
        } else {
            // iOS 12 and below are not supporting create post with MosaicLayout.
            // Let it works on UICollectionViewFlowLayout instead.
            if isEditable {
                // create mode
                let itemsPerRow: CGFloat = 3
                let paddingSpacing = Constant.paddingSpacing * 2
                let itemSpacing = Constant.itemSpacing * (itemsPerRow - 1)
                let actualWidth = UIScreen.main.bounds.width - paddingSpacing - itemSpacing
                let itemWidth = actualWidth / itemsPerRow
                
                let layout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = Constant.itemSpacing
                layout.minimumInteritemSpacing = Constant.itemSpacing
                layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
                collectionViewLayout = layout
            } else {
                // view mode
                let layout = MosaicLayout()
                layout.isEditingeMode = isEditable
                layout.minimumLineSpacing = Constant.itemSpacing
                layout.minimumInteritemSpacing = Constant.itemSpacing
                collectionViewLayout = layout
            }
        }
    }
    
    public func configure(images: [AmityImage]) {
        self.images = images
        reloadData()
    }
    
    public func addImage(_ images: [AmityImage]) {
        self.images += images
        reloadData()
    }
    
    func updateViewState(for imageId: String, state: AmityGalleryCollectionViewCell.ViewState) {
        guard let index = images.firstIndex(where: { $0.id == imageId }),
            let cell = cellForItem(at: IndexPath(row: index, section: 0)) as? AmityGalleryCollectionViewCell else {
                return
        }
        cell.updateViewState(state)
    }
    
    func viewState(for imageId: String) -> AmityGalleryCollectionViewCell.ViewState {
        guard let index = images.firstIndex(where: { $0.id == imageId }),
            let cell = cellForItem(at: IndexPath(row: index, section: 0)) as? AmityGalleryCollectionViewCell else {
                return .idle
        }
        return cell.viewState
    }
    
    func imageState(for fileId: String) -> AmityImageState {
        guard let image = images.first(where: { $0.id == fileId }) else {
            return .error
        }
        return image.state
    }
    
    public static func height(for contentWidth: CGFloat, numberOfItems: Int) -> CGFloat {
        guard numberOfItems > 0 else {
            return 0
        }
        if MosaicLayout.preferredSement(numberOfItems, isEditingeMode: true) == .grid && numberOfItems > 9 {
            let actualWidth = contentWidth - (Constant.paddingSpacing * 2)
            let itemsPerRow: CGFloat = 3
            let numberOfRows = (CGFloat(numberOfItems) / itemsPerRow).rounded(.up)
            let sumItemSpacing = Constant.itemSpacing * (itemsPerRow - 1)
            let itemWidth = (actualWidth - sumItemSpacing) / itemsPerRow
            return (itemWidth + Constant.itemSpacing) * numberOfRows + Constant.paddingSpacing
        }
        return UIScreen.main.bounds.width
    }
    
}

extension AmityGalleryCollectionView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEditable {
            return images.count
        }
        return min(images.count, Constant.maxNumberOfItems)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: AmityGalleryCollectionViewCell.identifier, for: indexPath)
    }
    
}

extension AmityGalleryCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? AmityGalleryCollectionViewCell else { return }
        if isEditable {
            cell.display(image: images[indexPath.item], isEditable: isEditable, numberText: nil, indexPath: indexPath)
            cell.delegate = self
        } else {
            let shouldShowNumber = (images.count - Constant.maxNumberOfItems > 0) && (indexPath.row == Constant.maxNumberOfItems - 1)
            let numberText: String? = shouldShowNumber ? "+ \(images.count - Constant.maxNumberOfItems + 1)" : nil
            cell.display(image: images[indexPath.item], isEditable: isEditable, numberText: numberText, indexPath: indexPath)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AmityGalleryCollectionViewCell {
            selectedImageIndex = indexPath.item
            actionDelegate?.galleryView(self, didTapImage: images[indexPath.item], reference: cell.imageView)
        }
    }
    
}

extension AmityGalleryCollectionView: AmityGalleryCollectionViewCellDelegate {
    
    func didTapCloseButton(_ cell: AmityGalleryCollectionViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        actionDelegate?.galleryView(self, didRemoveImageAt: indexPath.item)
    }
    
}
