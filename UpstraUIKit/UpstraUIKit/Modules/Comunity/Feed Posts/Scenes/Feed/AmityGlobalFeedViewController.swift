//
//  AmityGlobalFeedViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

/// A view controller for providing global post feed which consist of community feed and my own feed.
public class AmityGlobalFeedViewController: AmityViewController {
    
    private var feedViewController: AmityFeedViewController!
    private let createPostButton: AmityFloatingButton = AmityFloatingButton()
    
    // MARK: - Initializer
    
    /// Initialize a global feed showing posts.
    /// The feed consists of user posts, participated community posts and connected user posts.
    public static func make() -> AmityGlobalFeedViewController {
        let vc = AmityGlobalFeedViewController(nibName: nil, bundle: nil)
        vc.feedViewController = AmityFeedViewController.make(feedType: .globalFeed)
        return vc
    }
    
    /// Initialize a global feed showing posts with customizable ranking sorting.
    /// The feed eed consists of user posts, participated community posts and connected user posts.
    ///
    /// The custom post ranking needs to be enabled on server settings.
    public static func makeCustomPostRanking() -> AmityGlobalFeedViewController {
        let vc = AmityGlobalFeedViewController(nibName: nil, bundle: nil)
        vc.feedViewController = AmityFeedViewController.make(feedType: .customPostRankingGlobalFeed)
        return vc
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
            AmityEventHandler.shared.createPostBeingPrepared(from: strongSelf)
        }
    }
    
}
