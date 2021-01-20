//
//  EkoCommunityDetailBottomViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 14/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final public class EkoCommunityFeedViewController: EkoProfileBottomViewController {
    
    // MARK: - Properties
    private let screenViewModel: EkoCommunityProfileScreenViewModelType
    private var timelineVC: EkoFeedViewController!
    
    init(viewModel: EkoCommunityProfileScreenViewModelType) {
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
    
    public static func make(communityId: String) -> EkoCommunityFeedViewController {
        let viewModel = EkoCommunityProfileScreenViewModel(communityId: communityId)
        let vc = EkoCommunityFeedViewController(viewModel: viewModel)
        return vc
    }

    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        timelineVC = EkoFeedViewController.make(feedType: .communityFeed(communityId: screenViewModel.dataSource.communityId))
        timelineVC?.pageTitle = EkoLocalizedStringSet.timelineTitle.localizedString
        timelineVC?.pageIndex = 0
        return [timelineVC]
    }
}

private extension EkoCommunityFeedViewController {
    func bindingViewModel() {
        timelineVC.emptyViewHandler = { [weak self] emptyView in
            guard let strongSelf = self, let emptyView = emptyView as? EkoEmptyStateHeaderFooterView else { return }
            if strongSelf.screenViewModel.dataSource.community?.isCreator ?? false {
                emptyView.setLayout(layout: .label(title: EkoLocalizedStringSet.emptyNewsfeedTitle.localizedString, subtitle: EkoLocalizedStringSet.emptyNewsfeedStartYourFirstPost.localizedString, image: nil))
            } else {
                emptyView.setLayout(layout: .label(title: EkoLocalizedStringSet.emptyTitleNoPosts.localizedString, subtitle: nil, image: EkoIconSet.emptyNoPosts))
            }
        }
    }
}
