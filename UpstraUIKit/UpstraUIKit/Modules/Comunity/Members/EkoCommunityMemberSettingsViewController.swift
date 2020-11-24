//
//  EkoCommunityMemberSettingsViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoCommunityMemberSettingsTableViewController: UITableViewController {
    var pageTitle: String?
    
}

extension EkoCommunityMemberSettingsTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: EkoPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
}

final class EkoCommunityMemberSettingsViewController: EkoPageViewController {
    
    private let screenViewModel: EkoCommunityMemberScreenViewModelType
    // MARK: - View lifecycle
    private init(viewModel: EkoCommunityMemberScreenViewModelType) {
        self.screenViewModel = viewModel
        super.init(nibName: EkoCommunityMemberSettingsViewController.identifier, bundle: UpstraUIKit.bundle)
        title = EkoLocalizedStringSet.communityMemberSettingsTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(communityId: String) -> EkoCommunityMemberSettingsViewController {
        let viewModel: EkoCommunityMemberScreenViewModelType = EkoCommunityMemberScreenViewModel(communityId: communityId)
        let vc = EkoCommunityMemberSettingsViewController(viewModel: viewModel)
        return vc
    }
    
    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        let memberVC = EkoCommunityMemberViewController.make(pageTitle: EkoLocalizedStringSet.communityMemberSettingsTitle, viewModel: screenViewModel)
        return [memberVC]
    }
}
