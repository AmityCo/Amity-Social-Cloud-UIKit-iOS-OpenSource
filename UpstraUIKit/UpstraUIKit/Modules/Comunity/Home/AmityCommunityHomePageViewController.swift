//
//  AmityCommunityHomePageViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 18/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public class AmityCommunityHomePageViewController: AmityPageViewController {
    
    // MARK: - Properties
    public let newsFeedVC = AmityNewsfeedViewController.make()
    public let exploreVC = AmityCommunityExplorerViewController.make()
    
    private var screenViewModel: AmityCommunityHomePageScreenViewModelType
    private var initialized: Bool = false
    private var deeplinkFinished: Bool = false
    
    private var isPresent: Bool = false
    
    private var leftBarButtonItem: UIBarButtonItem?
    
    private init(deeplinksType: DeeplinksType?, fromDeeplinks: Bool, amityDeepLink: AmityDeepLink? = nil) {
        screenViewModel = AmityCommunityHomePageScreenViewModel(deeplinksType: deeplinksType, fromDeeplinks: fromDeeplinks, amityDeepLink: amityDeepLink)
        super.init(nibName: AmityCommunityHomePageViewController.identifier, bundle: AmityUIKitManager.bundle)
        title = AmityLocalizedStringSet.communityHomeTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        reloadNavigationObject()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runDeeplinksRouter()
    }
   
    public static func make(deeplinksType: DeeplinksType? = nil, fromDeeplinks: Bool = false, amityDeepLink: AmityDeepLink? = nil) -> AmityCommunityHomePageViewController {
        return AmityCommunityHomePageViewController(deeplinksType: deeplinksType, fromDeeplinks: fromDeeplinks,amityDeepLink: amityDeepLink)
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        newsFeedVC.pageTitle = AmityLocalizedStringSet.newsfeedTitle.localizedString
        exploreVC.pageTitle = AmityLocalizedStringSet.exploreTitle.localizedString
        return [newsFeedVC, exploreVC]
    }
    
    // MARK: - Setup view
    
    private func setupNavigationBar() {
        
        let searchItem = UIBarButtonItem(image: AmityIconSet.iconSearch, style: .plain, target: self, action: #selector(searchTap))
        searchItem.tintColor = AmityColorSet.base
        navigationItem.rightBarButtonItem = searchItem
        
        if navigationController?.viewControllers.count ?? 0 <= 1 {
            if presentingViewController != nil {
                leftBarButtonItem = UIBarButtonItem(image: AmityIconSet.iconClose, style: .plain, target: self, action: #selector(dismissView))
                leftBarButtonItem?.tintColor = AmityColorSet.base
                navigationItem.leftBarButtonItem = leftBarButtonItem
                isPresent = true
            }
        } else {
            leftBarButtonItem = UIBarButtonItem(image: AmityIconSet.iconBack, style: .plain, target: self, action: #selector(popToView))
            leftBarButtonItem?.tintColor = AmityColorSet.base
            navigationItem.leftBarButtonItem = leftBarButtonItem
            isPresent = false
        }
        
    }
    
    private func reloadNavigationObject() {
        if isPresent {
            leftBarButtonItem = UIBarButtonItem(image: AmityIconSet.iconClose, style: .plain, target: self, action: #selector(dismissView))
            leftBarButtonItem?.tintColor = AmityColorSet.base
            navigationItem.leftBarButtonItem = leftBarButtonItem
        } else {
            leftBarButtonItem = UIBarButtonItem(image: AmityIconSet.iconBack, style: .plain, target: self, action: #selector(popToView))
            leftBarButtonItem?.tintColor = AmityColorSet.base
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
    }
}

// MARK: - Action
private extension AmityCommunityHomePageViewController {
    @objc func searchTap() {
        AmityEventHandler.shared.communityTopbarSearchTracking()
        let searchVC = AmitySearchViewController.make()
        let nav = UINavigationController(rootViewController: searchVC)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true, completion: nil)
    }
    
    @objc func popToView() {
        AmityEventHandler.shared.closeAmityCommunityViewController()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissView() {
        AmityEventHandler.shared.closeAmityCommunityViewController()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Action
private extension AmityCommunityHomePageViewController {
   
    func runDeeplinksRouter() {
        if deeplinkFinished { return }
        
        if !screenViewModel.dataSource.fromDeeplinks { return }
        
        if screenViewModel.dataSource.amityDeepLink != nil {
            deeplinkFinished = true
            switch screenViewModel.dataSource.amityDeepLink?.deepLinkType {
            case .post:
                if screenViewModel.dataSource.amityDeepLink?.communityID != "" && screenViewModel.dataSource.amityDeepLink?.communityID != nil {
                    let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: screenViewModel.dataSource.amityDeepLink?.communityID ?? "", postId: screenViewModel.dataSource.amityDeepLink?.postID, fromDeeplinks: screenViewModel.dataSource.fromDeeplinks)
                    navigationController?.pushViewController(viewController, animated: true)
                } else {
                    let postVC = AmityPostDetailViewController.make(withPostId: screenViewModel.dataSource.amityDeepLink?.postID ?? "")
                    navigationController?.pushViewController(postVC, animated: true)
                }
            case .community:
                guard let communityID = screenViewModel.dataSource.amityDeepLink?.communityID else { return }
                let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: communityID)
                navigationController?.pushViewController(viewController, animated: true)
            case .category:
                guard let categoryID = screenViewModel.dataSource.amityDeepLink?.categoryID else { return }
                let viewController = AmityCategoryCommunityListViewController.make(categoryId: categoryID)
                navigationController?.pushViewController(viewController, animated: true)
            default :
                return
            }
        } else {
            guard let deeplinksType = screenViewModel.dataSource.deeplinksType else { return }
            
            deeplinkFinished = true
            
            switch deeplinksType {
            case .community(let id):
                let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: id)
                navigationController?.pushViewController(viewController, animated: true)
            case .post(let id, let communityId):
                if communityId != "" {
                    let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: communityId, postId: id, fromDeeplinks: screenViewModel.dataSource.fromDeeplinks)
                    navigationController?.pushViewController(viewController, animated: true)
                } else {
                    let postVC = AmityPostDetailViewController.make(withPostId: id)
                    navigationController?.pushViewController(postVC, animated: true)
                }
                break
            case .category(let id):
                let viewController = AmityCategoryCommunityListViewController.make(categoryId: id)
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

