//
//  AmityCommunitySettingsViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 10/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityCommunitySettingsViewController: AmityViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var settingTableView: AmitySettingsItemTableView!
    
    // MARK: - Properties
    private var screenViewModel: AmityCommunitySettingsScreenViewModelType!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenViewModel.delegate = self
        setupView()
        setupSettingTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenViewModel.action.retrieveCommunity()
        screenViewModel.action.retrieveNotifcationSettings()
    }
    
    static func make(communityId: String) -> AmityCommunitySettingsViewController {
        let userNotificationController = AmityUserNotificationSettingsController()
        let communityNotificationController = AmityCommunityNotificationSettingsController(withCommunityId: communityId)
        let communityLeaveController = AmityCommunityLeaveController(withCommunityId: communityId)
        let communityDeleteController = AmityCommunityDeleteController(withCommunityId: communityId)
        let communityInfoController = AmityCommunityInfoController(communityId: communityId)
        let communityUserRoleController = AmityCommunityUserRolesController(communityId: communityId)
        let viewModel: AmityCommunitySettingsScreenViewModelType = AmityCommunitySettingsScreenViewModel(communityId: communityId,
                                                                                          userNotificationController: userNotificationController,
                                                                                     communityNotificationController: communityNotificationController,
                                                                                            communityLeaveController: communityLeaveController,
                                                                                           communityDeleteController: communityDeleteController,
                                                                                             communityInfoController: communityInfoController,
                                                                                                 userRolesController: communityUserRoleController)
        let vc = AmityCommunitySettingsViewController(nibName: AmityCommunitySettingsViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Setup view
    private func setupView() {
        view.backgroundColor = AmityColorSet.backgroundColor
    }
    
    private func setupSettingTableView() {
        settingTableView.actionHandler = { [weak self] settingsItem in
            self?.handleActionItem(settingsItem: settingsItem)
        }
    }
    
    private func handleActionItem(settingsItem: AmitySettingsItem) {
        guard let community = screenViewModel.dataSource.community else { return }
        switch settingsItem {
        case .navigationContent(let content):
            guard let item = AmityCommunitySettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .editProfile:
                let vc = AmityCommunityEditorViewController.make(withCommunityId: community.communityId)
                vc.delegate = self
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
            case .members:
                let vc = AmityCommunityMemberSettingsViewController.make(community: community.object)
                navigationController?.pushViewController(vc, animated: true)
            case .notification:
                let vc = AmityCommunityNotificationSettingsViewController.make(community: community)
                navigationController?.pushViewController(vc, animated: true)
            case .postReview:
                let vc = AmityPostReviewSettingsViewController.make(communityId: community.communityId)
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case .textContent(let content):
            guard let item = AmityCommunitySettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .leaveCommunity:
                let alertTitle = AmityLocalizedStringSet.CommunitySettings.alertTitleLeave.localizedString
                let actionTitle = AmityLocalizedStringSet.General.leave.localizedString
                var description = AmityLocalizedStringSet.CommunitySettings.alertDescLeave.localizedString
                let isOnlyOneMember = screenViewModel.dataSource.community?.membersCount == 1
                if screenViewModel.dataSource.isModerator(userId: AmityUIKitManagerInternal.shared.currentUserId) {
                    description = AmityLocalizedStringSet.CommunitySettings.alertDescModeratorLeave.localizedString
                }

                AmityAlertController.present(
                    title: alertTitle,
                    message: description.localizedString,
                    actions: [.cancel(handler: nil), .custom(title: actionTitle.localizedString, style: .destructive, handler: { [weak self] in
                        guard let strongSelf = self else { return }
                        if isOnlyOneMember {
                            let description = AmityLocalizedStringSet.CommunitySettings.alertDescLastModeratorLeave.localizedString
                            AmityAlertController.present(title: alertTitle, message: description, actions: [.cancel(handler: nil), .custom(title: AmityLocalizedStringSet.General.close.localizedString, style: .destructive, handler: { [weak self] in
                                    self?.screenViewModel.action.closeCommunity()
                            })],
                            from: strongSelf)
                        } else {
                            strongSelf.screenViewModel.action.leaveCommunity()
                        }
                    })],
                    from: self)
            case .closeCommunity:
                AmityAlertController.present(
                    title: AmityLocalizedStringSet.CommunitySettings.alertTitleClose.localizedString,
                    message: AmityLocalizedStringSet.CommunitySettings.alertDescClose.localizedString,
                    actions: [.cancel(handler: nil),
                              .custom(title: AmityLocalizedStringSet.General.close.localizedString,
                                      style: .destructive,
                                      handler: { [weak self] in
                                        self?.screenViewModel.action.closeCommunity()
                                      })],
                    from: self)
            default:
                break
            }
        default:
            break
        }
    }
}

