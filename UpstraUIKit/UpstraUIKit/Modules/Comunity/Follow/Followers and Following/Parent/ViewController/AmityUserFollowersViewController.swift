//
//  AmityUserFollowersViewController.swift
//  AmityUIKit
//
//  Created by Hamlet on 10.06.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

/// A view controller for providing followers and following list.
public final class AmityUserFollowersViewController: AmityPageViewController {
    
    // MARK: - Child ViewController
    private var followersVC: AmityFollowersListViewController?
    private var followingVC: AmityFollowersListViewController?
    
    // MARK: - Properties
    private var userId: String?
    private var selectedControllerType: AmityFollowerViewType?
    private var screenViewModel: AmityUserFollowersScreenViewModelType!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
    }

    public static func make(withUserId userId: String, isFollowersSelected: Bool = false) -> AmityUserFollowersViewController {
        let vc = AmityUserFollowersViewController(nibName: AmityUserFollowersViewController.identifier,
                                                          bundle: AmityUIKitManager.bundle)
        let viewModel: AmityUserFollowersScreenViewModelType = AmityUserFollowersScreenViewModel(userId: userId)
        
        vc.userId = userId
        vc.screenViewModel = viewModel
        vc.selectedControllerType = isFollowersSelected ? .followers : nil
        
        vc.followersVC = AmityFollowersListViewController.make(pageTitle: AmityLocalizedStringSet.Follow.followers.localizedString, type: .followers, userId: userId)
        vc.followingVC = AmityFollowersListViewController.make(pageTitle: AmityLocalizedStringSet.Follow.following.localizedString, type: .following, userId: userId)
        
        return vc
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let type = selectedControllerType, type == .followers, let vc = followersVC {
            setSelected(viewController: vc)
            selectedControllerType = nil
        }
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        guard let followingVC = followingVC, let followersVC = followersVC else {
            return []
        }
        return [followingVC, followersVC]
    }
}

private extension AmityUserFollowersViewController {
    func setSelected(viewController: UIViewController) {
        guard let indexOfViewController = viewControllers.firstIndex(of: viewController) else { return }
        setCurrentIndex(indexOfViewController)
    }
    
    func setupViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.getUser()
    }
}

extension AmityUserFollowersViewController: AmityUserFollowersScreenViewModelDelegate {
    func screenViewModel(_ viewModel: AmityUserFollowersScreenViewModelType, failure error: AmityError) {
        
    }
    
    func screenViewModel(_ viewModel: AmityUserFollowersScreenViewModelType, didGetUser user: AmityUserModel) {
        title = user.displayName
    }
}
