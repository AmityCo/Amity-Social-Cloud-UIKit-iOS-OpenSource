//
//  AmityGlobalFeedViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

/// A view controller for providing global post feed which consist of community feed and my own feed..
public class AmityGlobalFeedViewController: AmityViewController {
    
    private let feedViewController: AmityFeedViewController
    private let createPostButton: AmityFloatingButton = AmityFloatingButton()
    
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
