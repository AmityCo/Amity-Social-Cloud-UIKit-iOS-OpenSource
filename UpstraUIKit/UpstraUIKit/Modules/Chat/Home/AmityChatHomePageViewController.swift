//
//  AmityChatHomePageViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 6/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

/// Amity Chat home
public class AmityChatHomePageViewController: AmityPageViewController {
    
    // MARK: - Properties
    var recentsChatViewController = AmityRecentChatViewController.make()
    
    // MARK: - View lifecycle
    private init() {
        super.init(nibName: AmityChatHomePageViewController.identifier, bundle: AmityUIKitManager.bundle)
        title = AmityLocalizedStringSet.chatTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make() -> AmityChatHomePageViewController {
        return AmityChatHomePageViewController()
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        recentsChatViewController.pageTitle = AmityLocalizedStringSet.recentTitle.localizedString
        return [recentsChatViewController]
    }
    
}
