//
//  EkoCommunityHomePageViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 18/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

public class EkoCommunityHomePageViewController: EkoPageViewController {
    
    // MARK: - Properties
    public let newsFeedVC = EkoNewsfeedViewController.make()
    public let exploreVC = EkoExploreViewController.make()
    
    private init() {
        super.init(nibName: EkoCommunityHomePageViewController.identifier, bundle: UpstraUIKitManager.bundle)
        title = EkoLocalizedStringSet.communityHomeTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    public static func make() -> EkoCommunityHomePageViewController {
        return EkoCommunityHomePageViewController()
    }
    
    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        newsFeedVC.pageTitle = EkoLocalizedStringSet.newsfeedTitle.localizedString
        exploreVC.pageTitle = EkoLocalizedStringSet.exploreTitle.localizedString
        return [newsFeedVC, exploreVC]
    }
    
    // MARK: - Setup view
    
    private func setupNavigationBar() {
        let searchItem = UIBarButtonItem(image: EkoIconSet.iconSearch, style: .plain, target: self, action: #selector(searchTap))
        searchItem.tintColor = EkoColorSet.base
        navigationItem.rightBarButtonItem = searchItem
    }
}

// MARK: - Action
private extension EkoCommunityHomePageViewController {
    @objc func searchTap() {
        let searchVC = EkoSearchCommunityViewController.make(for: self, searchType: .inNavigationBar)
        searchVC.showSearchBar()
    }
}

