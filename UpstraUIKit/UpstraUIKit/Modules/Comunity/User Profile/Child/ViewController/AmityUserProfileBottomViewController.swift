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
    
    private var timelineVC: AmityFeedViewController?
    private var galleryVC: AmityPostGalleryViewController?
    
    static func make(withUserId userId: String) -> AmityUserProfileBottomViewController {
        
        // 1. Timeline
        let timelineVC = AmityFeedViewController.make(feedType: .userFeed(userId: userId))
        timelineVC.pageTitle = AmityLocalizedStringSet.timelineTitle.localizedString
        timelineVC.pageIndex = 0
        
        // 2. Gallery
        let galleryVC = AmityPostGalleryViewController.make(targetType: .user, targetId: userId)
        
        // The VC
        let vc = AmityUserProfileBottomViewController()
        vc.timelineVC = timelineVC
        vc.galleryVC = galleryVC
        
        return vc
    }

    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        
        var viewControllers: [UIViewController] = []
        // 0. Timeline
        if let timelineVC = timelineVC {
            viewControllers.append(timelineVC)
        }
        // 1. Media Gallery
        if let galleryVC = galleryVC {
            viewControllers.append(galleryVC)
        }
        return viewControllers
        
    }
    
}
