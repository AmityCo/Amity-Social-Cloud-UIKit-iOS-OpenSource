//
//  AmityCommunityDetailBottomViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 14/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

final public class AmityCommunityFeedViewController: AmityProfileBottomViewController {
    
    // MARK: - Properties
    private let screenViewModel: AmityCommunityProfileScreenViewModelType
    private var timelineVC: AmityFeedViewController!
    
    init(viewModel: AmityCommunityProfileScreenViewModelType) {
        screenViewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
    }
    
    public static func make(communityId: String) -> AmityCommunityFeedViewController {
        let viewModel = AmityCommunityProfileScreenViewModel(communityId: communityId)
        let vc = AmityCommunityFeedViewController(viewModel: viewModel)
        return vc
    }

    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        timelineVC = AmityFeedViewController.make(feedType: .communityFeed(communityId: screenViewModel.dataSource.communityId))
        timelineVC?.pageTitle = AmityLocalizedStringSet.timelineTitle.localizedString
        timelineVC?.pageIndex = 0
        return [timelineVC]
    }
}

private extension AmityCommunityFeedViewController {
    func bindingViewModel() {
        timelineVC.emptyViewHandler = { [weak self] emptyView in
            guard let strongSelf = self, let emptyView = emptyView as? AmityEmptyStateHeaderFooterView else { return }
            if strongSelf.screenViewModel.dataSource.community?.isCreator ?? false {
                emptyView.setLayout(layout: .label(title: AmityLocalizedStringSet.emptyNewsfeedTitle.localizedString, subtitle: AmityLocalizedStringSet.emptyNewsfeedStartYourFirstPost.localizedString, image: nil))
            } else {
                emptyView.setLayout(layout: .label(title: AmityLocalizedStringSet.emptyTitleNoPosts.localizedString, subtitle: nil, image: AmityIconSet.emptyNoPosts))
            }
        }
    }
}
