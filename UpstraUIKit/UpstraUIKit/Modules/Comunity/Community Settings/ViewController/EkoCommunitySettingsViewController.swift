//
//  EkoCommunitySettingsViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 10/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

final class EkoCommunitySettingsViewController: EkoViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var settingTableView: EkoSettingsItemTableView!
    
    // MARK: - Properties
    private var screenViewModel: EkoCommunitySettingsScreenViewModelType!
    
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
    
    static func make(community: EkoCommunityModel) -> EkoCommunitySettingsViewController {
        let userNotificationController = EkoUserNotificationSettingsController()
        let communityNotificationController = EkoCommunityNotificationSettingsController(withCommunityId: community.communityId)
        let communityLeaveController = EkoCommunityLeaveController(withCommunityId: community.communityId)
        let communityDeleteController = EkoCommunityDeleteController(withCommunityId: community.communityId)
        let communityInfoController = EkoCommunityInfoController(communityId: community.communityId)
        let viewModel: EkoCommunitySettingsScreenViewModelType = EkoCommunitySettingsScreenViewModel(community: community,
                                                                                                     userNotificationController: userNotificationController,
                                                                                                     communityNotificationController: communityNotificationController,
                                                                                                     communityLeaveController: communityLeaveController,
                                                                                                     communityDeleteController: communityDeleteController,
                                                                                                     communityInfoController: communityInfoController)
        let vc = EkoCommunitySettingsViewController(nibName: EkoCommunitySettingsViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Setup view
    private func setupView() {
        title = screenViewModel.dataSource.community.displayName
        view.backgroundColor = EkoColorSet.backgroundColor
    }
    
    private func setupSettingTableView() {
        settingTableView.actionHandler = { [weak self] settingsItem in
            self?.handleActionItem(settingsItem: settingsItem)
        }
    }
    
    private func handleActionItem(settingsItem: EkoSettingsItem) {
        switch settingsItem {
        case .navigationContent(let content):
            guard let item = EkoCommunitySettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .editProfile:
                let vc = EkoCommunityProfileEditViewController.make(viewType: .edit(communityId: screenViewModel.dataSource.community.communityId))
                vc.delegate = self
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
            case .members:
                let vc = EkoCommunityMemberSettingsViewController.make(community: screenViewModel.dataSource.community)
                navigationController?.pushViewController(vc, animated: true)
            case .notification:
                let vc = EkoCommunityNotificationSettingsViewController.make(community: screenViewModel.dataSource.community)
                navigationController?.pushViewController(vc, animated: true)
            case .postReview:
                let vc = EkoPostReviewSettingsViewController.make()
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case .textContent(let content):
            guard let item = EkoCommunitySettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .leaveCommunity:
                EkoAlertController.present(
                    title: EkoLocalizedStringSet.CommunitySettings.alertTitleLeave.localizedString,
                    message: EkoLocalizedStringSet.CommunitySettings.alertDescLeave.localizedString,
                    actions: [.cancel(handler: nil),
                              .custom(title: EkoLocalizedStringSet.leave.localizedString,
                                      style: .destructive, handler: { [weak self] in
                                        self?.screenViewModel.action.leaveCommunity()
                                      })],
                    from: self)
            case .closeCommunity:
                EkoAlertController.present(
                    title: EkoLocalizedStringSet.CommunitySettings.alertTitleClose.localizedString,
                    message: EkoLocalizedStringSet.CommunitySettings.alertDescClose.localizedString,
                    actions: [.cancel(handler: nil),
                              .custom(title: EkoLocalizedStringSet.close.localizedString,
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

extension EkoCommunitySettingsViewController: EkoCommunitySettingsScreenViewModelDelegate {
  
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModelType, didGetSettingMenu settings: [EkoSettingsItem]) {
        settingTableView.settingsItems = settings
    }
    
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModelType, didGetCommunitySuccess community: EkoCommunityModel) {
        title = community.displayName
    }
        
    func screenViewModelDidLeaveCommunity() {
        EkoHUD.hide()
        navigationController?.popViewController(animated: true)
    }
    
    func screenViewModelDidCloseCommunity() {
        EkoHUD.hide()
        if let communityHomePage = navigationController?.viewControllers.first(where: { $0.isKind(of: EkoCommunityHomePageViewController.self) }) {
            navigationController?.popToViewController(communityHomePage, animated: true)
        } else if let globalFeedViewController = navigationController?.viewControllers.first(where: { $0.isKind(of: EkoGlobalFeedViewController.self) }) {
            navigationController?.popToViewController(globalFeedViewController, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
  
    func screenViewModelDidLeaveCommunityFail() {
        EkoAlertController.present(title: EkoLocalizedStringSet.CommunitySettings.alertFailTitleLeave.localizedString,
                                   message: EkoLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                   actions: [.ok(handler: nil)], from: self)
    }
    
    func screenViewModelDidCloseCommunityFail() {
        EkoAlertController.present(title: EkoLocalizedStringSet.CommunitySettings.alertFailTitleClose.localizedString,
                                   message: EkoLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                   actions: [.ok(handler: nil)], from: self)
    }
    
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModelType, failure error: EkoError) {
        switch error {
        case .noPermission:
            EkoAlertController.present(title: EkoLocalizedStringSet.Community.alertUnableToPerformActionTitle.localizedString,
                                       message: EkoLocalizedStringSet.Community.alertUnableToPerformActionDesc.localizedString,
                                       actions: [.ok(handler: { [weak self] in
                                        self?.navigationController?.popToRootViewController(animated: true)
                                       })], from: self)
        default:
            break
        }
    }
    
}

extension EkoCommunitySettingsViewController: EkoCommunityProfileEditViewControllerDelegate {

    func viewController(_ viewController: EkoCommunityProfileEditViewController, didFinishCreateCommunity communityId: String) {
        EkoEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }

    func viewController(_ viewController: EkoCommunityProfileEditViewController, didFailWithNoPermission: Bool) {
        navigationController?.popToRootViewController(animated: true)
    }

}
