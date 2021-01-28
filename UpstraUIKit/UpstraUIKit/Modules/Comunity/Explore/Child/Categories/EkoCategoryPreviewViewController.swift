//
//  EkoCategoryPreviewViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 5/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

public final class EkoCategoryPreviewViewController: UIViewController, EkoRefreshable {

    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var seeAllButton: UIButton!
    @IBOutlet private var heightCollectionViewContraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let screenViewModel: EkoCategoryPreviewScreenViewModelType
    
    // MARK: - Callback
    public var selectedCategoryHandler: ((EkoCommunityCategoryModel) -> Void)?
    public var selectedCategoriesHandler: (() -> Void)?
    
    // MARK: - View lifecycle
    private init(viewModel: EkoCategoryPreviewScreenViewModelType) {
        self.screenViewModel = viewModel
        super.init(nibName: EkoCategoryPreviewViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
    }
    
    public static func make() -> EkoCategoryPreviewViewController {
        let viewModel: EkoCategoryPreviewScreenViewModelType = EkoCategoryPreviewScreenViewModel()
        return EkoCategoryPreviewViewController(viewModel: viewModel)
    }
    
    // MARK: - Refreshahble
    
    func handleRefreshing() {
        screenViewModel.action.getCategory()
    }
    
}

// MARK: - Action
private extension EkoCategoryPreviewViewController {
    @IBAction func seeAllTap() {
        selectedCategoriesHandler?()
    }
}

// MARK: - Setup View
private extension EkoCategoryPreviewViewController {
    
    func setupView() {        
        setupTitle()
        setupSeeAllButton()
        setupCollectionView()
    }
    
    func setupTitle() {
        titleLabel.text = EkoLocalizedStringSet.categoryTitle.localizedString
        titleLabel.textColor = EkoColorSet.base
        titleLabel.font = EkoFontSet.title
    }
    
    func setupSeeAllButton() {
        seeAllButton.setTitle("", for: .normal)
        seeAllButton.setImage(EkoIconSet.iconNext, for: .normal)
        seeAllButton.tintColor = EkoColorSet.base
    }
    
    func setupCollectionView() {
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(EkoCategoryPreviewCollectionViewCell.nib, forCellWithReuseIdentifier: EkoCategoryPreviewCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

// MARK: - Binding ViewModel
private extension EkoCategoryPreviewViewController {
    func bindingViewModel() {
        screenViewModel.action.getCategory()
        screenViewModel.dataSource.categories.bind { [weak self] (categories) in
            if categories.count > 1 {
                self?.heightCollectionViewContraint.constant = CGFloat(categories.count * (56 / 2))
            } else {
                self?.heightCollectionViewContraint.constant = 56
            }   
            self?.collectionView.reloadData()
        }
    }
}

extension EkoCategoryPreviewViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let column: CGFloat = 2
        let width = (collectionView.frame.width) / column
        return CGSize(width: width, height: 56)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = screenViewModel.dataSource.item(at: indexPath)
        selectedCategoryHandler?(item)
    }
}

extension EkoCategoryPreviewViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfItem()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EkoCategoryPreviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = screenViewModel.dataSource.item(at: indexPath)
        cell.display(with: item)
        return cell
    }
}

