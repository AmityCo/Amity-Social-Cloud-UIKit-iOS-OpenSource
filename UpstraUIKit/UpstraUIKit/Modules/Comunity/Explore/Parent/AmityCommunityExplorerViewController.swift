//
//  AmityExploreViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 5/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public final class AmityCommunityExplorerViewController: AmityViewController, IndicatorInfoProvider {
    
    var pageTitle: String?
    
    func indicatorInfo(for pagerTabStripController: AmityPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
    
    // MARK: - Properties
    private let refreshControl = UIRefreshControl()
    
    private let recommendedVC = AmityRecommendedCommunityViewController.make()
    private let trendingVC = AmityTrendingCommunityViewController.make()
    private let categoryVC = AmityCategoryPreviewViewController.make()
    
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var mainScrollView: UIScrollView!
    @IBOutlet private var recommendedContaienrView: UIView!
    @IBOutlet private var trendingContainerView: UIView!
    @IBOutlet private var categoriesContainerView: UIView!
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    public static func make() -> AmityCommunityExplorerViewController {
        return AmityCommunityExplorerViewController(nibName: AmityCommunityExplorerViewController.identifier, bundle: AmityUIKitManager.bundle)
    }
}


// MARK: - Setup View
private extension AmityCommunityExplorerViewController {
    func setupView() {
        view.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        backgroundView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        setupScrollView()
        setupRecommended()
        setupTrending()
        setupCategory()
    }
    
    private func setupScrollView() {
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        refreshControl.tintColor = AmityColorSet.base.blend(.shade3)
        mainScrollView.refreshControl = refreshControl
        mainScrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupRecommended() {
        recommendedContaienrView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        addContainerView(recommendedVC, to: recommendedContaienrView)
        
        recommendedVC.selectedCommunityHandler = { [weak self] community in
            guard let strongSelf = self else { return }
            AmityEventHandler.shared.communityDidTap(from: strongSelf, communityId: community.communityId)
        }

        recommendedVC.emptyHandler = { [weak self] isEmpty in
            self?.recommendedContaienrView.isHidden = isEmpty
            self?.backgroundView.isHidden = isEmpty
        }
    }
    
    private func setupTrending() {
        trendingContainerView.backgroundColor = AmityColorSet.backgroundColor
        addContainerView(trendingVC, to: trendingContainerView)
        
        trendingVC.selectedCommunityHandler = { [weak self] community in
            guard let strongSelf = self else { return }
            AmityEventHandler.shared.communityDidTap(from: strongSelf, communityId: community.communityId)
        }
        
        trendingVC.emptyHandler = { [weak self] isEmpty in
            self?.trendingContainerView.isHidden = isEmpty
        }
    }
    
    private func setupCategory() {
        categoriesContainerView.backgroundColor = AmityColorSet.backgroundColor
        addContainerView(categoryVC, to: categoriesContainerView)
        
        categoryVC.selectedCategoryHandler = { [weak self] category in
            let vc = AmityCategoryCommunityListViewController.make(categoryId: category.categoryId)
            vc.title = category.name
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        categoryVC.selectedCategoriesHandler = { [weak self] in
            let categoryVC = AmityCategoryListViewController.make()
            self?.navigationController?.pushViewController(categoryVC, animated: true)
        }
        
        categoryVC.emptyHandler = { [weak self] isEmpty in
            self?.categoriesContainerView.isHidden = isEmpty
        }
    }
    
    @objc private func reloadData() {
        recommendedVC.handleRefreshing()
        trendingVC.handleRefreshing()
        categoryVC.handleRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
}
