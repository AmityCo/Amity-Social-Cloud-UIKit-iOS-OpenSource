//
//  EkoCategoryPreviewViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 5/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

public final class EkoCategoryPreviewViewController: UIViewController, EkoRefreshable {
    // MARK: - Constant
    private enum Constant {
        static let column: CGFloat = 2
        static let height: CGFloat = 56
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var seeAllButton: UIButton!
    @IBOutlet private var heightCollectionViewContraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var screenViewModel: EkoCategoryPreviewScreenViewModelType!
    
    // MARK: - Callback
    public var selectedCategoryHandler: ((EkoCommunityCategoryModel) -> Void)?
    public var selectedCategoriesHandler: (() -> Void)?
    public var emptyHandler: ((Bool) -> Void)?
    
    // MARK: - View lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        screenViewModel.delegate = self
        screenViewModel.action.retrieveCategory()
    }
    
    public static func make() -> EkoCategoryPreviewViewController {
        let categoryController = EkoCommunityCategoryController()
        let viewModel = EkoCategoryPreviewScreenViewModel(categoryController: categoryController)
        let vc = EkoCategoryPreviewViewController(nibName: EkoCategoryPreviewViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Refreshahble
    
    func handleRefreshing() {
        screenViewModel.action.retrieveCategory()
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
        collectionView.register(EkoCategoryPreviewCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}


extension EkoCategoryPreviewViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / Constant.column
        return CGSize(width: width, height: Constant.height)
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
        let category = screenViewModel.dataSource.category(at: indexPath)
        selectedCategoryHandler?(category)
    }
}

extension EkoCategoryPreviewViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfCategory()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EkoCategoryPreviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let category = screenViewModel.dataSource.category(at: indexPath)
        cell.display(with: category)
        cell.delegate = self
        return cell
    }
}


extension EkoCategoryPreviewViewController: EkoCategoryPreviewCommunityScreenViewModelDelegate {
    func screenViewModel(_ viewModel: EkoCategoryPreviewScreenViewModelType, didRetrieveCategory category: [EkoCommunityCategoryModel], isEmpty: Bool) {
        emptyHandler?(isEmpty)
        
        let numberOfCategories = category.count
        if numberOfCategories == 0 {
            heightCollectionViewContraint.constant = 0
        } else if numberOfCategories > 1 {
            // Determine number of rows needed
            let itemsPerRow = Int(Constant.column)
            var minNumberOfRows = numberOfCategories / itemsPerRow
            minNumberOfRows = numberOfCategories % itemsPerRow == 0 ? minNumberOfRows : minNumberOfRows + 1
            
            // Determine height
            let finalHeight = CGFloat(minNumberOfRows) * Constant.height
            heightCollectionViewContraint.constant = finalHeight
        } else {
            heightCollectionViewContraint.constant = Constant.height
        }
        collectionView.reloadData()
    }
    
    func screenViewModel(_ viewModel: EkoCategoryPreviewScreenViewModelType, didFail error: EkoError) {
        emptyHandler?(true)
    }
}
    
// MARK: - EkoCategoryPreviewCollectionViewCellDelegate
extension EkoCategoryPreviewViewController: EkoCategoryPreviewCollectionViewCellDelegate {
    func cellDidTapOnAvatar(_ cell: EkoCategoryPreviewCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let category = screenViewModel.dataSource.category(at: indexPath)
        selectedCategoryHandler?(category)
    }
}
