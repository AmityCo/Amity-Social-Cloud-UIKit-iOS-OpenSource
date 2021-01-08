//
//  EkoCommunityMemberSettingsViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

public final class EkoCommunityMemberSettingsViewController: EkoPageViewController {
    
    private var communityId: String = ""
    private var userRolesController: EkoCommunityUserRolesControllerProtocol?
    
    // MARK: - Child ViewController
    private var memberVC: EkoCommunityMemberViewController?
    private var moderatorVC: EkoCommunityMemberViewController?
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = EkoLocalizedStringSet.CommunityMembreSetting.title
        getUserModerator()
    }
    
    public static func make(communityId: String) -> EkoCommunityMemberSettingsViewController {
        let vc = EkoCommunityMemberSettingsViewController(nibName: EkoCommunityMemberSettingsViewController.identifier,
                                                          bundle: UpstraUIKitManager.bundle)
        
        vc.communityId = communityId
        return vc
    }
    
    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        memberVC = EkoCommunityMemberViewController.make(pageTitle: EkoLocalizedStringSet.CommunityMembreSetting.title,
                                                         viewType: .member,
                                                         communityId: communityId)
        
        moderatorVC = EkoCommunityMemberViewController.make(pageTitle: EkoLocalizedStringSet.CommunityMembreSetting.moderatorTitle,
                                                            viewType: .moderator,
                                                            communityId: communityId)
        return [memberVC!, moderatorVC!]
    }
    
    private func getUserModerator() {
        userRolesController = EkoCommunityUserRolesController(communityId: communityId)
        
        if userRolesController?.getUserRoles(withUserId: UpstraUIKitManagerInternal.shared.currentUserId, role: .moderator) ?? false {
            let rightItem = UIBarButtonItem(image: EkoIconSet.iconAdd, style: .plain, target: self, action: #selector(addMemberTap))
            rightItem.tintColor = EkoColorSet.base
            navigationItem.rightBarButtonItem = rightItem
            navigationController?.reset()
        }
    }
    
    @objc private func addMemberTap() {
        guard let memberVC = memberVC else { return }
        let vc = EkoSelectMemberListViewController.make()
        vc.selectUsersHandler = { storeUsers in
            memberVC.addMember(users: storeUsers)
        }
        
        vc.getCurrentUsersList(users: memberVC.passMember())
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
}