extension AmityCommunitySettingsViewController: AmityCommunitySettingsScreenViewModelDelegate {
  
    func screenViewModel(_ viewModel: AmityCommunitySettingsScreenViewModelType, didGetSettingMenu settings: [AmitySettingsItem]) {
        settingTableView.settingsItems = settings
    }
    
    func screenViewModel(_ viewModel: AmityCommunitySettingsScreenViewModelType, didGetCommunitySuccess community: AmityCommunityModel) {
        title = community.displayName
    }
        
    func screenViewModelDidLeaveCommunity() {
        AmityHUD.hide()
        AmityEventHandler.shared.leaveCommunityDidTap(from: self, communityId: screenViewModel.communityId)
    }
    
    func screenViewModelDidCloseCommunity() {
        AmityHUD.hide()
        if let communityHomePage = navigationController?.viewControllers.first(where: { $0.isKind(of: AmityCommunityHomePageViewController.self) }) {
            navigationController?.popToViewController(communityHomePage, animated: true)
        } else if let globalFeedViewController = navigationController?.viewControllers.first(where: { $0.isKind(of: AmityGlobalFeedViewController.self) }) {
            navigationController?.popToViewController(globalFeedViewController, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
  
    func screenViewModelDidLeaveCommunityFail() {
        AmityAlertController.present(title: AmityLocalizedStringSet.CommunitySettings.alertFailTitleLeave.localizedString,
                                   message: AmityLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                   actions: [.ok(handler: nil)], from: self)
    }
    
    func screenViewModelDidCloseCommunityFail() {
        AmityAlertController.present(title: AmityLocalizedStringSet.CommunitySettings.alertFailTitleClose.localizedString,
                                   message: AmityLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                   actions: [.ok(handler: nil)], from: self)
    }
    
    func screenViewModel(_ viewModel: AmityCommunitySettingsScreenViewModelType, failure error: AmityError) {
        switch error {
        case .noPermission:
            AmityAlertController.present(title: AmityLocalizedStringSet.Community.alertUnableToPerformActionTitle.localizedString,
                                       message: AmityLocalizedStringSet.Community.alertUnableToPerformActionDesc.localizedString,
                                       actions: [.ok(handler: { [weak self] in
                                        self?.navigationController?.popToRootViewController(animated: true)
                                       })], from: self)
        case .unableToLeaveCommunity:
            AmityAlertController.present(title: AmityLocalizedStringSet.Community.alertUnableToLeaveCommunityTitle.localizedString,
                                       message: AmityLocalizedStringSet.Community.alertUnableToLeaveCommunityDesc.localizedString,
                                       actions: [.ok(handler: nil)], from: self)
        default:
            break
        }
    }
    
}

extension AmityCommunitySettingsViewController: AmityCommunityProfileEditorViewControllerDelegate {

    func viewController(_ viewController: AmityCommunityProfileEditorViewController, didFinishCreateCommunity communityId: String) {
        AmityEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }

    func viewController(_ viewController: AmityCommunityProfileEditorViewController, didFailWithNoPermission: Bool) {
        navigationController?.popToRootViewController(animated: true)
    }

}
