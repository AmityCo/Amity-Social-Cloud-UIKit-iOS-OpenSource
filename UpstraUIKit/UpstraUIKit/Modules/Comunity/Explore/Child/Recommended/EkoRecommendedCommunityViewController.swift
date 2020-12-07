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
    private let screenViewModel: EkoRecommendedCommunityScreenViewModelType
    
    // MARK: - Callback
    public var selectedCommunityHandler: ((EkoCommunityModel) -> Void)?
    public var emptyDataHandler: ((Bool) -> Void)?
    // MARK: - View lifecycle
    private init(viewModel: EkoRecommendedCommunityScreenViewModelType) {
        self.screenViewModel = viewModel
        super.init(nibName: EkoRecommendedCommunityViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
    }
    
    public static func make() -> EkoRecommendedCommunityViewController {
        let viewModel: EkoRecommendedCommunityScreenViewModelType = EkoRecommendedCommunityScreenViewModel()
        return EkoRecommendedCommunityViewController(viewModel: viewModel)
    }
    
    // MARK: - Refreshahble
    
    func handleRefreshing() {
        screenViewModel.action.getRecommendedCommunity()
    }
    
}

// MARK: - Setup View
private extension EkoRecommendedCommunityViewController {
    
    func setupView() {
        view.backgroundColor = EkoColorSet.base.blend(.shade4)
        setupTitle()
        setupCollectionView()
        
    }
    
    func setupTitle() {
        titleLabel.text = EkoLocalizedStringSet.recommendedCommunityTitle
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
        collectionView.register(EkoRecommendedCommunityCollectionViewCell.nib, forCellWithReuseIdentifier: EkoRecommendedCommunityCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

// MARK: - Binding ViewModel
private extension EkoRecommendedCommunityViewController {
    func bindingViewModel() {
        screenViewModel.action.getRecommendedCommunity()
        
        screenViewModel.dataSource.community.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        screenViewModel.dataSource.isNoData.bind { [weak self] status in
            self?.emptyDataHandler?(status)
        }
    }
}



extension EkoRecommendedCommunityViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        selectedCommunityHandler?(item)
    }
}

extension EkoRecommendedCommunityViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.community.value.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EkoRecommendedCommunityCollectionViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoRecommendedCommunityCollectionViewCell {
            guard let item = screenViewModel.dataSource.item(at: indexPath) else { return }
            cell.display(with: item)
        }
    }
}
