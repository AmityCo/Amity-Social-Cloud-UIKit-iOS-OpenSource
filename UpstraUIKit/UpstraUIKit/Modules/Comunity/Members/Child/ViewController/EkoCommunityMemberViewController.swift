//
//  EkoCommunityMemberViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

enum EkoCommunityMemberViewType {
    case moderator, member
}

extension EkoCommunityMemberViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: EkoPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
}

class EkoCommunityMemberViewController: EkoViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private var pageTitle: String!
    private var screenViewModel: EkoCommunityMemberScreenViewModelType!
    private var viewType: EkoCommunityMemberViewType = .member
    var didGetMemberHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        screenViewModel.action.getMember(viewType: viewType)
    }
    
    static func make(pageTitle: String,
                     viewType: EkoCommunityMemberViewType,
                     community: EkoCommunityModel) -> EkoCommunityMemberViewController {
        let fetchMemberController = EkoCommunityFetchMemberController(communityId: community.communityId)
        let removeMemberController = EkoCommunityRemoveMemberController(communityId: community.communityId)
        let addMemberController = EkoCommunityAddMemberController(communityId: community.communityId)
        let roleController = EkoCommunityRoleController(communityId: community.communityId)
        let viewModel: EkoCommunityMemberScreenViewModelType = EkoCommunityMemberScreenViewModel(community: community,
                                                                                                 fetchMemberController: fetchMemberController,
                                                                                                 removeMemberController: removeMemberController,
                                                                                                 addMemberController: addMemberController,
                                                                                                 roleController: roleController)
        let vc = EkoCommunityMemberViewController(nibName: EkoCommunityMemberViewController.identifier,
                                                  bundle: UpstraUIKitManager.bundle)
        vc.pageTitle = pageTitle
        vc.screenViewModel = viewModel
        vc.viewType = viewType
        return vc
    }

    func addMember(users: [EkoSelectMemberModel]) {
        screenViewModel.action.addUser(users: users)
    }
    
    func passMember() -> [EkoSelectMemberModel] {
        return screenViewModel.dataSource.prepareData()
    }
}

// MARK: - Setup view
private extension EkoCommunityMemberViewController {
    func setupView() {
        screenViewModel.delegate = self
        view.backgroundColor = EkoColorSet.backgroundColor
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(EkoCommunityMemberSettingsTableViewCell.nib, forCellReuseIdentifier: EkoCommunityMemberSettingsTableViewCell.identifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = EkoColorSet.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableView Delegate
extension EkoCommunityMemberViewController: UITableViewDelegate {
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
extension EkoCommunityMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfMembers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EkoCommunityMemberSettingsTableViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoCommunityMemberSettingsTableViewCell {
            let member = screenViewModel.dataSource.member(at: indexPath)
            cell.display(with: member, isJoined: screenViewModel.dataSource.community.isJoined)
            cell.setIndexPath(with: indexPath)
            cell.delegate = self
        }
    }
}

extension EkoCommunityMemberViewController: EkoCommunityMemberScreenViewModelDelegate {
    
    func screenViewModelDidGetMember() {
        tableView.reloadData()
        didGetMemberHandler?()
    }
    
    func screenViewModel(_ viewModel: EkoCommunityMemberScreenViewModel, loadingState state: EkoLoadingState) {
        switch state {
        case .loading:
            tableView.showLoadingIndicator()
        case .loaded:
            tableView.tableFooterView = nil
        case .initial:
            break
        }
    }
    
    func screenViewModel(_ viewModel: EkoCommunityMemberScreenViewModel, didRemoveUserAt indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func screenViewModelDidAddMemberSuccess() {
        EkoHUD.hide()
    }
    
    func screenViewModelDidAddRoleSuccess() {
        EkoHUD.hide()
    }
    
    func screenViewModelDidRemoveRoleSuccess() {
        EkoHUD.hide()
    }
    
    func screenViewModel(_ viewModel: EkoCommunityMemberScreenViewModel, failure error: EkoError) {
        EkoHUD.hide { [weak self] in
            switch error {
            case .noPermission:
                let alert = UIAlertController(title: EkoLocalizedStringSet.Community.alertUnableToPerformActionTitle.localizedString, message: EkoLocalizedStringSet.Community.alertUnableToPerformActionDesc.localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.ok.localizedString, style: .default, handler: { _ in
                    self?.navigationController?.popToRootViewController(animated: true)
                }))
                self?.present(alert, animated: true, completion: nil)
            default:
                EkoHUD.show(.error(message: EkoLocalizedStringSet.HUD.somethingWentWrong.localizedString))
            }
        }
    }
}

extension EkoCommunityMemberViewController: EkoCommunityMemberSettingsTableViewCellDelegate {
    func didPerformAction(at indexPath: IndexPath, action: EkoCommunityMemberAction) {
        switch action {
        case .tapAvatar, .tapDisplayName:
            let member = screenViewModel.dataSource.member(at: indexPath)
            EkoEventHandler.shared.userDidTap(from: self, userId: member.userId)
        case .tapOption:
            openOptionsBottomSheet(for: indexPath)
        }
    }
}

// MARK:- Private Methods
private extension EkoCommunityMemberViewController {
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
                    if !member.isModerator {
                        let addRoleOption = TextItemOption(title: EkoLocalizedStringSet.CommunityMembreSetting.optionPromoteToModerator.localizedString) {
                            EkoHUD.show(.loading)
                            strongSelf.screenViewModel.action.addRole(at: indexPath)
                        }
                        options.append(addRoleOption)
                    }
                case .moderator:
                    let removeRoleOption = TextItemOption(title: EkoLocalizedStringSet.CommunityMembreSetting.optionDismissModerator.localizedString) {
                        EkoHUD.show(.loading)
                        strongSelf.screenViewModel.action.removeRole(at: indexPath)
                    }
                    options.append(removeRoleOption)
                }
                
                let removeOption = TextItemOption(title: EkoLocalizedStringSet.CommunityMembreSetting.optionRemove.localizedString, textColor: EkoColorSet.alert) {
                    let alert = UIAlertController(title: EkoLocalizedStringSet.CommunityMembreSetting.alertTitle.localizedString,
                                                  message: EkoLocalizedStringSet.CommunityMembreSetting.alertDesc.localizedString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.remove.localizedString, style: .destructive, handler: { _ in
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
                    option = TextItemOption(title: EkoLocalizedStringSet.General.undoReport.localizedString) {
                        strongSelf.screenViewModel.action.unreportUser(at: indexPath)
                    }
                } else {
                    // report option
                    option = TextItemOption(title: EkoLocalizedStringSet.General.report.localizedString) {
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
