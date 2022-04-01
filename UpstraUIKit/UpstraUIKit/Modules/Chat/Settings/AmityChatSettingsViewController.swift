//
//  ChatSettingViewController.swift
//  AmityUIKit
//
//  Created by min khant on 05/05/2021.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

final class AmityChatSettingsViewController: AmityViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var screenViewModel: AmityChatSettingsScreenViewModelType!
    
    static func make(channelId: String) -> AmityViewController {
        let vc = AmityChatSettingsViewController(
            nibName: AmityChatSettingsViewController.identifier,
            bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = AmityChatSettingsScreenViewModel(channelId: channelId)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
    }
    
    private func setUpView() {
        title = screenViewModel.dataSource.title()
        screenViewModel.delegate  = self
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(AmitySettingsItemNavigationContentTableViewCell.nib,
                           forCellReuseIdentifier: AmitySettingsItemNavigationContentTableViewCell.identifier)
        tableView.register(AmitySettingsItemTextContentTableViewCell.nib,
                           forCellReuseIdentifier: AmitySettingsItemTextContentTableViewCell.identifier)
    }
}

extension AmityChatSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch screenViewModel.dataSource.getOption(with: indexPath.row) {
        case .leave, .report(let _) :
            let cell = tableView.dequeueReusableCell(withIdentifier: AmitySettingsItemTextContentTableViewCell.identifier) as! AmitySettingsItemTextContentTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: AmitySettingsItemNavigationContentTableViewCell.identifier) as! AmitySettingsItemNavigationContentTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch screenViewModel.dataSource.getOption(with: indexPath.row) {
        case .leave, .report(let _):
            if let cell = cell as? AmitySettingsItemTextContentTableViewCell {
                let item = AmitySettingsItem.TextContent(identifier: "",
                                                         icon: screenViewModel.dataSource.getOptionImage(with: indexPath.row),
                                                         title: screenViewModel.dataSource.getOptionTitle(with: indexPath.row),
                                                         description: "",
                                                         titleTextColor: screenViewModel.dataSource.getOptionTextColor(with: indexPath.row))
                cell.display(content: item)
            }
        case .members:
            if let cell = cell as? AmitySettingsItemNavigationContentTableViewCell {
                let item = AmitySettingsItem.NavigationContent(identifier: "", icon: screenViewModel.dataSource.getOptionImage(with: indexPath.row),
                                                               title: screenViewModel.dataSource.getOptionTitle(with: indexPath.row),
                                                               description: screenViewModel.dataSource.getMemberCount())
                cell.display(content: item)
            }
        default:
            if let cell = cell as? AmitySettingsItemNavigationContentTableViewCell {
                let item = AmitySettingsItem.NavigationContent(identifier: "", icon: screenViewModel.dataSource.getOptionImage(with: indexPath.row),
                                                               title: screenViewModel.dataSource.getOptionTitle(with: indexPath.row),
                                                               description: "")
                cell.display(content: item)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.getNumberOfItems()
    }
    
}

extension AmityChatSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch screenViewModel.dataSource.getOption(with: indexPath.row) {
        case .leave:
            let cancelAction = AmityAlertController.Action.cancel(style: .cancel, handler: {
                self.dismiss(animated: true, completion: nil)
            })
            let leaveAction = AmityAlertController.Action.custom(
                title: AmityLocalizedStringSet.ChatSettings.leaveChatTitle.localizedString,
                style: .destructive,
                handler: {
                    AmityHUD.show(HUDContentType.loading)
                    self.screenViewModel.action.didClickCell(index: indexPath.row)
                })
            AmityAlertController.present(
                title: AmityLocalizedStringSet.ChatSettings.leaveChatTitle.localizedString,
                message: AmityLocalizedStringSet.ChatSettings.leaveChatMessage.localizedString,
                                         actions: [cancelAction, leaveAction],
                                         from: self)
        case .report(let _):
            AmityHUD.show(.loading)
            screenViewModel.action.didClickCell(index: indexPath.row)
        default:
            screenViewModel.action.didClickCell(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension AmityChatSettingsViewController: AmityChatSettingsScreenViewModelDelegate {
    func screenViewModelDidFinishReport(error: String?) {
        if let error = error {
            AmityHUD.show(.error(message: error))
        } else {
            AmityHUD.show(.success(message: AmityLocalizedStringSet.HUD.reportSent.localizedString))
        }
        tableView.reloadData()
    }
    
    func screenViewmodelDidPresentGroupDetail(channelId: String) {
        let vc = AmityGroupChatEditViewController.make(channelId: channelId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func screenViewModelDidFinishLeaveChat(error: String?) {
        if let error = error {
            AmityHUD.show(.error(message: error))
        } else {
            AmityChannelEventHandler.shared.channelDidLeaveSuccess(from: self)
        }
    }
    
    func screenViewModelDidUpdate(viewModel: AmityChatSettingsScreenViewModel) {
        AmityHUD.hide({
            self.tableView.reloadData()
        })
    }
    
    func screenViewModelDidPresentMember(channel: AmityChannelModel) {
        let vc = AmityChannelMemberSettingsViewController.make(channel: channel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
