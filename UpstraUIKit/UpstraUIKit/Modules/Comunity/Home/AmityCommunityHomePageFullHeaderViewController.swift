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
    
    // MARK: - Initializer
    
    public static func make(withUserId userId: String, settings: AmityUserProfilePageSettings = AmityUserProfilePageSettings()) -> AmityCommunityHomePageFullHeaderViewController {
        
        let viewModel: AmityCommunityHomePageFullHeaderScreenViewModelType = AmityCommunityHomePageFullHeaderScreenViewModel(userId: userId)
        
        let vc = AmityCommunityHomePageFullHeaderViewController()
        vc.header = AmityCommunityHomePageHeaderViewController.make()
        vc.bottom = AmityCommunityHomePageViewController.make()
//        vc.bottom = AmityUserProfileBottomViewController.make(withUserId: userId)
        vc.screenViewModel = viewModel
        vc.screenViewModel.action.fetchUserProfile(with: AmityUIKitManagerInternal.shared.currentUserId)
        return vc
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
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.reset()
    }
    
    override func scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
        let offset = scrollView.contentOffset.y
        
        let appPreference = AppPreferenceKey()
        appPreference.setValueDouble(AppPreferenceKey.scrollValue, value: offset)
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
