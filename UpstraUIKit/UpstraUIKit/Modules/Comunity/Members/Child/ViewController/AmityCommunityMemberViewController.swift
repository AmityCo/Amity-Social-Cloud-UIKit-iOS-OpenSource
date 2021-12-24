//
//  AmityCommunityMemberViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityCommunityMemberViewType {
    case moderator, member
}

extension AmityCommunityMemberViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: AmityPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
}

class AmityCommunityMemberViewController: AmityViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private var pageTitle: String!
    private var screenViewModel: AmityCommunityMemberScreenViewModelType!
    private var viewType: AmityCommunityMemberViewType = .member
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        screenViewModel.action.getMember(viewType: viewType)
    }
    
    static func make(pageTitle: String,
                     viewType: AmityCommunityMemberViewType,
                     community: AmityCommunityModel) -> AmityCommunityMemberViewController {
        let fetchMemberController = AmityCommunityFetchMemberController(communityId: community.communityId)
        let removeMemberController = AmityCommunityRemoveMemberController(communityId: community.communityId)
        let addMemberController = AmityCommunityAddMemberController(communityId: community.communityId)
        let roleController = AmityCommunityRoleController(communityId: community.communityId)
        let viewModel: AmityCommunityMemberScreenViewModelType = AmityCommunityMemberScreenViewModel(community: community,
                                                                                                 fetchMemberController: fetchMemberController,
                                                                                                 removeMemberController: removeMemberController,
                                                                                                 addMemberController: addMemberController,
                                                                                                 roleController: roleController)
        let vc = AmityCommunityMemberViewController(nibName: AmityCommunityMemberViewController.identifier,
                                                  bundle: AmityUIKitManager.bundle)
        vc.pageTitle = pageTitle
        vc.screenViewModel = viewModel
        vc.viewType = viewType
        return vc
    }

    func addMember(users: [AmitySelectMemberModel]) {
        screenViewModel.action.addUser(users: users)
    }
    
    func passMember() -> [AmitySelectMemberModel] {
        return screenViewModel.dataSource.prepareData()
    }
}

// MARK: - Setup view
private extension AmityCommunityMemberViewController {
    func setupView() {
        screenViewModel.delegate = self
        view.backgroundColor = AmityColorSet.backgroundColor
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(AmityCommunityMemberSettingsTableViewCell.nib, forCellReuseIdentifier: AmityCommunityMemberSettingsTableViewCell.identifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = AmityColorSet.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableView Delegate
extension AmityCommunityMemberViewController: UITableViewDelegate {
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
extension AmityCommunityMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfMembers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AmityCommunityMemberSettingsTableViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? AmityCommunityMemberSettingsTableViewCell {
            let member = screenViewModel.dataSource.member(at: indexPath)
            cell.display(with: member, isJoined: screenViewModel.dataSource.community.isJoined)
            cell.setIndexPath(with: indexPath)
            cell.delegate = self
        }
    }
}

extension AmityCommunityMemberViewController: AmityCommunityMemberScreenViewModelDelegate {
    
    func screenViewModelDidGetMember() {
        tableView.reloadData()
    }
    
    func screenViewModel(_ viewModel: AmityCommunityMemberScreenViewModel, loadingState state: AmityLoadingState) {
        switch state {
        case .loading:
            tableView.showLoadingIndicator()
        case .loaded:
            tableView.tableFooterView = nil
        case .initial:
            break
        }
    }
    
    func screenViewModel(_ viewModel: AmityCommunityMemberScreenViewModel, didRemoveUserAt indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func screenViewModelDidAddMemberSuccess() {
        AmityHUD.hide()
    }
    
    func screenViewModelDidAddRoleSuccess() {
        AmityHUD.hide()
    }
    
    func screenViewModelDidRemoveRoleSuccess() {
        AmityHUD.hide()
    }
    
    func screenViewModel(_ viewModel: AmityCommunityMemberScreenViewModel, failure error: AmityError) {
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
}

extension AmityCommunityMemberViewController: AmityCommunityMemberSettingsTableViewCellDelegate {
    func didPerformAction(at indexPath: IndexPath, action: AmityCommunityMemberAction) {
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
private extension AmityCommunityMemberViewController {
    func openOptionsBottomSheet(for indexPath: IndexPath) {
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<TextItemOption>()
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        var options: [TextItemOption] = []
        
        screenViewModel.dataSource.getCommunityEditUserPermission { [weak self] (hasPermission) in
            guard let strongSelf = self else { return }
            // remove user options
            if hasPermission {
                let member = strongSelf.screenViewModel.dataSource.member(at: indexPath)
                switch strongSelf.viewType {
                case .member:
                    if !member.isModerator && !member.isGlobalBan {
                        let addRoleOption = TextItemOption(title: AmityLocalizedStringSet.CommunityMembreSetting.optionPromoteToModerator.localizedString) {
                            AmityHUD.show(.loading)
                            strongSelf.screenViewModel.action.addRole(at: indexPath)
                        }
                        options.append(addRoleOption)
                    }
                case .moderator:
                    let removeRoleOption = TextItemOption(title: AmityLocalizedStringSet.CommunityMembreSetting.optionDismissModerator.localizedString) {
                        AmityHUD.show(.loading)
                        strongSelf.screenViewModel.action.removeRole(at: indexPath)
                    }
                    options.append(removeRoleOption)
                }
                
                let removeOption = TextItemOption(title: AmityLocalizedStringSet.CommunityMembreSetting.optionRemove.localizedString, textColor: AmityColorSet.alert) {
                    let alert = UIAlertController(title: AmityLocalizedStringSet.CommunityMembreSetting.alertTitle.localizedString,
                                                  message: AmityLocalizedStringSet.CommunityMembreSetting.alertDesc.localizedString, preferredStyle: .alert)
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
