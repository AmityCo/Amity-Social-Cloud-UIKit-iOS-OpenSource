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
    
    private enum UserDefaultsKey {
        static let userId = "userId"
        static let userIds = "userIds"
        static let deviceToken = "deviceToken"
    }
    
    // MARK: - Properties
    public let newsFeedVC = AmityNewsfeedViewController.make()
    public let exploreVC = AmityCommunityExplorerViewController.make()
//    public let discoveryVC = AmityDiscoveryViewController.makeByTrueID(targetType: .community, targetId: "56701fa0443c1e92b43d89961fdc0cd4", isHiddenButtonCreate: true)
    public let discoveryVC = AmityDiscoveryViewController.makeByTrueID(targetType: .community, targetId: "875fd7b78a63bba3d5b0ec828dce6149", isHiddenButtonCreate: true)
    
    private var screenViewModel: AmityCommunityHomePageScreenViewModelType
    private var initialized: Bool = false
    private var deeplinkFinished: Bool = false
    
    private var isPresent: Bool = false
    
    private var leftBarButtonItem: UIBarButtonItem?
    
    private init(amityCommunityEventType: AmityCommunityEventTypeModel? = nil) {
        screenViewModel = AmityCommunityHomePageScreenViewModel(amityCommunityEventTypeModel: amityCommunityEventType)
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
   
    public static func make(amityCommunityEventType: AmityCommunityEventTypeModel? = nil) -> AmityCommunityHomePageViewController {
        return AmityCommunityHomePageViewController(amityCommunityEventType: amityCommunityEventType)
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        newsFeedVC.pageTitle = AmityLocalizedStringSet.newsfeedTitle.localizedString
        exploreVC.pageTitle = AmityLocalizedStringSet.exploreTitle.localizedString
        discoveryVC.pageTitle = AmityLocalizedStringSet.discoveryTitle.localizedString
        return [newsFeedVC, exploreVC, discoveryVC]
    }
    
    // MARK: - Setup view
    
    private func setupNavigationBar() {
        
        let searchItem = UIBarButtonItem(image: AmityIconSet.iconSearch, style: .plain, target: self, action: #selector(searchTap))
        searchItem.tintColor = AmityColorSet.base
        
//        let chatItem = UIBarButtonItem(image: AmityIconSet.iconChatInCommunity, style: .plain, target: self, action: #selector(chatTap))
//        chatItem.tintColor = AmityColorSet.base
        
        let chatIconView = UIButton(type: .custom)
        chatIconView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        chatIconView.setBackgroundImage(AmityIconSet.iconChatInCommunity, for: .normal)
        chatIconView.contentMode = .scaleAspectFit
//        chatIconView.setImage(AmityIconSet.iconChatInCommunity, for: .normal)
//        chatIconView.imageView?.contentMode = .scaleAspectFit
        chatIconView.addTarget(self, action: #selector(chatTap), for: .touchUpInside)
        let chatItem = UIBarButtonItem(customView: chatIconView)
        
//        let _ = chatItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        let _ = chatItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        navigationItem.rightBarButtonItems = [searchItem, chatItem]
        
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
    
    @objc func chatTap() {
        let chatVC = AmityRecentChatViewController.make(channelType: .community)
        chatVC.modalPresentationStyle = .fullScreen
        chatVC.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(chatVC, animated: true)
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
        
        if screenViewModel.dataSource.amityCommunityEventTypeModel != nil {
            deeplinkFinished = true
            switch screenViewModel.dataSource.amityCommunityEventTypeModel?.openType {
            case .post:
                if screenViewModel.dataSource.amityCommunityEventTypeModel?.communityID != "" && screenViewModel.dataSource.amityCommunityEventTypeModel?.communityID != nil {
                    let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: screenViewModel.dataSource.amityCommunityEventTypeModel?.communityID ?? "", postId: screenViewModel.dataSource.amityCommunityEventTypeModel?.postID, fromDeeplinks: true)
                    navigationController?.pushViewController(viewController, animated: true)
                } else {
                    let postVC = AmityPostDetailViewController.make(withPostId: screenViewModel.dataSource.amityCommunityEventTypeModel?.postID ?? "")
                    navigationController?.pushViewController(postVC, animated: true)
                }
            case .community:
                guard let communityID = screenViewModel.dataSource.amityCommunityEventTypeModel?.communityID else { return }
                let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: communityID)
                navigationController?.pushViewController(viewController, animated: true)
            case .category:
                guard let categoryID = screenViewModel.dataSource.amityCommunityEventTypeModel?.categoryID else { return }
                let viewController = AmityCategoryCommunityListViewController.make(categoryId: categoryID)
                navigationController?.pushViewController(viewController, animated: true)
            default :
                return
            }
        } else {
            deeplinkFinished = true
            return
        }
    }
}

