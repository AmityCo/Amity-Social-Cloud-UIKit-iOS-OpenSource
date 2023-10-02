//
//  AmityUserFeedViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 9/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

/// A view controller for providing specific user post feed.
public class AmityUserFeedViewController: AmityViewController {
    
    private let feedViewController: AmityFeedViewController
    private let createPostButton: AmityFloatingButton = AmityFloatingButton()
    private let feedType: AmityPostFeedType
    
    // MARK: - Initializer
    
    init(feedType: AmityPostFeedType) {
        self.feedType = feedType
        feedViewController = AmityFeedViewController.make(feedType: feedType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, deprecated, message: "`AmityUserFeedViewController.makeMyFeed()` method is deprecated. Please calls `AmityMyFeedViewController.make()` instead.")
    public static func makeMyFeed() -> AmityUserFeedViewController {
        return AmityUserFeedViewController(feedType: .myFeed)
    }
    
    public static func makeUserFeed(withUserId userId: String) -> AmityUserFeedViewController {
        return AmityUserFeedViewController(feedType: .userFeed(userId: userId))
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupFeedView()
        setupPostButton()
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
            AmityEventHandler.shared.createPostBeingPrepared(from: strongSelf, postTarget: .myFeed)
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

