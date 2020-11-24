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
    
    private let viewModel: EkoUserProfileScreenViewModelType
    
    private init(viewModel: EkoUserProfileScreenViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(with viewModel: EkoUserProfileScreenViewModelType) -> EkoUserProfileBottomViewController {
        return EkoUserProfileBottomViewController(viewModel: viewModel)
    }

    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        let timelineVC = EkoFeedViewController.make(feedType: .userFeed(userId: viewModel.userId))
        timelineVC.pageTitle = EkoLocalizedStringSet.timelineTitle
        timelineVC.pageIndex = 0
        return [timelineVC]
    }
    
}
