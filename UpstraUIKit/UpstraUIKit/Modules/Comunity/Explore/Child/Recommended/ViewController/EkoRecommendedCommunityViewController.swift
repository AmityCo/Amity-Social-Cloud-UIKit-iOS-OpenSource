//
//  EkoRecommendedCommunityViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 5/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

/// A view controller for providing recommended community list.
public final class EkoRecommendedCommunityViewController: UIViewController, EkoRefreshable {

    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var screenViewModel: EkoRecommendedCommunityScreenViewModelType!
    
    // MARK: - Callback
    public var selectedCommunityHandler: ((EkoCommunityModel) -> Void)?
    public var emptyHandler: ((Bool) -> Void)?
    
    // MARK: - View lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        screenViewModel.delegate = self
        screenViewModel.action.retrieveRecommended()
    }
    
    public static func make() -> EkoRecommendedCommunityViewController {
        let recommendedController = EkoCommunityRecommendedController()
        let viewModel = EkoRecommendedCommunityScreenViewModel(recommendedController: recommendedController)
        let vc = EkoRecommendedCommunityViewController(nibName: EkoRecommendedCommunityViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Refreshahble
    func handleRefreshing() {
        screenViewModel.action.retrieveRecommended()
    }
    
}

// MARK: - Setup View
private extension EkoRecommendedCommunityViewController {
    
    func setupView() {
        view.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        setupTitle()
        setupCollectionView()
        
    }
    
    func setupTitle() {
        titleLabel.text = EkoLocalizedStringSet.recommendedCommunityTitle.localizedString
        titleLabel.textColor = EkoColorSet.base
        titleLabel.font = EkoFontSet.title
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = view.backgroundColor
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: 156, height: 194)
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 8
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(EkoRecommendedCommunityCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EkoRecommendedCommunityViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let community = screenViewModel.dataSource.community(at: indexPath)
        selectedCommunityHandler?(community)
    }
}

// MARK: - UICollectionViewDataSource
extension EkoRecommendedCommunityViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfRecommended()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EkoRecommendedCommunityCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let community = screenViewModel.dataSource.community(at: indexPath)
        cell.delegate = self
        cell.display(with: community)
        return cell
    }
}

// MARK: - EkoRecommendedCommunityScreenViewModelDelegate
extension EkoRecommendedCommunityViewController: EkoRecommendedCommunityScreenViewModelDelegate {
    func screenViewModel(_ viewModel: EkoRecommendedCommunityScreenViewModelType, didRetrieveRecommended recommended: [EkoCommunityModel], isEmpty: Bool) {
        collectionView.reloadData()
        emptyHandler?(isEmpty)
    }
    
    func screenViewModel(_ viewModel: EkoRecommendedCommunityScreenViewModelType, didFail error: EkoError) {
        emptyHandler?(true)
    }
}

// MARK: - EkoRecommendedCommunityCollectionViewCellDelegate
extension EkoRecommendedCommunityViewController: EkoRecommendedCommunityCollectionViewCellDelegate {
    func cellDidTapOnAvatar(_ cell: EkoRecommendedCommunityCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let community = screenViewModel.dataSource.community(at: indexPath)
        selectedCommunityHandler?(community)
    }
}
