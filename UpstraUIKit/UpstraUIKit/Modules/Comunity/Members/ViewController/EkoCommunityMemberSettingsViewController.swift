//
//  EkoCommunityMemberSettingsViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityMemberSettingsViewController: EkoPageViewController {
    
    private var communityId: String = ""
    private var userModeratorController: EkoCommunityUserModeratorController?
    private var membershipParticipation: EkoCommunityParticipation?
    private var communityInfoController: EkoCommunityInfoController?
    
    // MARK: - Child ViewController
    private var memberVC: EkoCommunityMemberViewController?
    private var moderatorVC: EkoCommunityMemberViewController?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = EkoLocalizedStringSet.CommunityMembreSetting.title
        getUserModerator()
    }
    
    static func make(communityId: String) -> EkoCommunityMemberSettingsViewController {
        let vc = EkoCommunityMemberSettingsViewController(nibName: EkoCommunityMemberSettingsViewController.identifier,
                                                          bundle: UpstraUIKitManager.bundle)
        
        vc.communityId = communityId
        let communityInfoController = EkoCommunityInfoController(communityId: communityId)
        let membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client,
                                                                andCommunityId: communityId)
        let userModeratorController = EkoCommunityUserModeratorController(communityId: communityId,
                                                                          userId: UpstraUIKitManagerInternal.shared.currentUserId)
        vc.communityInfoController = communityInfoController
        vc.membershipParticipation = membershipParticipation
        vc.userModeratorController = userModeratorController
        return vc
    }
    
    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        memberVC = EkoCommunityMemberViewController.make(pageTitle: EkoLocalizedStringSet.CommunityMembreSetting.title,
                                                         viewType: .member,
                                                         membershipParticipation: membershipParticipation,
                                                         userModeratorController: userModeratorController,
                                                         communityInfoController: communityInfoController,
                                                         communityId: communityId)
        
        moderatorVC = EkoCommunityMemberViewController.make(pageTitle: EkoLocalizedStringSet.CommunityMembreSetting.moderatorTitle,
                                                            viewType: .moderator,
                                                            membershipParticipation: membershipParticipation,
                                                            userModeratorController: userModeratorController,
                                                            communityInfoController: communityInfoController,
                                                            communityId: communityId)
        return [memberVC!, moderatorVC!]
    }
    
    private func getUserModerator() {
        if userModeratorController?.isModerator ?? false {
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
        
        vc.getUsersFromCreatePage(users: memberVC.passMember())
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
}
