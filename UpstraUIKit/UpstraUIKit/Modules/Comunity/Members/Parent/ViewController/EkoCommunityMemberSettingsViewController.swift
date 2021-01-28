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
    
    private var screenViewModel: EkoCommunityMemberSettingsScreenViewModelType!
    
    // MARK: - Child ViewController
    private var memberVC: EkoCommunityMemberViewController?
    private var moderatorVC: EkoCommunityMemberViewController?
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = EkoLocalizedStringSet.CommunityMembreSetting.title.localizedString
        screenViewModel.delegate = self
        screenViewModel.action.getUserRoles()
    }
    
    public static func make(community: EkoCommunityModel) -> EkoCommunityMemberSettingsViewController {
        let userRolesController: EkoCommunityUserRolesControllerProtocol = EkoCommunityUserRolesController(communityId: community.communityId)
        let viewModel: EkoCommunityMemberSettingsScreenViewModelType = EkoCommunityMemberSettingsScreenViewModel(community: community,
                                                                                                                 userRolesController: userRolesController)
        let vc = EkoCommunityMemberSettingsViewController(nibName: EkoCommunityMemberSettingsViewController.identifier,
                                                          bundle: UpstraUIKitManager.bundle)
        
        vc.screenViewModel = viewModel
        return vc
    }
    
    override func viewControllers(for pagerTabStripController: EkoPagerTabViewController) -> [UIViewController] {
        memberVC = EkoCommunityMemberViewController.make(pageTitle: EkoLocalizedStringSet.CommunityMembreSetting.title.localizedString,
                                                         viewType: .member,
                                                         community: screenViewModel.dataSource.community)
        
        moderatorVC = EkoCommunityMemberViewController.make(pageTitle: EkoLocalizedStringSet.CommunityMembreSetting.moderatorTitle.localizedString,
                                                            viewType: .moderator,
                                                            community: screenViewModel.dataSource.community)
        return [memberVC!, moderatorVC!]
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

extension EkoCommunityMemberSettingsViewController: EkoCommunityMemberSettingsScreenViewModelDelegate {
    func screenViewModelShouldShowAddButtonBarItem(status: Bool) {
        if status {
            let rightItem = UIBarButtonItem(image: EkoIconSet.iconAdd, style: .plain, target: self, action: #selector(addMemberTap))
            rightItem.tintColor = EkoColorSet.base
            navigationItem.rightBarButtonItem = rightItem
            navigationController?.reset()
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
}
