//
//  MediaGalleryViewController.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 2/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

public class AmityPostGalleryViewController: AmityViewController {
    
    public var pageTitle: String = "Gallery"
    
    private var targetType = AmityPostTargetType.user
    private var targetId = ""
    private var screenViewModel: AmityPostGalleryScreenViewModelType!
    
    private var currentMedia: AmityMedia?
    
    private var currentSection: PostGallerySegmentedControlCell.Section?
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    enum C {
        static let postInterimSpace: CGFloat = 8
        static let postLineSpace: CGFloat = 8
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        screenViewModel.delegate = self
        // Start with .image section
        switchTo(.image)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupUI() {
        collectionView.register(PostGallerySegmentedControlCell.self)
        collectionView.register(PostGalleryItemCell.self)
        collectionView.register(PostGalleryFakeItemCell.self)
        collectionView.register(PostGalleryEmptyStateCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func presentPhotoViewer(referenceView: UIImageView, media: AmityMedia) {
        currentMedia = media
        let photoViewerVC = AmityPhotoViewerController(referencedView: referenceView, image: referenceView.image)
        photoViewerVC.dataSource = self
        photoViewerVC.delegate = self
        present(photoViewerVC, animated: true, completion: nil)
    }
    
    private func switchTo(_ section: PostGallerySegmentedControlCell.Section) {
        
        if let currentSection = currentSection, currentSection == section {
            // Prevent switch to the same session.
            return
        }
        
        currentSection = section
        
        let filterPostTypes: Set<String>?
        switch section {
        case .image:
            filterPostTypes = ["image"]
        case .video:
            filterPostTypes = ["video"]
        case .livestream:
            filterPostTypes = ["liveStream"]
        }
        
        let queryOptions = AmityPostQueryOptions(
            targetType: targetType,
            targetId: targetId,
            sortBy: .lastCreated,
            deletedOption: .notDeleted,
            filterPostTypes: filterPostTypes
        )
        screenViewModel.action.switchPostsQuery(to: queryOptions)
    }
    
    public static func make(
        targetType: AmityPostTargetType,
        targetId: String
    ) -> AmityPostGalleryViewController {
        
        let vc = AmityPostGalleryViewController(nibName: AmityPostGalleryViewController.identifier, bundle: AmityUIKitManager.bundle)
        
        let screenViewModel = AmityPostGalleryScreenViewModel()
        screenViewModel.setup(
            postRepository: AmityPostRepository(client: AmityUIKitManagerInternal.shared.client)
        )
        
        vc.screenViewModel = screenViewModel
        vc.targetType = targetType
        vc.targetId = targetId
        
        return vc
    }

}

extension AmityPostGalleryViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        screenViewModel.dataSource.numberOfSections()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        screenViewModel.dataSource.numberOfItemsInSection(section)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = screenViewModel.dataSource.item(at: indexPath)
        
        switch item {
        case .segmentedControl:
            return (collectionView.dequeueReusableCell(for: indexPath) as PostGallerySegmentedControlCell)
        case .post:
            return (collectionView.dequeueReusableCell(for: indexPath) as PostGalleryItemCell)
        case .fakePost:
            return (collectionView.dequeueReusableCell(for: indexPath) as PostGalleryFakeItemCell)
        case .empty:
            return (collectionView.dequeueReusableCell(for: indexPath) as PostGalleryEmptyStateCell)
        }
        
    }
    
}

extension AmityPostGalleryViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let item = screenViewModel.dataSource.item(at: indexPath)
        
