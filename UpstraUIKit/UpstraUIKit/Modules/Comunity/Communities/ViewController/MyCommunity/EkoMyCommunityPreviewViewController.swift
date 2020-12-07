//
//  EkoMyCommunityViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 21/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final public class EkoMyCommunityPreviewViewController: UIViewController {

    // MARK: -  IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var actionButton: UIButton!
    @IBOutlet private var separatorView: UIView!
    
    // MARK: - Properties
    private let screenViewModel: EkoCommunitiesScreenViewModelType
    
    // MARK: - View lifecycle
    private init(viewModel: EkoCommunitiesScreenViewModelType) {
        self.screenViewModel = viewModel
        super.init(nibName: EkoMyCommunityPreviewViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
    }
    
    static func make(viewModel: EkoCommunitiesScreenViewModelType) -> EkoMyCommunityPreviewViewController {
        let vc = EkoMyCommunityPreviewViewController(viewModel: viewModel)
        return vc
    }
}

private extension EkoMyCommunityPreviewViewController {
    @IBAction func myCommunityTap() {
        screenViewModel.action.route(to: .myCommunity)
    }
}

private extension EkoMyCommunityPreviewViewController {
    func setupView() {
        view.backgroundColor = .white
        
        titleLabel.text = EkoLocalizedStringSet.myCommunityTitle
        titleLabel.font = EkoFontSet.title
        titleLabel.textColor = EkoColorSet.base
        
        actionButton.setImage(EkoIconSet.iconArrowRight, for: .normal)
        actionButton.tintColor = EkoColorSet.base
        separatorView.backgroundColor = EkoColorSet.base.blend(.shade4)
        
        let layout = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)
        layout?.scrollDirection = .horizontal
        layout?.itemSize = CGSize(width: 64, height: 64)
        layout?.minimumLineSpacing = 0
        layout?.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView.backgroundColor = EkoColorSet.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EkoUtilities.UINibs(nibName: EkoMyCommunityCollectionViewCell.identifier), forCellWithReuseIdentifier: EkoMyCommunityCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

private extension EkoMyCommunityPreviewViewController {
    func bindingViewModel() {
        screenViewModel.dataSource.searchCommunities.bind { [weak self] communities in
            self?.collectionView.reloadData()
        }
    }
}

extension EkoMyCommunityPreviewViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 8 {
            screenViewModel.action.route(to: .myCommunity)
        } else {
            screenViewModel.action.route(to: .communityProfile(indexPath: indexPath))
        }
    }
}

extension EkoMyCommunityPreviewViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = screenViewModel.dataSource.searchCommunities.value.count
        return count <= 8 ? count : 9
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EkoMyCommunityCollectionViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoMyCommunityCollectionViewCell {
            if indexPath.row == 8 {
                cell.seeAll()
            } else {
                let community = screenViewModel.dataSource.community(at: indexPath)
                cell.display(with: community)
            }
            
        }
    }
}

