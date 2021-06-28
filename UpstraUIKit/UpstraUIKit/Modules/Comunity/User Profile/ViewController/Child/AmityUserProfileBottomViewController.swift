//
//  AmityUserProfileBottomViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

class AmityUserProfileBottomViewController: AmityProfileBottomViewController {
    
    // MARK: - Properties
    
    private let userId: String
    
    private init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(withUserId userId: String) -> AmityUserProfileBottomViewController {
        return AmityUserProfileBottomViewController(userId: userId)
    }

    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        let timelineVC = AmityFeedViewController.make(feedType: .userFeed(userId: userId))
        timelineVC.pageTitle = AmityLocalizedStringSet.timelineTitle.localizedString
        timelineVC.pageIndex = 0
        return [timelineVC]
    }
    
}