        switch item {
        case .segmentedControl:
            let segmenteControlCell = cell as! PostGallerySegmentedControlCell
            segmenteControlCell.setSelectedSection(currentSection, animated: false)
            segmenteControlCell.delegate = self
        case .post(let postObject):
            let itemCell = cell as! PostGalleryItemCell
            itemCell.configure(with: postObject)
        case .fakePost:
            return
        case .empty:
            // Note: The view model just tell that the datasource is empty.
            // The view controller determine which type is currently empty from `currentSection`.
            let emptyStateCell = cell as! PostGalleryEmptyStateCell
            switch currentSection {
            case .image:
                emptyStateCell.configure(image: UIImage(named: "empty_post_gallery_image", in: AmityUIKitManager.bundle, compatibleWith: nil), text: "No photo yet")
            case .video:
                emptyStateCell.configure(image: UIImage(named: "empty_post_gallery_video", in: AmityUIKitManager.bundle, compatibleWith: nil), text: "No video yet")
            case .livestream:
                emptyStateCell.configure(image: UIImage(named: "empty_post_gallery_video", in: AmityUIKitManager.bundle, compatibleWith: nil), text: "No livestream yet")
            case .none:
                assertionFailure("currentSection must already have a value at this point.")
            }
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = screenViewModel.dataSource.item(at: indexPath)
        
        switch item {
        case .segmentedControl:
            return CGSize(
                width: collectionView.bounds.size.width,
                height: PostGallerySegmentedControlCell.height
            )
        case .post, .fakePost:
            // We calculate cell width based on available space to fit the cell.
            let availableWidth = collectionView.bounds.width - C.postInterimSpace
            // We divide by half, because we show post cell two items each row.
            let cellWidth = availableWidth * 0.5
            // We maintain recntangle ratio.
            let cellHeight = cellWidth
            return CGSize(width: cellWidth, height: cellHeight)
        case .empty:
            return CGSize(width: collectionView.bounds.width, height: PostGalleryEmptyStateCell.height)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return C.postInterimSpace
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return C.postLineSpace
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let item = screenViewModel.dataSource.item(at: indexPath)
        switch item {
        case .post(let postObject):
            switch postObject.dataType {
            case "video":
                if let videoInfo = postObject.getVideoInfo() {
                    if let fileUrl = videoInfo.getVideo(resolution: .original), let url = URL(string: fileUrl) {
                        presentVideoPlayer(at: url)
                    } else if let url = URL(string: videoInfo.fileURL ) {
                        presentVideoPlayer(at: url)
                    }
                } else {
                    print("unable to find video url for post: \(postObject.postId)")
                }
            case "image":
                if let imageData = postObject.getImageInfo() {
                    let placeholder = AmityColorSet.base.blend(.shade4).asImage()
                    let itemCell = collectionView.cellForItem(at: indexPath) as! PostGalleryItemCell
                    let state = AmityMediaState.downloadableImage(imageData: imageData, placeholder: placeholder)
                    let media = AmityMedia(state: state, type: .image)
                    presentPhotoViewer(
                        referenceView: itemCell.imageView,
                        media: media
                    )
                } else {
                    print("unable to find image url for post: \(postObject.postId)")
                }
            case "liveStream":
                guard let stream = postObject.getLiveStreamInfo() else {
                    print("unable to find stream for post: \(postObject.postId)")
                    return
                }
                guard !stream.isDeleted else {
                    return
                }
                switch stream.status {
                case .recorded:
                    AmityEventHandler.shared.openRecordedLiveStreamPlayer(
                        from: self,
                        postId: postObject.postId,
                        stream: stream
                    )
                case .live:
                    AmityEventHandler.shared.openLiveStreamPlayer(
                        from: self,
                        postId: postObject.postId,
                        streamId: stream.streamId
                    )
                case .ended, .idle:
                    break
                @unknown default:
                    break
                }
            default:
                assertionFailure("Not implement")
                break
            }
        default:
            break
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = screenViewModel.dataSource.item(at: indexPath)
        switch item {
        case .post:
            return true
        default:
            return false
        }
    }
    
}

extension AmityPostGalleryViewController: AmityPostGalleryScreenViewModelDelegate {
    
    func screenViewModelDidUpdateDataSource(_ viewModel: AmityPostGalleryScreenViewModel) {
        collectionView.reloadData()
    }
    
}

extension AmityPostGalleryViewController: PostGallerySegmentedControlCellDelegate {
    
    func postGallerySegmentedControlCell(_ cell: PostGallerySegmentedControlCell, didTouchSection section: PostGallerySegmentedControlCell.Section) {
        
        cell.setSelectedSection(section, animated: true)
        switchTo(section)
        
    }
    
}

extension AmityPostGalleryViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: AmityPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
    
}

extension AmityPostGalleryViewController: AmityPhotoViewerControllerDataSource {
    
    public func numberOfItems(in photoViewerController: AmityPhotoViewerController) -> Int {
        return 1
    }
    
    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        
        guard let currentMedia = currentMedia else {
            return
        }
        
        switch currentMedia.state {
        case .downloadableImage(let imageData, _):
            imageView.loadImage(with: imageData.fileURL, size: .full, placeholder: nil, optimisticLoad: true)
        default:
            assertionFailure("Not supported")
            break
        }
        
    }
    
    public func photoViewerController(_ photoViewerController: AmityPhotoViewerController, configureCell cell: AmityPhotoCollectionViewCell, forPhotoAt index: Int) {
        
        // We show only one image at a time.
        cell.zoomEnabled = true
        cell.playImageView.isHidden = true
        
    }
    
}

extension AmityPostGalleryViewController: AmityPhotoViewerControllerDelegate {
    
}
