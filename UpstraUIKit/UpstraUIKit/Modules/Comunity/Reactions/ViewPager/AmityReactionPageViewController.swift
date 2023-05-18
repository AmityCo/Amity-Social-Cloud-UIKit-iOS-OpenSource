//
//  AmityReactionPageViewController.swift
//  AmityUIKit
//
//  Created by Amity on 2/5/2566 BE.
//  Copyright © 2566 BE Amity. All rights reserved.
//

import UIKit

/// ViewPager which contains screen showing list of reaction users.
public class AmityReactionPageViewController: AmityPageViewController {

    let info: [AmityReactionInfo]
    let reactionViewController: AmityReactionUsersViewController
        
    // MARK: - View lifecycle
    private init(info: [AmityReactionInfo]) {
        self.info = info
        self.reactionViewController = AmityReactionUsersViewController.make(with: info[0])
        
        super.init(nibName: AmityReactionPageViewController.identifier, bundle: AmityUIKitManager.bundle)
        title = AmityLocalizedStringSet.Reaction.reactionTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    /// Initializes instance of AmityReactionPageViewController.
    public static func make(info: [AmityReactionInfo]) -> AmityReactionPageViewController {
        return AmityReactionPageViewController(info: info)
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        return [reactionViewController]
    }
}
