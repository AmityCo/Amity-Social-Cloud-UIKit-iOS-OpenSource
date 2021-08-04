//
//  AmityChannelMemberViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityChannelMemberViewType {
    case moderator, member
}

extension AmityChannelMemberViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: AmityPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
}

class AmityChannelMemberViewController: AmityViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    private var pageTitle: String!
    private var screenViewModel: AmityChannelMemberScreenViewModelType!
    private var viewType: AmityChannelMemberViewType = .member
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchBar()
        screenViewModel.action.getMember(viewType: viewType)
    }
    
    static func make(pageTitle: String,
                     viewType: AmityChannelMemberViewType,
                     channel: AmityChannelModel) -> AmityChannelMemberViewController {
        let fetchMemberController = AmityChannelFetchMemberController(channelId: channel.channelId)
        let removeMemberController = AmityChannelRemoveMemberController(channelId: channel.channelId)
        let addMemberController = AmityChannelAddMemberController(channelId: channel.channelId)
        let roleController = AmityChannelRoleController(channelId: channel.channelId)
        let viewModel: AmityChannelMemberScreenViewModelType = AmityChannelMemberScreenViewModel(channel: channel,
                                                                                                 fetchMemberController: fetchMemberController,
                                                                                                 removeMemberController: removeMemberController,
                                                                                                 addMemberController: addMemberController,
                                                                                                 roleController: roleController)
        let vc = AmityChannelMemberViewController(nibName: AmityChannelMemberViewController.identifier,
                                                  bundle: AmityUIKitManager.bundle)
        vc.pageTitle = pageTitle
        vc.screenViewModel = viewModel
        vc.viewType = viewType
        return vc
    }
    
    private func setupSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.tintColor = AmityColorSet.base
        searchBar.returnKeyType = .done
        (searchBar.value(forKey: "searchField") as? UITextField)?.textColor = AmityColorSet.base
        ((searchBar.value(forKey: "searchField") as? UITextField)?.leftView as? UIImageView)?.tintColor = AmityColorSet.base.blend(.shade2)
    }

    func addMember(users: [AmitySelectMemberModel]) {
        screenViewModel.action.addUser(users: users)
    }
    
    func passMember() -> [AmitySelectMemberModel] {
        return screenViewModel.dataSource.prepareData()
    }
}

// MARK: - Setup view
private extension AmityChannelMemberViewController {
    func setupView() {
        screenViewModel.delegate = self
        view.backgroundColor = AmityColorSet.backgroundColor
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(AmityChannelMemberSettingsTableViewCell.nib, forCellReuseIdentifier: AmityChannelMemberSettingsTableViewCell.identifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = AmityColorSet.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableView Delegate
extension AmityChannelMemberViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tablbeView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isBottomReached {
            screenViewModel.action.loadMore()
        }
    }
}

// MARK: - UITableView DataSource
extension AmityChannelMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfMembers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AmityChannelMemberSettingsTableViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? AmityChannelMemberSettingsTableViewCell {
            let member = screenViewModel.dataSource.member(at: indexPath)
            cell.display(with: member, isJoined: true)
            cell.setIndexPath(with: indexPath)
            cell.delegate = self
        }
    }
}

extension AmityChannelMemberViewController: AmityChannelMemberScreenViewModelDelegate {
    
    func screenViewModelDidGetMember() {
        tableView.reloadData()
    }
    
    func screenViewModel(_ viewModel: AmityChannelMemberScreenViewModel, loadingState state: AmityLoadingState) {
        switch state {
        case .loading:
            tableView.showLoadingIndicator()
        case .loaded:
            tableView.tableFooterView = nil
        case .initial:
            break
        }
    }
    
