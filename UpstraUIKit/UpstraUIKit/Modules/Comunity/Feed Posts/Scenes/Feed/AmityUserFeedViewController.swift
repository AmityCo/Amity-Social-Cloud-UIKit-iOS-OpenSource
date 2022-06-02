//
//  AmityUserFeedViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 9/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

/// A view controller for providing specific user post feed.
public class AmityUserFeedViewController: AmityViewController {
    
    private let feedViewController: AmityFeedViewController
    private let createPostButton: AmityFloatingButton = AmityFloatingButton()
    private let feedType: AmityPostFeedType
    private var screenViewModel: AmityNewsFeedScreenViewModelType? = nil
    
    private var openByProfileTrueID: Bool = false
    private var permissionCanLive: Bool = false
    
    // MARK: - Initializer
    
    init(feedType: AmityPostFeedType, openByProfileTrueID: Bool) {
        self.feedType = feedType
        self.openByProfileTrueID = openByProfileTrueID
        feedViewController = AmityFeedViewController.make(feedType: feedType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, deprecated, message: "`AmityUserFeedViewController.makeMyFeed()` method is deprecated. Please calls `AmityMyFeedViewController.make()` instead.")
    public static func makeMyFeed() -> AmityUserFeedViewController {
        return AmityUserFeedViewController(feedType: .myFeed, openByProfileTrueID: false)
    }
    
    public static func makeUserFeed(withUserId userId: String) -> AmityUserFeedViewController {
        return AmityUserFeedViewController(feedType: .userFeed(userId: userId), openByProfileTrueID: false)
    }
    
    public static func makeUserFeedByTrueIDProfile(withUserId userId: String) -> AmityUserFeedViewController {
        return AmityUserFeedViewController(feedType: .userFeed(userId: userId), openByProfileTrueID: true)
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupFeedView()
        setupPostButton()
        setupScreenViewModel()
    }
    
    private func setupScreenViewModel() {
        screenViewModel = AmityNewsFeedScreenViewModel()
        screenViewModel?.delegate = self
        fetchUserProfile()
    }
    
    // MARK: - Private functions
    
    private func setupFeedView() {
        addChild(viewController: feedViewController)
    }
    
    private func setupPostButton() {
        createPostButton.image = AmityIconSet.iconCreatePost
        createPostButton.add(to: view, position: .bottomRight)
        createPostButton.actionHandler = { [weak self] button in
            guard let strongSelf = self else { return }
            AmityEventHandler.shared.createPostBeingPrepared(from: strongSelf, postTarget: .myFeed, liveStreamPermission: self?.permissionCanLive ?? false, openByProfileTrueID: self?.openByProfileTrueID ?? false)
//            AmityEventHandler.shared.createPostDidTap(from: strongSelf, postTarget: .myFeed, openByProfileTrueID: self?.openByProfileTrueID ?? false)

        }
        
        // We can't post on other user feed.
        // So, create button will be show particularly on current user feed.
        switch feedType {
        case .myFeed:
            createPostButton.isHidden = false
        case .userFeed(let userId):
            // If current userId is passing through .userFeed, handle this case as .myFeed type.
            createPostButton.isHidden = AmityUIKitManagerInternal.shared.client.currentUserId != userId
        default:
            createPostButton.isHidden = true
        }
    }
    
}

// MARK: - Action
extension AmityUserFeedViewController {
    
    func fetchUserProfile() {
        screenViewModel?.fetchUserProfile(with: AmityUIKitManagerInternal.shared.currentUserId)
    }
    
}
// MARK: - Delegate
extension AmityUserFeedViewController: AmityNewsFeedScreenViewModelDelegate {
    
    func didFetchUserProfile(user: AmityUser) {
        switch AmityUIKitManagerInternal.shared.envByApiKey {
        case .staging:
            let summaryRoles = user.roles + AmityUIKitManagerInternal.shared.stagingLiveRoleID
            Array(Dictionary(grouping: summaryRoles, by: {$0}).filter { $1.count > 1 }.keys).count > 0 ? (permissionCanLive = true) : (permissionCanLive = false)
        case .production:
            let summaryRoles = user.roles + AmityUIKitManagerInternal.shared.productionLiveRoleID
            Array(Dictionary(grouping: summaryRoles, by: {$0}).filter { $1.count > 1 }.keys).count > 0 ? (permissionCanLive = true) : (permissionCanLive = false)
        default:
            let summaryRoles = user.roles + AmityUIKitManagerInternal.shared.productionLiveRoleID
            Array(Dictionary(grouping: summaryRoles, by: {$0}).filter { $1.count > 1 }.keys).count > 0 ? (permissionCanLive = true) : (permissionCanLive = false)
        }
    }
    
}
