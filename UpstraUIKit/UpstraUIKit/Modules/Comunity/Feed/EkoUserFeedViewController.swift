//
//  EkoUserFeedViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 9/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

/// A view controller for providing specific user post feed.
public class EkoUserFeedViewController: EkoViewController {
    
    private let feedViewController: EkoFeedViewController
    private let createPostButton: EkoFloatingButton = EkoFloatingButton()
    private let feedType: FeedType
    
    // MARK: - Initializer
    
    private init(feedType: FeedType) {
        self.feedType = feedType
        feedViewController = EkoFeedViewController.make(feedType: feedType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func makeMyFeed() -> EkoUserFeedViewController {
        return EkoUserFeedViewController(feedType: .myFeed)
    }
    
    public static func makeUserFeed(withUserId userId: String) -> EkoUserFeedViewController {
        return EkoUserFeedViewController(feedType: .userFeed(userId: userId))
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
        createPostButton.image = EkoIconSet.iconCreatePost
        createPostButton.add(to: view, position: .bottomRight)
        createPostButton.actionHandler = { [weak self] button in
            guard let strongSelf = self else { return }
            EkoEventHandler.shared.createPostDidTap(from: strongSelf, postTarget: .myFeed)
        }
        
        // We can't post on other user feed.
        // So, create button will be show particularly on current user feed.
        switch feedType {
        case .myFeed:
            createPostButton.isHidden = false
        case .userFeed(let userId):
            // If current userId is passing through .userFeed, handle this case as .myFeed type.
            createPostButton.isHidden = UpstraUIKitManagerInternal.shared.client.currentUserId != userId
        default:
            createPostButton.isHidden = true
        }
    }
    
}

