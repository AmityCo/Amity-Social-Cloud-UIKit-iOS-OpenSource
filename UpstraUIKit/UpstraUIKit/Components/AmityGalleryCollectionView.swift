//
//  AmityGalleryCollectionView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 20/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityGalleryCollectionViewDelegate: AnyObject {
    func galleryView(_ view: AmityGalleryCollectionView, didRemoveImageAt index: Int)
    func galleryView(_ view: AmityGalleryCollectionView, didTapMedia media: AmityMedia, reference: UIImageView)
}

class AmityGalleryCollectionView: UICollectionView {
    
    enum Constant {
        static let paddingSpacing: CGFloat = 16
        static let itemSpacing: CGFloat = 8
        static let maxNumberOfItems: Int = 4
    }
    
    weak var actionDelegate: AmityGalleryCollectionViewDelegate?
    private(set) var medias: [AmityMedia] = []
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
    
    public func configure(medias: [AmityMedia]) {
        self.medias = medias
        reloadData()
    }
    
    public func addMedias(_ medias: [AmityMedia]) {
        self.medias += medias
        reloadData()
    }
    
    func updateViewState(for imageId: String, state: AmityGalleryCollectionViewCell.ViewState) {
        guard
            let index = medias.firstIndex(where: { $0.id == imageId }),
            let cell = cellForItem(at: IndexPath(row: index, section: 0)) as? AmityGalleryCollectionViewCell else {
                return
        }
        cell.updateViewState(state)
    }
    
    func viewState(for mediaId: String) -> AmityGalleryCollectionViewCell.ViewState {
        guard let index = medias.firstIndex(where: { $0.id == mediaId }),
            let cell = cellForItem(at: IndexPath(row: index, section: 0)) as? AmityGalleryCollectionViewCell else {
                return .idle
        }
        return cell.viewState
    }
    
    func mediaState(for mediaId: String) -> AmityMediaState {
        guard let media = medias.first(where: { $0.id == mediaId }) else {
            return .error
        }
        return media.state
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
            return medias.count
        }
        return min(medias.count, Constant.maxNumberOfItems)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: AmityGalleryCollectionViewCell.identifier, for: indexPath)
    }
    
}

extension AmityGalleryCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? AmityGalleryCollectionViewCell else {
            assertionFailure("Unhandle cell type")
            return
        }
        
        let media = medias[indexPath.item]
        
        if isEditable {
            cell.display(media: media, isEditable: isEditable, numberText: nil)
            cell.delegate = self
        } else {
            let shouldShowNumber = (medias.count - Constant.maxNumberOfItems > 0) && (indexPath.row == Constant.maxNumberOfItems - 1)
            let numberText: String? = shouldShowNumber ? "+ \(medias.count - Constant.maxNumberOfItems + 1)" : nil
            cell.display(media: media, isEditable: isEditable, numberText: numberText)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? AmityGalleryCollectionViewCell else {
            assertionFailure("Unsupported cell type")
            return
        }
        
        selectedImageIndex = indexPath.item
        
        actionDelegate?.galleryView(
            self,
            didTapMedia: medias[indexPath.item],
            reference: cell.imageView
        )
        
    }
    
}

extension AmityGalleryCollectionView: AmityGalleryCollectionViewCellDelegate {
    
    func didTapCloseButton(_ cell: AmityGalleryCollectionViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        actionDelegate?.galleryView(self, didRemoveImageAt: indexPath.item)
    }
    
}
