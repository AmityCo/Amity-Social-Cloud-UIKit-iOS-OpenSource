//
//  AmityCommunityHomePageViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 18/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public class AmityCommunityHomePageViewController: AmityPageViewController {
    
    // MARK: - Properties
    public let newsFeedVC = AmityNewsfeedViewController.make()
    public let exploreVC = AmityCommunityExplorerViewController.make()
    
    private var screenViewModel: AmityCommunityHomePageScreenViewModelType
    private var initialized: Bool = false
    private var deeplinkFinished: Bool = false
    
    private var isPresent: Bool = false
    
    private var leftBarButtonItem: UIBarButtonItem?
    
    private init(deeplinksType: DeeplinksType?, fromDeeplinks: Bool) {
        screenViewModel = AmityCommunityHomePageScreenViewModel(deeplinksType: deeplinksType, fromDeeplinks: fromDeeplinks)
        super.init(nibName: AmityCommunityHomePageViewController.identifier, bundle: AmityUIKitManager.bundle)
        title = AmityLocalizedStringSet.communityHomeTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
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
   
    public static func make(deeplinksType: DeeplinksType? = nil, fromDeeplinks: Bool = false) -> AmityCommunityHomePageViewController {
        return AmityCommunityHomePageViewController(deeplinksType: deeplinksType, fromDeeplinks: fromDeeplinks)
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
    func checkEkoConnection() {
//        if UpstraUIKitManagerInternal.shared.client.currentUser?.object?.userId == nil {
//            let message = EkoLocalizedStringSet.errorMessageConnectionError.localizedString
//            EkoUtilities.showAlert(with: "", message: message, viewController: self) { [weak self] _ in
//                self?.dismiss(animated: true, completion: nil)
//            }
//        }
    }

    // Waiting for the best solution to popup user is banned
    func checkUserIsBannned() {
        // If user is banned, userId will be nil
//        if UpstraUIKitManagerInternal.shared.client.currentUser?.object?.userId == nil {
//            let message = EkoLocalizedStringSet.errorMessageUserIsBanned.localizedString
//            EkoUtilities.showAlert(with: "", message: message, viewController: self) { [weak self] _ in
//                self?.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    func fetchCommunities() {
//        if initialized { return }
//
//        screenViewModel.fetchCommunities()
    }
    
    func fetchProfileImage() {
//        screenViewModel.fetchProfileImage(with: UpstraUIKitManagerInternal.shared.client.currentUser?.object?.userId ?? "")
    }
    
    func fetchCategories() {
        screenViewModel.fetchCategories()
    }
    
    func setCurrentPage() {
//        if initialized { return }
//
//        let page = screenViewModel.dataSource.baseOnJoinPage
//        setCurrentIndex(page.rawValue)
    }
    
    func runDeeplinksRouter() {
        if deeplinkFinished { return }
        
        if !screenViewModel.dataSource.fromDeeplinks { return }
        
        guard let deeplinksType = screenViewModel.dataSource.deeplinksType else { return }
        
        deeplinkFinished = true
        
        switch deeplinksType {
        case .community(let id):
            let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: id)
            navigationController?.pushViewController(viewController, animated: true)
        case .post(let id, let communityId):
            let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: communityId, postId: id, fromDeeplinks: screenViewModel.dataSource.fromDeeplinks)
            navigationController?.pushViewController(viewController, animated: true)
        break
        case .category(let id):
            if let item = screenViewModel.getCategoryItemBy(categoryId: id) {
                let viewController = AmityCategoryCommunityListViewController.make(categoryId: item.categoryId)
                viewController.title = item.name
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

