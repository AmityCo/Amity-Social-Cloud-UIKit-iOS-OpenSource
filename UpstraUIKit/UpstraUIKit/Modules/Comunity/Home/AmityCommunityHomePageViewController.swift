//
//  AmityCommunityHomePageViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 18/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK


public class AmityCommunityHomePageViewController: AmityProfileBottomViewController {
    
    private enum UserDefaultsKey {
        static let userId = "userId"
        static let userIds = "userIds"
        static let deviceToken = "deviceToken"
    }
    
    // MARK: - Properties
    public let newsFeedVC = AmityFeedViewController.make(feedType: .customPostRankingGlobalFeed)
    public let newfeedHeader = AmityMyCommunityPreviewViewController.make()
    public let exploreVC = AmityCommunityExplorerViewController.make()
    public let discoveryVC = AmityDiscoveryViewController.makeByTrueIDWithoutTargetId(targetType: .community, isHiddenButtonCreate: true)
    
    private var screenViewModel: AmityCommunityHomePageScreenViewModelType
    private var initialized: Bool = false
    private var deeplinkFinished: Bool = false
    
    private var isPresent: Bool = false
    
    private var leftBarButtonItem: UIBarButtonItem?
    private var chatIconView: UIButton!
    private var badgeView: AmityBadgeView!
    
    private init(amityCommunityEventType: AmityCommunityEventTypeModel? = nil) {
        screenViewModel = AmityCommunityHomePageScreenViewModel(amityCommunityEventTypeModel: amityCommunityEventType)
//        super.init(nibName: AmityCommunityHomePageViewController.identifier, bundle: AmityUIKitManager.bundle)
        super.init()
        screenViewModel.delegate = self
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
        getChatBadge()
    }
   
    public static func make(amityCommunityEventType: AmityCommunityEventTypeModel? = nil) -> AmityCommunityHomePageViewController {
        return AmityCommunityHomePageViewController(amityCommunityEventType: amityCommunityEventType)
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        newsFeedVC.pageTitle = AmityLocalizedStringSet.newsfeedTitle.localizedString
        newfeedHeader.retrieveCommunityList()
        newsFeedVC.headerView = newfeedHeader
        
        newfeedHeader.delegate = self
        
        exploreVC.pageTitle = AmityLocalizedStringSet.exploreTitle.localizedString
        
        discoveryVC.pageTitle = AmityLocalizedStringSet.discoveryTitle.localizedString
                
        return [newsFeedVC, exploreVC, discoveryVC]
    }
    
    // MARK: - Setup view
    
    private func setupNavigationBar() {
        
        let searchItem = UIBarButtonItem(image: AmityIconSet.iconSearch, style: .plain, target: self, action: #selector(searchTap))
        searchItem.tintColor = AmityColorSet.base
        
        badgeView = AmityBadgeView()
        chatIconView = UIButton(type: .custom)
        chatIconView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        chatIconView.setBackgroundImage(AmityIconSet.iconChatInCommunity, for: .normal)
        chatIconView.contentMode = .scaleAspectFit
        chatIconView.addTarget(self, action: #selector(chatTap), for: .touchUpInside)
        let chatItem = UIBarButtonItem(customView: chatIconView)
        
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
        let chatVC = AmityRecentChatViewController.make(channelType: .conversation)
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
            case .chat:
                guard let channelID = screenViewModel.dataSource.amityCommunityEventTypeModel?.channelID else { return }
                let viewController = AmityRecentChatViewController.make(channelID: channelID)
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

private extension AmityCommunityHomePageViewController {
    func getChatBadge() {
        screenViewModel.getChatBadge()
    }
}

extension AmityCommunityHomePageViewController: AmityCommunityHomePageScreenViewModelDelegate {
    func screenViewModelDidGetChatBadge(_ badge: Int) {
        if badge != 0 {
            badgeView?.badge = badge
            badgeView.isUserInteractionEnabled = false
            badgeView.frame = CGRect(x: 14, y: -10, width: badgeView.badge > 9 ? 30 : 20, height: 20)
            chatIconView.addSubview(badgeView)
        }else {
            if badgeView != nil {
                badgeView.removeFromSuperview()
            }
        }
    }
}

extension AmityCommunityHomePageViewController: AmityMyCommunityPreviewViewControllerDelegate {

    public func viewController(_ viewController: AmityMyCommunityPreviewViewController, didPerformAction action: AmityMyCommunityPreviewViewController.ActionType) {
        switch action {
        case .seeAll:
            AmityEventHandler.shared.communityMyCommunitySectionTracking()
            let vc = AmityMyCommunityViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .communityItem(let communityId):
            AmityEventHandler.shared.communityDidTap(from: self, communityId: communityId)
        }
    }

    public func viewController(_ viewController: AmityMyCommunityPreviewViewController, shouldShowMyCommunityPreview: Bool) {
        if shouldShowMyCommunityPreview {
            newsFeedVC.headerView = newfeedHeader
        } else {
            newsFeedVC.headerView = nil
        }
    }
}
