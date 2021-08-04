//
//  AmityChannelMemberSettingsViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public final class AmityChannelMemberSettingsViewController: AmityPageViewController {
    
    private var screenViewModel: AmityChannelMemberSettingsScreenViewModelType!
    
    // MARK: - Child ViewController
    private var memberVC: AmityChannelMemberViewController?
    private var moderatorVC: AmityChannelMemberViewController?
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = AmityLocalizedStringSet.ChatSettings.navigationTitle.localizedString
        screenViewModel.delegate = self
        screenViewModel.action.getUserRoles()
    }
    
    public static func make(channel: AmityChannelModel) -> AmityChannelMemberSettingsViewController {
        let viewModel = AmityChannelMemberSettingsScreenViewModel(channel: channel)
        let vc = AmityChannelMemberSettingsViewController(nibName: AmityChannelMemberSettingsViewController.identifier,
                                                          bundle: AmityUIKitManager.bundle)
        
        vc.screenViewModel = viewModel
        return vc
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        memberVC = AmityChannelMemberViewController.make(
            pageTitle: AmityLocalizedStringSet.ChatSettings.memberTitle.localizedString,
            viewType: .member,
            channel: screenViewModel.dataSource.channel)
        
        moderatorVC = AmityChannelMemberViewController.make(
            pageTitle: AmityLocalizedStringSet.ChatSettings.moderatorTitle.localizedString,
            viewType: .moderator,
            channel: screenViewModel.dataSource.channel)
        return [memberVC!, moderatorVC!]
    }

    @objc private func addMemberTap() {
        guard let memberVC = memberVC else { return }
        AmityChannelEventHandler.shared.channelAddMemberDidTap(
            from: self,
            channelId: screenViewModel.dataSource.channel.channelId,
            selectedUsers: memberVC.passMember(),
            completionHandler: { storeUsers in
                memberVC.addMember(users: storeUsers)
            }
        )
    }
}

extension AmityChannelMemberSettingsViewController: AmityChannelMemberSettingsScreenViewModelDelegate {
    func screenViewModelShouldShowAddButtonBarItem(status: Bool) {
        if status {
            let rightItem = UIBarButtonItem(image: AmityIconSet.iconAdd, style: .plain, target: self, action: #selector(addMemberTap))
            rightItem.tintColor = AmityColorSet.base
            navigationItem.rightBarButtonItem = rightItem
            navigationController?.reset()
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
}
