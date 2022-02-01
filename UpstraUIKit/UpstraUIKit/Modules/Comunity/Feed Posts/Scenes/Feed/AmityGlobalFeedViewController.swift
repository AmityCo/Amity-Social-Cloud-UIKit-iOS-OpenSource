//
//  AmityGlobalFeedViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

/// A view controller for providing global post feed which consist of community feed and my own feed..
public class AmityGlobalFeedViewController: AmityViewController {
    
    private let feedViewController: AmityFeedViewController
    private let createPostButton: AmityFloatingButton = AmityFloatingButton()
    
    private var screenViewModel: AmityNewsFeedScreenViewModelType? = nil
    private var permissionCanLive: Bool = false
    
    // MARK: - Initializer
    
    private init() {
        feedViewController = AmityFeedViewController.make(feedType: .globalFeed)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make() -> AmityGlobalFeedViewController {
        return AmityGlobalFeedViewController()
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenViewModel()
        setupFeedView()
        setupPostButton()
    }
    
    // MARK: - Private functions
    
    private func setupFeedView() {
        addChild(viewController: feedViewController)
    }
    
    private func setupScreenViewModel() {
        screenViewModel = AmityNewsFeedScreenViewModel()
        screenViewModel?.delegate = self
        fetchUserProfile()
    }
    
    private func setupPostButton() {
        createPostButton.image = AmityIconSet.iconCreatePost
        createPostButton.add(to: view, position: .bottomRight)
        createPostButton.actionHandler = { [weak self] button in
            guard let strongSelf = self else { return }
            AmityEventHandler.shared.createPostBeingPrepared(from: strongSelf,liveStreamPermission: self?.permissionCanLive ?? false)
//            let vc = AmityPostTargetPickerViewController.make()
//            let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .overFullScreen
//            strongSelf.present(nav, animated: true, completion: nil)
        }
    }
    
}


// MARK: - Action
extension AmityGlobalFeedViewController {
    
    func fetchUserProfile() {
        screenViewModel?.fetchUserProfile(with: AmityUIKitManagerInternal.shared.currentUserId)
    }
    
}
// MARK: - Delegate
extension AmityGlobalFeedViewController: AmityNewsFeedScreenViewModelDelegate {
    
    func didFetchUserProfile(user: AmityUser) {
        switch AmityUIKitManagerInternal.shared.envByApiKey {
        case .staging:
            user.roles.filter{ $0 == AmityUIKitManagerInternal.shared.stagingLiveRoleID}.count > 0 ? (permissionCanLive = true) : (permissionCanLive = false)
        case .production:
            user.roles.filter{ $0 == AmityUIKitManagerInternal.shared.productionLiveRoleID}.count > 0 ? (permissionCanLive = true) : (permissionCanLive = false)
        }
    }
    
}

