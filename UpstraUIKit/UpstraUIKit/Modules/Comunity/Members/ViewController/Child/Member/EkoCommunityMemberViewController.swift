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

class EkoCommunityMemberViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private var pageTitle: String!
    private var screenViewModel: EkoCommunityMemberScreenViewModelType!
    private var viewType: EkoCommunityMemberViewType = .member
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenViewModel.delegate = self
    }
    
    static func make(pageTitle: String,
                     viewType: EkoCommunityMemberViewType,
                     communityId: String) -> EkoCommunityMemberViewController {
        let viewModel: EkoCommunityMemberScreenViewModelType = EkoCommunityMemberScreenViewModel(communityId: communityId)
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

// MARK: - Binding ViewModel
private extension EkoCommunityMemberViewController {
    func bindingViewModel() {
        screenViewModel.action.getCommunity()
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
            cell.display(with: member, isJoined: screenViewModel.dataSource.isJoined())
            cell.setIndexPath(with: indexPath)
            cell.delegate = self
        }
    }
}

extension EkoCommunityMemberViewController: EkoCommunityMemberScreenViewModelDelegate {
    
    func screenViewModelDidGetComminityInfo() {
        screenViewModel.action.getMember(viewType: viewType)
        screenViewModel.action.getUserRoles()
    }
    
    func screenViewModelDidGetMember() {
        tableView.reloadData()
    }
    
    func screenViewModelLoadingState(state: EkoLoadingState) {
        switch state {
        case .loadmore:
            tableView.showLoadingIndicator()
        case .loaded:
            tableView.tableFooterView = nil
        default:
            break
        }
    }
    
    func screenViewModelDidRemoveUser(at indexPath: IndexPath) {
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
    
    func screenViewModelFailure(error: EkoError) {
        EkoHUD.hide {
            switch error {
            case .noPermission:
                EkoHUD.show(.error(message: EkoLocalizedStringSet.HUD.somethingWentWrong))
            case .unknown:
                EkoHUD.show(.error(message: EkoLocalizedStringSet.HUD.somethingWentWrong))
            }
        }
    }
}

extension EkoCommunityMemberViewController: EkoCommunityMemberSettingsTableViewCellDelegate {
    
    func cellDidActionOption(at indexPath: IndexPath) {
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<TextItemOption>()
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        var options: [TextItemOption] = []

        // remove user options
        if screenViewModel.dataSource.isModerator {
            let member = screenViewModel.dataSource.member(at: indexPath)
            switch viewType {
            case .member:
                if !member.isModerator {
                    let addRoleOption = TextItemOption(title: EkoLocalizedStringSet.CommunityMembreSetting.optionPromoteToModerator) { [weak self] in
                        EkoHUD.show(.loading)
                        self?.screenViewModel.action.addRole(at: indexPath)
                    }
                    options.append(addRoleOption)
                }
            case .moderator:
                let removeRoleOption = TextItemOption(title: EkoLocalizedStringSet.CommunityMembreSetting.optionDismissModerator) { [weak self] in
                    EkoHUD.show(.loading)
                    self?.screenViewModel.action.removeRole(at: indexPath)
                }
                options.append(removeRoleOption)
            }
            
            let removeOption = TextItemOption(title: EkoLocalizedStringSet.CommunityMembreSetting.optionRemove, textColor: EkoColorSet.alert) { [weak self] in
                let alert = UIAlertController(title: EkoLocalizedStringSet.CommunityMembreSetting.alertTitle,
                                              message: EkoLocalizedStringSet.CommunityMembreSetting.alertDesc, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.remove, style: .destructive, handler: { _ in
                    self?.screenViewModel.action.removeUser(at: indexPath)
                }))
                self?.present(alert, animated: true, completion: nil)
            }
            options.append(removeOption)
        }
        
        // report/unreport option
        screenViewModel.dataSource.getReportUserStatus(at: indexPath) { [weak self] isReported in
            if isReported {
                let unreportOption = TextItemOption(title: EkoLocalizedStringSet.CommunityMembreSetting.optionUnreport) {
                    self?.screenViewModel.action.unreportUser(at: indexPath)
                }
                options.append(unreportOption)
            } else {
                let reportOption = TextItemOption(title: EkoLocalizedStringSet.CommunityMembreSetting.optionReport) {
                    self?.screenViewModel.action.reportUser(at: indexPath)
                }
                options.append(reportOption)
            }
            contentView.configure(items: options, selectedItem: nil)
            self?.present(bottomSheet, animated: false, completion: nil)
        }
    }
    
}
