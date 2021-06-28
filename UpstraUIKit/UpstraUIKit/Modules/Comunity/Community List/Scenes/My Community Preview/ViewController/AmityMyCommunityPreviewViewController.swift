//
//  AmityMyCommunityViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 21/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public protocol AmityMyCommunityPreviewViewControllerDelegate: class {
    func viewController(_ viewController: AmityMyCommunityPreviewViewController, didPerformAction action: AmityMyCommunityPreviewViewController.ActionType)
    func viewController(_ viewController: AmityMyCommunityPreviewViewController, shouldShowMyCommunityPreview: Bool)
}

final public class AmityMyCommunityPreviewViewController: UIViewController {
    
    public enum ActionType {
        case seeAll
        case communityItem(communityId: String)
    }

    // MARK: -  IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var actionButton: UIButton!
    @IBOutlet private var separatorView: UIView!
    
    // MARK: - Properties
    private var screenViewModel: AmityMyCommunityPreviewScreenViewModelType!
    public weak var delegate: AmityMyCommunityPreviewViewControllerDelegate?
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    public static func make() -> AmityMyCommunityPreviewViewController {
        let communityListRepositoryManager = AmityCommunityListRepositoryManager()
        let viewModel = AmityMyCommunityPreviewScreenViewModel(communityListRepositoryManager: communityListRepositoryManager)
        let vc = AmityMyCommunityPreviewViewController(nibName: AmityMyCommunityPreviewViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Setup viewModel
    func retrieveCommunityList() {
        screenViewModel.delegate = self
        screenViewModel.action.retrieveMyCommunityList()
    }
    
    // MARK: - Setup views
    private func setupView() {
        view.backgroundColor = AmityColorSet.backgroundColor
        
        titleLabel.text = AmityLocalizedStringSet.myCommunityTitle.localizedString
        titleLabel.font = AmityFontSet.title
        titleLabel.textColor = AmityColorSet.base
        
        actionButton.setImage(AmityIconSet.iconNext, for: .normal)
        actionButton.tintColor = AmityColorSet.base
        separatorView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        
        let layout = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)
        layout?.scrollDirection = .horizontal
        layout?.itemSize = CGSize(width: 68, height: 64)
        layout?.minimumLineSpacing = 8
        layout?.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView.backgroundColor = AmityColorSet.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AmityMyCommunityCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func myCommunityTap() {
        delegate?.viewController(self, didPerformAction: .seeAll)
    }
    
}

extension AmityMyCommunityPreviewViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if screenViewModel.action.shouldShowSeeAll(indexPath: indexPath) {
            delegate?.viewController(self, didPerformAction: .seeAll)
        } else {
            let communityId = screenViewModel.dataSource.item(at: indexPath).communityId
            delegate?.viewController(self, didPerformAction: .communityItem(communityId: communityId))
        }
    }
}

extension AmityMyCommunityPreviewViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfCommunity()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AmityMyCommunityCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if let cell = cell as? AmityMyCommunityCollectionViewCell {
            if screenViewModel.action.shouldShowSeeAll(indexPath: indexPath) {
                cell.setupSeeAll()
            } else {
                let community = screenViewModel.dataSource.item(at: indexPath)
                cell.display(with: community)
            }
        }
    }
}

extension AmityMyCommunityPreviewViewController: AmityMyCommunityPreviewScreenViewModelDelegate {
    
    func screenViewModel(_ viewModel: AmityMyCommunityPreviewScreenViewModelType, didRetrieveCommunityList communityList: [AmityCommunityModel]) {
        delegate?.viewController(self, shouldShowMyCommunityPreview: communityList.count > 0)
        if communityList.count > 0 {
            collectionView?.reloadData()
        }
    }
    
}
