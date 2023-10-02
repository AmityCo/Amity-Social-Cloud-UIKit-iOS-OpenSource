//
//  AmityRecommendedCommunityViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 5/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
import UIKit

/// A view controller for providing recommended community list.
public final class AmityRecommendedCommunityViewController: UIViewController, AmityRefreshable {

    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var screenViewModel: AmityRecommendedCommunityScreenViewModelType!
    
    // MARK: - Callback
    public var selectedCommunityHandler: ((AmityCommunity) -> Void)?
    public var emptyHandler: ((Bool) -> Void)?
    
    // MARK: - View lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        screenViewModel.delegate = self
        screenViewModel.action.retrieveRecommended()
    }
    
    public static func make() -> AmityRecommendedCommunityViewController {
        let recommendedController = AmityCommunityRecommendedController()
        let viewModel = AmityRecommendedCommunityScreenViewModel(recommendedController: recommendedController)
        let vc = AmityRecommendedCommunityViewController(nibName: AmityRecommendedCommunityViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Refreshahble
    func handleRefreshing() {
        screenViewModel.action.retrieveRecommended()
    }
    
}

// MARK: - Setup View
private extension AmityRecommendedCommunityViewController {
    
    func setupView() {
        view.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        setupTitle()
        setupCollectionView()
        
    }
    
    func setupTitle() {
        titleLabel.text = AmityLocalizedStringSet.recommendedCommunityTitle.localizedString
        titleLabel.textColor = AmityColorSet.base
        titleLabel.font = AmityFontSet.title
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = view.backgroundColor
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: 156, height: 194)
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 8
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(AmityRecommendedCommunityCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AmityRecommendedCommunityViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let community = screenViewModel.dataSource.community(at: indexPath)
        selectedCommunityHandler?(community.object)
    }
}

// MARK: - UICollectionViewDataSource
extension AmityRecommendedCommunityViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfRecommended()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AmityRecommendedCommunityCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let community = screenViewModel.dataSource.community(at: indexPath)
        cell.delegate = self
        cell.display(with: community)
        return cell
    }
}

// MARK: - AmityRecommendedCommunityScreenViewModelDelegate
extension AmityRecommendedCommunityViewController: AmityRecommendedCommunityScreenViewModelDelegate {
    func screenViewModel(_ viewModel: AmityRecommendedCommunityScreenViewModelType, didRetrieveRecommended recommended: [AmityCommunityModel], isEmpty: Bool) {
        collectionView.reloadData()
        emptyHandler?(isEmpty)
    }
    
    func screenViewModel(_ viewModel: AmityRecommendedCommunityScreenViewModelType, didFail error: AmityError) {
        emptyHandler?(true)
    }
}

// MARK: - AmityRecommendedCommunityCollectionViewCellDelegate
extension AmityRecommendedCommunityViewController: AmityRecommendedCommunityCollectionViewCellDelegate {
    func cellDidTapOnAvatar(_ cell: AmityRecommendedCommunityCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let community = screenViewModel.dataSource.community(at: indexPath)
        selectedCommunityHandler?(community.object)
    }
}
