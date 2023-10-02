//
//  AmityCommunityNotificationSettingsViewController.swift
//  AmityUIKit
//
//  Created by Hamlet on 03.03.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

class AmityCommunityNotificationSettingsViewController: AmityViewController {

    @IBOutlet private var tableView: AmitySettingsItemTableView!
    
    private var screenViewModel: AmityCommunityNotificationSettingsScreenViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        screenViewModel.delegate = self
        setupView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenViewModel.action.retrieveNotifcationSettings()
    }
    
    static func make(community: AmityCommunityModel) -> AmityCommunityNotificationSettingsViewController {
        let notificationSettingsController = AmityCommunityNotificationSettingsController(withCommunityId: community.communityId)
        let viewModel: AmityCommunityNotificationSettingsScreenViewModelType = AmityCommunityNotificationSettingsScreenViewModel(community: community, notificationSettingsController: notificationSettingsController)
        let vc = AmityCommunityNotificationSettingsViewController(nibName: AmityCommunityNotificationSettingsViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
}

// MARK: - Setup view
private extension AmityCommunityNotificationSettingsViewController {
    
    private func setupView() {
        title = AmityLocalizedStringSet.CommunitySettings.itemTitleNotifications.localizedString
    }
    
    private func setupTableView() {
        tableView.isEmptyViewHidden = Reachability.shared.isConnectedToNetwork
        tableView.updateEmptyView(title: AmityLocalizedStringSet.noInternetConnection.localizedString, subtitle: nil, image: AmityIconSet.noInternetConnection)
        tableView.actionHandler = { [weak self] settingsItem in
            self?.handleActionItem(settingsItem: settingsItem)
        }
    }
    
    private func handleActionItem(settingsItem: AmitySettingsItem) {
        switch settingsItem {
        case .toggleContent(let content):
            if content.isToggled {
                screenViewModel.action.enableNotificationSetting()
            } else {
                screenViewModel.action.disableNotificationSetting()
            }
        case .navigationContent(let content):
            guard let item = AmityCommunityNotificationSettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .mainToggle:
                assertionFailure("Item type must be a navigation type")
            case .postNavigation:
                let vc = AmityPostNotificationSettingsViewController.make(communityId: screenViewModel.community.communityId, type: .post)
                navigationController?.pushViewController(vc, animated: true)
            case .commentNavigation:
                let vc = AmityPostNotificationSettingsViewController.make(communityId: screenViewModel.community.communityId, type: .comment)
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}

extension AmityCommunityNotificationSettingsViewController: AmityCommunityNotificationSettingsViewModelDelegate {
    func screenViewModel(_ viewModel: AmityCommunityNotificationSettingsScreenViewModelType, didUpdateSettingItem settings: [AmitySettingsItem]) {
        tableView.settingsItems = settings
    }
    
    func screenViewModel(_ viewModel: AmityCommunityNotificationSettingsScreenViewModelType, didUpdateLoadingState state: AmityLoadingState) {
        switch state {
        case .loading:
            tableView.showLoadingIndicator()
        case .loaded:
            tableView.tableFooterView = nil
        case .initial:
            break
        }
    }
    
    func screenViewModel(_ viewModel: AmityCommunityNotificationSettingsScreenViewModelType, didFailWithError error: AmityError) {
        
        AmityHUD.hide { [weak self] in
            guard let strongSelf = self else { return }
            let title = strongSelf.screenViewModel.dataSource.isNotificationEnabled ? AmityLocalizedStringSet.CommunitySettings.alertFailTitleTurnNotificationOn.localizedString :  AmityLocalizedStringSet.CommunitySettings.alertFailTitleTurnNotificationOff.localizedString
            AmityAlertController.present(title: title,
                                       message: AmityLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                       actions: [.ok(handler: nil)], from: strongSelf)
        }
    }
}
