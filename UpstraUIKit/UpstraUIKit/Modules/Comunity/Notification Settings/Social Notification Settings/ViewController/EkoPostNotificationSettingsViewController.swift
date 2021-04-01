//
//  EkoPostNotificationSettingsViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

class EkoPostNotificationSettingsViewController: EkoViewController {
    
    private let tableView = EkoSettingsItemTableView()
    private var screenViewModel: EkoPostNotificationSettingsScreenViewModelType!
    private var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupViewModel()
    }
    
    static func make(communityId: String, type: EkoCommunityNotificationSettingsType) -> EkoPostNotificationSettingsViewController {
        let userNotificationController = EkoUserNotificationSettingsController()
        let communityNotificationController = EkoCommunityNotificationSettingsController(withCommunityId: communityId)
        let screenViewModel = EkoSocialNotificationSettingsScreenViewModel(
            userNotificationController: userNotificationController,
            communityNotificationController: communityNotificationController,
            type: type)
        
        let vc = EkoPostNotificationSettingsViewController()
        vc.screenViewModel = screenViewModel
        return vc
    }
    
    private func setupView() {
        title = screenViewModel.type == .post ? EkoLocalizedStringSet.CommunityNotificationSettings.post.localizedString : EkoLocalizedStringSet.CommunityNotificationSettings.comment.localizedString
        saveButton = UIBarButtonItem(title: EkoLocalizedStringSet.save.localizedString, style: .done, target: self, action: #selector(saveButtonDidTap))
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
        tableView.updateEmptyView(title: EkoLocalizedStringSet.noInternetConnection.localizedString, subtitle: nil, image: EkoIconSet.noInternetConnection)
        
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
    
    private func handleActionItem(settingsItem: EkoSettingsItem) {
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

extension EkoPostNotificationSettingsViewController: EkoSocialNotificationSettingsScreenViewModelDelgate {
    
    func screenViewModel(_ viewModel: EkoSocialNotificationSettingsScreenViewModel, didReceiveSettingItems items: [EkoSettingsItem]) {
        tableView.settingsItems = items
        saveButton.isEnabled = screenViewModel.dataSource.isValueChanged
        navigationItem.rightBarButtonItem = items.count > 0 ? saveButton : nil
    }
    
    func screenViewModelDidUpdateSettingSuccess(_ viewModel: EkoSocialNotificationSettingsScreenViewModel) {
        EkoHUD.show(.success(message: EkoLocalizedStringSet.saved.localizedString))
    }
    
    func screenViewModel(_ viewModel: EkoSocialNotificationSettingsScreenViewModel, didUpdateSettingFailWithError error: EkoError) {
        EkoHUD.hide { [weak self] in
            switch error {
            case .noPermission:
                guard let self = self else { return }
                EkoAlertController.present(
                    title: EkoLocalizedStringSet.Community.alertUnableToPerformActionTitle.localizedString,
                    message: EkoLocalizedStringSet.Community.alertUnableToPerformActionDesc.localizedString,
                    actions: [.custom(title: EkoLocalizedStringSet.ok.localizedString, style: .default, handler: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })],
                    from: self)
            default:
                EkoHUD.show(.error(message: EkoLocalizedStringSet.HUD.somethingWentWrong.localizedString))
            }
        }
    }
    
}
