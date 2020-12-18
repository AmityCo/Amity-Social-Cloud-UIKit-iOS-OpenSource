//
//  EkoCommunityMemberSettingsViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoCommunityMemberSettingsViewController: EkoPageViewController {
    
    private var communityId: String = ""
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = EkoLocalizedStringSet.CommunityMembreSetting.title
    }
    
    static func make(communityId: String) -> EkoCommunityMemberSettingsViewController {
        let vc = EkoCommunityMemberSettingsViewController(nibName: EkoCommunityMemberSettingsViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.communityId = communityId
        return vc
    }
    
    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        let memberVC = EkoCommunityMemberViewController.make(pageTitle: EkoLocalizedStringSet.CommunityMembreSetting.title, communityId: communityId, viewType: .member)
        let moderatorVC = EkoCommunityMemberModeratorViewController.make(pageTitle: EkoLocalizedStringSet.CommunityMembreSetting.moderatorTitle, communityId: communityId, viewType: .moderator)
        return [memberVC, moderatorVC]
    }
}
