//
//  AmityUserSettingsViewController.swift
//  AmityUIKit
//
//  Created by Hamlet on 28.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

final class AmityUserSettingsViewController: AmityViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var settingTableView: AmitySettingsItemTableView!
    
    // MARK: - Properties
    private var screenViewModel: AmityUserSettingsScreenViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenViewModel.delegate = self
        setupView()
        setupSettingTableView()
        screenViewModel.action.fetchUserSettings()
    }
    
    static func make(withUserId userId: String)->  AmityUserSettingsViewController{
        let userNotificationController = AmityUserNotificationSettingsController()
        let viewModel: AmityUserSettingsScreenViewModelType = AmityUserSettingsScreenViewModel(userId: userId, userNotificationController: userNotificationController)
        
        let vc = AmityUserSettingsViewController(nibName: AmityUserSettingsViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Setup view
    private func setupView() {
        view.backgroundColor = AmityColorSet.backgroundColor
        title = AmityLocalizedStringSet.General.settings.localizedString
    }
    
    private func setupSettingTableView() {
        settingTableView.actionHandler = { [weak self] settingsItem in
            self?.handleActionItem(settingsItem: settingsItem)
        }
    }
    
    private func handleActionItem(settingsItem: AmitySettingsItem) {
        switch settingsItem {
        case .textContent(let content):
            guard let item = AmityUserSettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .unfollow:
                let userName = screenViewModel?.dataSource.user?.displayName ?? ""
                let alertTitle = "\(AmityLocalizedStringSet.UserSettings.itemUnfollow.localizedString) \(userName)"
                
                let message = String.localizedStringWithFormat(AmityLocalizedStringSet.UserSettings.UserSettingsMessages.unfollowMessage.localizedString, userName)
                
                AmityAlertController.present(
                    title: alertTitle,
                    message: message,
                    actions: [.cancel(handler: nil),
                              .custom(title: AmityLocalizedStringSet.UserSettings.itemUnfollow.localizedString,
                                      style: .destructive, handler: { [weak self] in
                                          self?.screenViewModel.performAction(settingsItem: .unfollow)
                                      })],
                    from: self)
            case .blockUser, .unblockUser, .report, .unreport:
                screenViewModel.action.performAction(settingsItem: item)
            case .basicInfo, .manage, .editProfile:
                break
            }
        case .navigationContent(let content):
            guard let item = AmityUserSettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .editProfile:
                AmityEventHandler.shared.editUserDidTap(from: self, userId: screenViewModel.dataSource.userId)
            case .basicInfo, .manage, .report, .unfollow, .unreport, .blockUser, .unblockUser:
                break
            }
        default: break
        }
    }
}

extension AmityUserSettingsViewController: AmityUserSettingsScreenViewModelDelegate {
    
    func screenViewModel(_ viewModel: AmityUserSettingsScreenViewModelType, didGetSettingMenu settings: [AmitySettingsItem]) {
        settingTableView.settingsItems = settings
    }
    
    func screenViewModelDidUnfollowUserFail() {
        let userName = screenViewModel?.dataSource.user?.displayName ?? ""
        let title = String.localizedStringWithFormat(AmityLocalizedStringSet.UserSettings.UserSettingsMessages.unfollowFailTitle.localizedString, userName)
        AmityAlertController.present(title: title,
                                     message: AmityLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                     actions: [.ok(handler: nil)], from: self)
    }
    
    func screenViewModel(_ viewModel: AmityUserSettingsScreenViewModelType, failure error: AmityError) {
        switch error {
        case .unknown:
            AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
        default:
            break
        }
    }
    
    // Handle action completion
    func screenViewModel(_ viewModel: AmityUserSettingsScreenViewModelType, didCompleteAction action: AmityUserSettingsItem, error: AmityError?) {
        
        // Handle action completion here
        switch action {
        case .unfollow:
            if let _ = error {
                let userName = screenViewModel?.dataSource.user?.displayName ?? ""
                let title = String.localizedStringWithFormat(AmityLocalizedStringSet.UserSettings.UserSettingsMessages.unfollowFailTitle.localizedString, userName)
                AmityAlertController.present(title: title, message: AmityLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString, actions: [.ok(handler: nil)], from: self)
            }
        case .report, .unreport:
            let successMessage = action == .report ? AmityLocalizedStringSet.HUD.reportSent.localizedString : AmityLocalizedStringSet.HUD.unreportSent.localizedString
            
            if let _ = error {
                self.displayDefaultErrorHUD()
            } else {
                AmityHUD.show(.success(message: successMessage))
            }
            
        case .basicInfo, .manage, .editProfile:
            break
        case .blockUser, .unblockUser:
            let successMessage = action == .blockUser ? AmityLocalizedStringSet.UserSettings.UserSettingsMessages.blockUserSuccess.localizedString : AmityLocalizedStringSet.UserSettings.UserSettingsMessages.unblockUserSuccess.localizedString
            let failureMessage = action == .blockUser ? AmityLocalizedStringSet.UserSettings.UserSettingsMessages.blockUserFailedTitle.localizedString : AmityLocalizedStringSet.UserSettings.UserSettingsMessages.unblockUserFailedTitle.localizedString
            
            if let _ = error {
                AmityHUD.show(.error(message: failureMessage))
            } else {
                AmityHUD.show(.success(message: successMessage))
            }
        }
    }
    
    func displayDefaultErrorHUD() {
        AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
    }
}
