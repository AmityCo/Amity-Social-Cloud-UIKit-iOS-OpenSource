//
//  EkoPostReviewSettingsViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

final class EkoPostReviewSettingsViewController: EkoViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var settingTableView: EkoSettingsItemTableView!
    
    // MARK: - Properties
    private var screenViewModel: EkoPostReviewSettingsScreenViewModelType!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setupSettingsItems()
    }
    
    static func make() -> EkoPostReviewSettingsViewController {
        let viewModel = EkoPostReviewSettingsScreenViewModel()
        let vc = EkoPostReviewSettingsViewController(nibName: EkoPostReviewSettingsViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Setup view
    private func setupView() {
        title = EkoLocalizedStringSet.PostReviewSettings.title.localizedString
    }
    
    private func setupViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.retrieveMenu()
    }
    
    private func setupSettingsItems() {
        settingTableView.actionHandler = { [weak self] settingsItem in
            self?.handleActionItem(settingsItem: settingsItem)
        }
    }
    
    private func handleActionItem(settingsItem: EkoSettingsItem) {
        switch settingsItem {
        case .toggleContent(let content):
            guard let item = EkoPostReviewSettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .approveMemberPost:
                if content.isToggled {
                    EkoAlertController.present(title: EkoLocalizedStringSet.PostReviewSettings.alertTitleTurnOffPostReview.localizedString,
                                               message: EkoLocalizedStringSet.PostReviewSettings.alertDescTurnOffPostReview.localizedString,
                                               actions: [.cancel(handler: {
                                                content.isToggled = true
                                               }),
                                               .custom(title: EkoLocalizedStringSet.turnOff.localizedString,
                                                       style: .destructive,
                                                       handler: { [weak self] in
                                                        self?.screenViewModel.action.turnOffApproveMemberPost(content: content)
                                                       })
                                               ],
                                               from: self)
                } else {
                    screenViewModel.action.turnOnApproveMemberPost(content: content)
                }
            }
        default:
            break
        }
    }
}

extension EkoPostReviewSettingsViewController: EkoPostReviewSettingsScreenViewModelDelegate {
    func screenViewModel(_ viewModel: EkoPostReviewSettingsScreenViewModelType, didFinishWithAction action: EkoPostReviewSettingsAction) {
        switch action {
        case .retrieveMenu(let settingItem):
            settingTableView.settingsItems = settingItem
        case .turnOnApproveMemberPost(let content):
            content.isToggled = true
        case .turnOffApproveMemberPost(let content):
            EkoHUD.show(.success(message: EkoLocalizedStringSet.PostReviewSettings.hudTitleTurnOffPostReview.localizedString))
            content.isToggled = false
        }
    }
    
    func screenViewModel(_ viewModel: EkoPostReviewSettingsScreenViewModelType, didFailWithAction action: EkoPostReviewSettingsAction) {
        switch action {
        case .turnOnApproveMemberPost:
            EkoAlertController.present(title: EkoLocalizedStringSet.PostReviewSettings.alertFailTitleTurnOn.localizedString,
                                       message: EkoLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                       actions: [.ok(handler: nil)],
                                       from: self)
        case .turnOffApproveMemberPost:
            EkoAlertController.present(title: EkoLocalizedStringSet.PostReviewSettings.alertFailTitleTurnOff.localizedString,
                                       message: EkoLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                       actions: [.ok(handler: nil)],
                                       from: self)
        default:
            break
        }
    }
    
    func screenViewModel(_ viewModel: EkoPostReviewSettingsScreenViewModelType, didFailWithError error: EkoError) {
        
    }
}
