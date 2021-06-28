//
//  AmityPostNotificationSettingsViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

class AmityPostNotificationSettingsViewController: EkoViewController {
    
    private let tableView = AmitySettingsItemTableView()
    private var screenViewModel: AmityPostNotificationSettingsScreenViewModelType!
    private var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupViewModel()
    }
    
    static func make(communityId: String, type: AmityCommunityNotificationSettingsType) -> AmityPostNotificationSettingsViewController {
        let userNotificationController = AmityUserNotificationSettingsController()
        let communityNotificationController = AmityCommunityNotificationSettingsController(withCommunityId: communityId)
        let screenViewModel = EkoSocialNotificationSettingsScreenViewModel(
            userNotificationController: userNotificationController,
            communityNotificationController: communityNotificationController,
            type: type)
        
        let vc = AmityPostNotificationSettingsViewController()
        vc.screenViewModel = screenViewModel
        return vc
    }
    
    private func setupView() {
        title = screenViewModel.type == .post ? AmityLocalizedStringSet.CommunityNotificationSettings.post.localizedString : AmityLocalizedStringSet.CommunityNotificationSettings.comment.localizedString
        saveButton = UIBarButtonItem(title: AmityLocalizedStringSet.save.localizedString, style: .done, target: self, action: #selector(saveButtonDidTap))
        saveButton.isEnabled = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.isEmptyViewHidden = Reachability.isConnectedToNetwork()
        tableView.updateEmptyView(title: AmityLocalizedStringSet.noInternetConnection.localizedString, subtitle: nil, image: EkoIconSet.noInternetConnection)
        
        tableView.actionHandler = { [weak self] settingsItem in
            self?.handleActionItem(settingsItem: settingsItem)
        }
    }
    
    private func setupViewModel() {
        screenViewModel.delegate = self
        screenViewModel.retrieveNotifcationSettings()
    }
    
    @objc private func saveButtonDidTap() {
        EkoHUD.show(.loading)
        screenViewModel.action.saveNotificationSettings()
    }
    
    private func handleActionItem(settingsItem: AmitySettingsItem) {
        switch settingsItem {
        case .radioButtonContent(let content):
            guard let setting = CommunityNotificationSettingItem.settingItem(for: content.identifier) else  {
                return
            }
            switch setting.menu {
            case .description, .separator:
                break
            case .option(let option):
                screenViewModel.updateSetting(setting: setting.event, option: option)
            }
        default:
            break
        }
    }
}

extension AmityPostNotificationSettingsViewController: EkoSocialNotificationSettingsScreenViewModelDelgate {
    
    func screenViewModel(_ viewModel: EkoSocialNotificationSettingsScreenViewModel, didReceiveSettingItems items: [AmitySettingsItem]) {
        tableView.settingsItems = items
        saveButton.isEnabled = screenViewModel.dataSource.isValueChanged
        navigationItem.rightBarButtonItem = items.count > 0 ? saveButton : nil
    }
    
    func screenViewModelDidUpdateSettingSuccess(_ viewModel: EkoSocialNotificationSettingsScreenViewModel) {
        AmityHUD.show(.success(message: AmityLocalizedStringSet.saved.localizedString))
    }
    
    func screenViewModel(_ viewModel: EkoSocialNotificationSettingsScreenViewModel, didUpdateSettingFailWithError error: EkoError) {
        AmityHUD.hide { [weak self] in
            switch error {
            case .noPermission:
                guard let self = self else { return }
                EkoAlertController.present(
                    title: AmityLocalizedStringSet.Community.alertUnableToPerformActionTitle.localizedString,
                    message: AmityLocalizedStringSet.Community.alertUnableToPerformActionDesc.localizedString,
                    actions: [.custom(title: AmityLocalizedStringSet.ok.localizedString, style: .default, handler: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })],
                    from: self)
            default:
                AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
            }
        }
    }
    
}
