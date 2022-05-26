//
//  AmityCommunityHomePageFullHeaderViewController.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 11/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

public class AmityCommunityHomePageFullHeaderViewController: AmityProfileViewController, UIScrollViewDelegate {

    // MARK: - Properties
    
    private var settings: AmityUserProfilePageSettings!
    private var header: AmityCommunityHomePageHeaderViewController!
    private var bottom: AmityCommunityHomePageViewController!
//    private var bottom: AmityUserProfileBottomViewController!
    private let postButton: AmityFloatingButton = AmityFloatingButton()
    private var screenViewModel: AmityCommunityHomePageFullHeaderScreenViewModelType!
    private var permissionCanLive: Bool = false
    private var deeplinkFinished: Bool = false
    
    // MARK: - Initializer
    
    public static func make(amityCommunityEventType: AmityCommunityEventTypeModel? = nil) -> AmityCommunityHomePageFullHeaderViewController {
        
        let viewModel: AmityCommunityHomePageFullHeaderScreenViewModelType = AmityCommunityHomePageFullHeaderScreenViewModel(amityCommunityEventTypeModel: amityCommunityEventType)
        
        let vc = AmityCommunityHomePageFullHeaderViewController()
        vc.header = AmityCommunityHomePageHeaderViewController.make()
        vc.bottom = AmityCommunityHomePageViewController.make()
//        vc.bottom = AmityUserProfileBottomViewController.make(withUserId: userId)
        vc.screenViewModel = viewModel
        vc.screenViewModel.action.fetchUserProfile(with: AmityUIKitManagerInternal.shared.currentUserId)
        return vc
    }
    
    public static func navigateTo(amityCommunityEventType: AmityCommunityEventTypeModel? = nil) {
        let viewModel: AmityCommunityHomePageFullHeaderScreenViewModelType = AmityCommunityHomePageFullHeaderScreenViewModel(amityCommunityEventTypeModel: amityCommunityEventType)
        
        let vc = AmityCommunityHomePageFullHeaderViewController()
        vc.screenViewModel = viewModel
        vc.screenViewModel.action.fetchUserProfile(with: AmityUIKitManagerInternal.shared.currentUserId)
        vc.runDeeplinksRouter()
        
        debugPrint("EventType: \(amityCommunityEventType)")
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationItem()
        setupViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setBackgroundColor(with: .white)
        runDeeplinksRouter()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.reset()
        screenViewModel = nil
    }
        
    override func scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
        AmityEventHandler.shared.homeCommunityDidScroll(scrollView)
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        postButton.image = AmityIconSet.iconCreatePost
        postButton.add(to: view, position: .bottomRight)
        postButton.actionHandler = { [weak self] _ in
            guard let strongSelf = self else { return }
            AmityEventHandler.shared.createPostBeingPrepared(from: strongSelf, liveStreamPermission: strongSelf.permissionCanLive)
        }
        postButton.isHidden = !screenViewModel.isCurrentUser
    }
    
    private func setupNavigationItem() {
        let item = UIBarButtonItem(image: AmityIconSet.iconOption, style: .plain, target: self, action: #selector(optionTap))
        item.tintColor = AmityColorSet.base
        navigationItem.rightBarButtonItem = item
    }
    
    private func setupViewModel() {
        screenViewModel.delegate = self
    }
    
    // MARK: - AmityProfileDataSource
    override func headerViewController() -> UIViewController {
        return header
    }
    
    override func bottomViewController() -> UIViewController & AmityProfilePagerAwareProtocol {
        return bottom
    }
    
    override func minHeaderHeight() -> CGFloat {
        return topInset
    }
}

private extension AmityCommunityHomePageFullHeaderViewController {
    @objc func optionTap() {
        let vc = AmityUserSettingsViewController.make(withUserId: screenViewModel.dataSource.userId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AmityCommunityHomePageFullHeaderViewController: AmityCommunityHomePageFullHeaderScreenViewModelDelegate {
    func screenViewModel(_ viewModel: AmityCommunityHomePageFullHeaderScreenViewModelType, failure error: AmityError) {
        switch error {
        case .unknown:
            AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
        default:
            break
        }
    }
}

// MARK: - Action

private extension AmityCommunityHomePageFullHeaderViewController {
   
    func runDeeplinksRouter() {
        if deeplinkFinished { return }
        
        debugPrint(navigationController?.topViewController)
        
        navigationController?.visibleViewController?.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
                
        if screenViewModel.dataSource.amityCommunityEventTypeModel != nil {
            deeplinkFinished = true
            switch screenViewModel.dataSource.amityCommunityEventTypeModel?.openType {
            case .post:
                if screenViewModel.dataSource.amityCommunityEventTypeModel?.communityID != "" && screenViewModel.dataSource.amityCommunityEventTypeModel?.communityID != nil {
                    let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: screenViewModel.dataSource.amityCommunityEventTypeModel?.communityID ?? "", postId: screenViewModel.dataSource.amityCommunityEventTypeModel?.postID ?? "", fromDeeplinks: true)
                    debugPrint("EventType: \(screenViewModel.dataSource.amityCommunityEventTypeModel)")
                    navigationController?.pushViewController(viewController, animated: true)
                } else {
                    let postVC = AmityPostDetailViewController.make(withPostId: screenViewModel.dataSource.amityCommunityEventTypeModel?.postID ?? "")
                    debugPrint("EventType: \(screenViewModel.dataSource.amityCommunityEventTypeModel)")
                    navigationController?.pushViewController(postVC, animated: true)
                }
            case .community:
                debugPrint("EventType: \(screenViewModel.dataSource.amityCommunityEventTypeModel)")
                guard let communityID = screenViewModel.dataSource.amityCommunityEventTypeModel?.communityID else { return }
                let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: communityID)
                navigationController?.pushViewController(viewController, animated: true)
            case .category:
                debugPrint("EventType: \(screenViewModel.dataSource.amityCommunityEventTypeModel)")
                guard let categoryID = screenViewModel.dataSource.amityCommunityEventTypeModel?.categoryID else { return }
                let viewController = AmityCategoryCommunityListViewController.make(categoryId: categoryID)
                navigationController?.pushViewController(viewController, animated: true)
            case .chat:
                debugPrint("EventType: \(screenViewModel.dataSource.amityCommunityEventTypeModel)")
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

// MARK: - Delegate
extension AmityCommunityHomePageFullHeaderViewController: AmityNewsFeedScreenViewModelDelegate {
    
    func didFetchUserProfile(user: AmityUser) {
        switch AmityUIKitManagerInternal.shared.envByApiKey {
        case .staging:
            let summaryRoles = user.roles + AmityUIKitManagerInternal.shared.stagingLiveRoleID
            Array(Dictionary(grouping: summaryRoles, by: {$0}).filter { $1.count > 1 }.keys).count > 0 ? (permissionCanLive = true) : (permissionCanLive = false)
        case .production:
            let summaryRoles = user.roles + AmityUIKitManagerInternal.shared.productionLiveRoleID
            Array(Dictionary(grouping: summaryRoles, by: {$0}).filter { $1.count > 1 }.keys).count > 0 ? (permissionCanLive = true) : (permissionCanLive = false)
        }
    }
    
}
