//
//  AmityPostReviewSettingsViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPostReviewSettingsViewController: AmityViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var settingTableView: AmitySettingsItemTableView!
    
    // MARK: - Properties
    private var screenViewModel: AmityPostReviewSettingsScreenViewModelType!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setupSettingsItems()
    }
    
    static func make(communityId: String) -> AmityPostReviewSettingsViewController {
        let viewModel = AmityPostReviewSettingsScreenViewModel(communityId: communityId)
        let vc = AmityPostReviewSettingsViewController(nibName: AmityPostReviewSettingsViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Setup view
    private func setupView() {
        title = AmityLocalizedStringSet.PostReviewSettings.title.localizedString
    }
    
    private func setupViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.getCommunity()
    }
    
    private func setupSettingsItems() {
        settingTableView.actionHandler = { [weak self] settingsItem in
            self?.handleActionItem(settingsItem: settingsItem)
        }
    }
    
    private func handleActionItem(settingsItem: AmitySettingsItem) {
        switch settingsItem {
        case .toggleContent(let content):
            guard let item = AmityPostReviewSettingsItem(rawValue: content.identifier) else { return }
            switch item {
            case .approveMemberPost:
                if !content.isToggled {
                    screenViewModel.action.turnOffApproveMemberPost(content: content)
                } else {
                    screenViewModel.action.turnOnApproveMemberPost(content: content)
                }
            }
        default:
            break
        }
    }
}

extension AmityPostReviewSettingsViewController: AmityPostReviewSettingsScreenViewModelDelegate {
    func screenViewModel(_ viewModel: AmityPostReviewSettingsScreenViewModelType, didFinishWithAction action: AmityPostReviewSettingsAction) {
        switch action {
        case .showMenu(let settingItem):
            settingTableView.settingsItems = settingItem
        case .turnOnApproveMemberPost(let content):
            content.isToggled = true
        case .turnOffApproveMemberPost(let content):
            AmityHUD.show(.success(message: AmityLocalizedStringSet.PostReviewSettings.hudTitleTurnOffPostReview.localizedString))
            content.isToggled = false
        }
    }
    
    func screenViewModel(_ viewModel: AmityPostReviewSettingsScreenViewModelType, didFailWithAction action: AmityPostReviewSettingsAction) {
        switch action {
        case .turnOnApproveMemberPost(let content):
            AmityAlertController.present(title: AmityLocalizedStringSet.PostReviewSettings.alertFailTitleTurnOn.localizedString,
                                         message: AmityLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                         actions: [.ok(handler: {
                                            content.isToggled = false
                                         })],
                                         from: self)
        case .turnOffApproveMemberPost(let content):
            AmityAlertController.present(title: AmityLocalizedStringSet.PostReviewSettings.alertFailTitleTurnOff.localizedString,
                                         message: AmityLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                         actions: [.ok(handler: {
                                            content.isToggled = true
                                         })],
                                         from: self)
        default:
            break
        }
    }
    
    func screenViewModel(_ viewModel: AmityPostReviewSettingsScreenViewModelType, didFailWithError error: AmityError) {
        
    }
}
