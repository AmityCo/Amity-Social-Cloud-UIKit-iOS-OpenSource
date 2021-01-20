//
//  EkoChatHomePageViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 6/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

/// Eko Chat home
public class EkoChatHomePageViewController: EkoPageViewController {
    
    // MARK: - Properties
    var recentsChatViewController = EkoRecentChatViewController.make()
    public var messageDataSource: EkoMessageListDataSource? {
        get {
            return recentsChatViewController.messageDataSource
        } set {
            recentsChatViewController.messageDataSource = newValue
        }
    }
    
    // MARK: - View lifecycle
    private init() {
        super.init(nibName: EkoChatHomePageViewController.identifier, bundle: UpstraUIKitManager.bundle)
        title = EkoLocalizedStringSet.chatTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make() -> EkoChatHomePageViewController {
        return EkoChatHomePageViewController()
    }
    
    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        recentsChatViewController.pageTitle = EkoLocalizedStringSet.recentTitle.localizedString
        return [recentsChatViewController]
    }
    
}
