//
//  EkoExploreViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 5/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

public final class EkoExploreViewController: EkoViewController, IndicatorInfoProvider {
    
    var pageTitle: String?
    
    func indicatorInfo(for pagerTabStripController: EkoPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
    
    // MARK: - Properties
    private let refreshControl = UIRefreshControl()
    
    private let recommendedVC = EkoRecommendedCommunityViewController.make()
    private let trendingVC = EkoTrendingCommunityViewController.make()
    private let categoryVC = EkoCategoryPreviewViewController.make()
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet private var mainScrollView: UIScrollView!
    @IBOutlet var recommendedContaienrView: UIView!
    @IBOutlet var trendingContainerView: UIView!
    @IBOutlet var categoriesContainerView: UIView!
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public static func make() -> EkoExploreViewController {
        return EkoExploreViewController(nibName: EkoExploreViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
}


// MARK: - Setup View
private extension EkoExploreViewController {
    func setupView() {
        view.backgroundColor = EkoColorSet.backgroundColor
        backgroundView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        setupScrollView()
        setupRecommended()
        setupTrending()
        setupCategory()
    }
    
    private func setupScrollView() {
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        refreshControl.tintColor = EkoColorSet.base.blend(.shade3)
        mainScrollView.refreshControl = refreshControl
        mainScrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupRecommended() {
        recommendedContaienrView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        addContainerView(recommendedVC, to: recommendedContaienrView)
        
        recommendedVC.selectedCommunityHandler = { [weak self] community in
            guard let strongSelf = self else { return }
            EkoEventHandler.shared.communityDidTap(from: strongSelf, communityId: community.communityId)
        }
        
        recommendedVC.emptyDataHandler = { [weak self] status in
            self?.recommendedContaienrView.isHidden = status
            self?.backgroundView.isHidden = status
        }
    }
    
    private func setupTrending() {
        trendingContainerView.backgroundColor = EkoColorSet.backgroundColor
        addContainerView(trendingVC, to: trendingContainerView)
        
        trendingVC.selectedCommunityHandler = { [weak self] community in
            guard let strongSelf = self else { return }
            EkoEventHandler.shared.communityDidTap(from: strongSelf, communityId: community.communityId)
        }
    }
    
    private func setupCategory() {
        categoriesContainerView.backgroundColor = EkoColorSet.backgroundColor
        addContainerView(categoryVC, to: categoriesContainerView)
        
        categoryVC.selectedCategoryHandler = { [weak self] category in
            let vc = EkoCategoryCommunityListViewController.make(categoryId: category.categoryId)
            vc.title = category.name
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        categoryVC.selectedCategoriesHandler = { [weak self] in
            let categoryVC = EkoCategoryListViewController.make()
            self?.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
    
    @objc private func handleRefreshControl() {
        recommendedVC.handleRefreshing()
        trendingVC.handleRefreshing()
        categoryVC.handleRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
}
