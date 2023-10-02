//
//  AmityCategoryPreviewViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 5/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public final class AmityCategoryPreviewViewController: UIViewController, AmityRefreshable {
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
    private var screenViewModel: AmityCategoryPreviewScreenViewModelType!
    
    // MARK: - Callback
    public var selectedCategoryHandler: ((AmityCommunityCategoryModel) -> Void)?
    public var selectedCategoriesHandler: (() -> Void)?
    public var emptyHandler: ((Bool) -> Void)?
    
    // MARK: - View lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        screenViewModel.delegate = self
        screenViewModel.action.retrieveCategory()
    }
    
    public static func make() -> AmityCategoryPreviewViewController {
        let categoryController = AmityCommunityCategoryController()
        let viewModel = AmityCategoryPreviewScreenViewModel(categoryController: categoryController)
        let vc = AmityCategoryPreviewViewController(nibName: AmityCategoryPreviewViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Refreshahble
    
    func handleRefreshing() {
        screenViewModel.action.retrieveCategory()
    }
    
}

// MARK: - Action
private extension AmityCategoryPreviewViewController {
    @IBAction func seeAllTap() {
        selectedCategoriesHandler?()
    }
}

// MARK: - Setup View
private extension AmityCategoryPreviewViewController {
    
    func setupView() {        
        setupTitle()
        setupSeeAllButton()
        setupCollectionView()
    }
    
    func setupTitle() {
        titleLabel.text = AmityLocalizedStringSet.categoryTitle.localizedString
        titleLabel.textColor = AmityColorSet.base
        titleLabel.font = AmityFontSet.title
    }
    
    func setupSeeAllButton() {
        seeAllButton.setTitle("", for: .normal)
        seeAllButton.setImage(AmityIconSet.iconNext, for: .normal)
        seeAllButton.tintColor = AmityColorSet.base
    }
    
    func setupCollectionView() {
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(AmityCategoryPreviewCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}


extension AmityCategoryPreviewViewController: UICollectionViewDelegateFlowLayout {
    
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

extension AmityCategoryPreviewViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfCategory()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AmityCategoryPreviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let category = screenViewModel.dataSource.category(at: indexPath)
        cell.display(with: category)
        cell.delegate = self
        return cell
    }
}


extension AmityCategoryPreviewViewController: AmityCategoryPreviewCommunityScreenViewModelDelegate {
    func screenViewModel(_ viewModel: AmityCategoryPreviewScreenViewModelType, didRetrieveCategory category: [AmityCommunityCategoryModel], isEmpty: Bool) {
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
    
    func screenViewModel(_ viewModel: AmityCategoryPreviewScreenViewModelType, didFail error: AmityError) {
        emptyHandler?(true)
    }
}
    
// MARK: - AmityCategoryPreviewCollectionViewCellDelegate
extension AmityCategoryPreviewViewController: AmityCategoryPreviewCollectionViewCellDelegate {
    func cellDidTapOnAvatar(_ cell: AmityCategoryPreviewCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let category = screenViewModel.dataSource.category(at: indexPath)
        selectedCategoryHandler?(category)
    }
}
