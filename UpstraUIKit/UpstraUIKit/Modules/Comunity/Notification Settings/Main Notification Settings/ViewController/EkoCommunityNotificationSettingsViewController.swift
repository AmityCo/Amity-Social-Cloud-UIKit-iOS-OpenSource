//
//  EkoCommunityNotificationSettingsViewController.swift
//  UpstraUIKit
//
//  Created by Hamlet on 03.03.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

class EkoCommunityNotificationSettingsViewController: EkoViewController {

    @IBOutlet private var tableView: EkoSettingsItemTableView!
    
    private var screenViewModel: EkoCommunityNotificationSettingsScreenViewModelType!
    
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
    
    static func make(community: EkoCommunityModel) -> EkoCommunityNotificationSettingsViewController {
        let notificationSettingsController = EkoCommunityNotificationSettingsController(withCommunityId: community.communityId)
        let viewModel: EkoCommunityNotificationSettingsScreenViewModelType = EkoCommunityNotificationSettingsScreenViewModel(community: community, notificationSettingsController: notificationSettingsController)
        let vc = EkoCommunityNotificationSettingsViewController(nibName: EkoCommunityNotificationSettingsViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
}

// MARK: - Setup view
private extension EkoCommunityNotificationSettingsViewController {
    
    private func setupView() {
        title = EkoLocalizedStringSet.CommunitySettings.itemTitleNotifications.localizedString
    }
    
    private func setupTableView() {
        tableView.isEmptyViewHidden = Reachability.isConnectedToNetwork()
        tableView.updateEmptyView(title: EkoLocalizedStringSet.noInternetConnection.localizedString, subtitle: nil, image: EkoIconSet.noInternetConnection)
        tableView.actionHandler = { [weak self] settingsItem in
            self?.handleActionItem(settingsItem: settingsItem)
        }
    }
    
    private func handleActionItem(settingsItem: EkoSettingsItem) {
        switch settingsItem {
        case .toggleContent(let content):
            if content.isToggled {
                screenViewModel.action.enableNotificationSetting()
            } else {
                screenViewModel.action.disableNotificationSetting()
            }
        case .navigationContent(let content):
            guard let item = EkoCommunityNotificationSettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .mainToggle:
                assertionFailure("Item type must be a navigation type")
            case .postNavigation:
                let vc = EkoPostNotificationSettingsViewController.make(communityId: screenViewModel.community.communityId, type: .post)
                navigationController?.pushViewController(vc, animated: true)
            case .commentNavigation:
                let vc = EkoPostNotificationSettingsViewController.make(communityId: screenViewModel.community.communityId, type: .comment)
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}

extension EkoCommunityNotificationSettingsViewController: EkoCommunityNotificationSettingsViewModelDelegate {
    func screenViewModel(_ viewModel: EkoCommunityNotificationSettingsScreenViewModelType, didUpdateSettingItem settings: [EkoSettingsItem]) {
        tableView.settingsItems = settings
    }
    
    func screenViewModel(_ viewModel: EkoCommunityNotificationSettingsScreenViewModelType, didUpdateLoadingState state: EkoLoadingState) {
        switch state {
        case .loading:
            tableView.showLoadingIndicator()
        case .loaded:
            tableView.tableFooterView = nil
        case .initial:
            break
        }
    }
    
    func screenViewModel(_ viewModel: EkoCommunityNotificationSettingsScreenViewModelType, didFailWithError error: EkoError) {
        
        EkoHUD.hide { [weak self] in
            guard let strongSelf = self else { return }
            let title = strongSelf.screenViewModel.dataSource.isNotificationEnabled ? EkoLocalizedStringSet.CommunitySettings.alertFailTitleTurnNotificationOn.localizedString :  EkoLocalizedStringSet.CommunitySettings.alertFailTitleTurnNotificationOff.localizedString
            EkoAlertController.present(title: title,
                                       message: EkoLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                       actions: [.ok(handler: nil)], from: strongSelf)
        }
    }
}