    func screenViewModel(_ viewModel: AmityChannelMemberScreenViewModel, didRemoveUserAt indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func screenViewModelDidAddMemberSuccess() {
        AmityHUD.hide()
    }
    
    func screenViewModelDidRemoveMemberSuccess() {
        AmityHUD.hide()
    }
    
    func screenViewModelDidAddRoleSuccess() {
        AmityHUD.hide()
    }
    
    func screenViewModelDidRemoveRoleSuccess() {
        AmityHUD.hide()
    }
    
    func screenViewModel(_ viewModel: AmityChannelMemberScreenViewModel, failure error: AmityError) {
        AmityHUD.hide { [weak self] in
            switch error {
            case .noPermission:
                let alert = UIAlertController(title: AmityLocalizedStringSet.Community.alertUnableToPerformActionTitle.localizedString, message: AmityLocalizedStringSet.Community.alertUnableToPerformActionDesc.localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.ok.localizedString, style: .default, handler: { _ in
                    self?.navigationController?.popToRootViewController(animated: true)
                }))
                self?.present(alert, animated: true, completion: nil)
            default:
                AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
            }
        }
    }

    func screenViewModelDidSearchUser() {
        tableView.reloadData()
    }
}

extension AmityChannelMemberViewController: AmityChannelMemberSettingsTableViewCellDelegate {
    func didPerformAction(at indexPath: IndexPath, action: AmityChannelMemberAction) {
        switch action {
        case .tapAvatar, .tapDisplayName:
            let member = screenViewModel.dataSource.member(at: indexPath)
            AmityEventHandler.shared.userDidTap(from: self, userId: member.userId)
        case .tapOption:
            openOptionsBottomSheet(for: indexPath)
        }
    }
}

// MARK:- Private Methods
private extension AmityChannelMemberViewController {
    func openOptionsBottomSheet(for indexPath: IndexPath) {
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<TextItemOption>()
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        var options: [TextItemOption] = []
        screenViewModel.dataSource.getChannelEditUserPermission { [weak self] (hasPermission) in
            guard let strongSelf = self else { return }
            // remove user options
            if hasPermission {
                let member = strongSelf.screenViewModel.dataSource.member(at: indexPath)
                switch strongSelf.viewType {
                case .member:
                    if !member.isModerator {
                        let addRoleOption = TextItemOption(title: AmityLocalizedStringSet.ChatSettings.promoteToModerator.localizedString) {
                            AmityHUD.show(.loading)
                            strongSelf.screenViewModel.action.addRole(at: indexPath)
                        }
                        options.append(addRoleOption)
                    }
                case .moderator:
                    let removeRoleOption = TextItemOption(title: AmityLocalizedStringSet.ChatSettings.dismissFromModerator.localizedString) {
                        AmityHUD.show(.loading)
                        strongSelf.screenViewModel.action.removeRole(at: indexPath)
                    }
                    options.append(removeRoleOption)
                }

                let removeOption = TextItemOption(title: AmityLocalizedStringSet.ChatSettings.removeFromGroupChat.localizedString, textColor: AmityColorSet.alert) {
                    let alert = UIAlertController(title: AmityLocalizedStringSet.ChatSettings.removeMemberAlertTitle.localizedString,
                                                  message: AmityLocalizedStringSet.ChatSettings.removeMemberAlertBody.localizedString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.remove.localizedString, style: .destructive, handler: { _ in
                        strongSelf.screenViewModel.action.removeUser(at: indexPath)
                    }))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
                options.append(removeOption)
            }

            // report/unreport option
            strongSelf.screenViewModel.dataSource.getReportUserStatus(at: indexPath) { isReported in
                var option: TextItemOption
                if isReported {
                    // unreport option
                    option = TextItemOption(title: AmityLocalizedStringSet.General.undoReport.localizedString) {
                        strongSelf.screenViewModel.action.unreportUser(at: indexPath)
                    }
                } else {
                    // report option
                    option = TextItemOption(title: AmityLocalizedStringSet.General.report.localizedString) {
                        strongSelf.screenViewModel.action.reportUser(at: indexPath)
                    }
                }
                // the options wil show like this below:
                // - Promote moderator/Dismiss moderator
                // - Report/Unreport
                // - Remove from community
                // option 'Remove from community' always show last element

                // if options more than 2 items, the report/unreport option will insert at index 1
                // if options less than 2 items, the report/unreport option will insert at index 0

                options.insert(option, at: options.count > 1 ? 1:0)
                contentView.configure(items: options, selectedItem: nil)
                strongSelf.present(bottomSheet, animated: false, completion: nil)
            }
        }
    }
}

extension AmityChannelMemberViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        screenViewModel.action.searchUser(with: searchText)
    }
}
