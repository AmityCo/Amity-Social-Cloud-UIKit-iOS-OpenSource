//
//  EkoUserProfileBottomViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

class EkoUserProfileBottomViewController: EkoProfileBottomViewController {
    
    // MARK: - Properties
    
    private let userId: String
    
    private init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(withUserId userId: String) -> EkoUserProfileBottomViewController {
        return EkoUserProfileBottomViewController(userId: userId)
    }

    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        let timelineVC = EkoFeedViewController.make(feedType: .userFeed(userId: userId))
        timelineVC.pageTitle = EkoLocalizedStringSet.timelineTitle.localizedString
        timelineVC.pageIndex = 0
        return [timelineVC]
    }
    
}
