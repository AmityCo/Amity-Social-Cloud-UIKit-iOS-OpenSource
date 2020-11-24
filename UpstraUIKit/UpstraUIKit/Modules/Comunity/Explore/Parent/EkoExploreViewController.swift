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
    
    // MARK: - IBOutlet Properties
    @IBOutlet var backgroundView: UIView!
    @IBOutlet private var mainScrollView: UIScrollView!
    @IBOutlet var recommendedContaienrView: UIView!
    @IBOutlet var trendingContainerView: UIView!
    @IBOutlet var categoriesContainerView: UIView!
    
    // MARK: - View lifecycle
    private init() {
        super.init(nibName: EkoExploreViewController.identifier, bundle: UpstraUIKit.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public static func make() -> EkoExploreViewController {
        return EkoExploreViewController()
    }
}


// MARK: - Setup View
private extension EkoExploreViewController {
    func setupView() {
        view.backgroundColor = EkoColorSet.backgroundColor
        backgroundView.backgroundColor = EkoColorSet.base.blend(.shade4)
        setupScrollView()
        setupRecommended()
        setupTrending()
        setupCategory()
    }
    
    func setupScrollView() {
        mainScrollView.showsVerticalScrollIndicator = false
    }
    
    func setupRecommended() {
        recommendedContaienrView.backgroundColor = EkoColorSet.base.blend(.shade4)
        let recommendedVC = EkoRecommendedCommunityViewController.make()
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
    
    func setupTrending() {
        trendingContainerView.backgroundColor = EkoColorSet.backgroundColor
        let trendingVC = EkoTrendingCommunityViewController.make()
        addContainerView(trendingVC, to: trendingContainerView)
        
        trendingVC.selectedCommunityHandler = { [weak self] community in
            guard let strongSelf = self else { return }
            EkoEventHandler.shared.communityDidTap(from: strongSelf, communityId: community.communityId)
        }
    }
    
    func setupCategory() {
        categoriesContainerView.backgroundColor = EkoColorSet.backgroundColor
        let categoryVC = EkoCategoryPreviewViewController.make()
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
}
