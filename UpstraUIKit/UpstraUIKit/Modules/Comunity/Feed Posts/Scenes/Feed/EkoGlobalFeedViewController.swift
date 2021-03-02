//
//  EkoGlobalFeedViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 24/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

/// A view controller for providing global post feed which consist of community feed and my own feed..
public class EkoGlobalFeedViewController: EkoViewController {
    
    private let feedViewController: EkoFeedViewController
    private let createPostButton: EkoFloatingButton = EkoFloatingButton()
    
    // MARK: - Initializer
    
    private init() {
        feedViewController = EkoFeedViewController.make(feedType: .globalFeed)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make() -> EkoGlobalFeedViewController {
        return EkoGlobalFeedViewController()
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
            let vc = EkoPostTargetSelectionViewController.make()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            self?.present(nav, animated: true, completion: nil)
        }
    }
    
}
