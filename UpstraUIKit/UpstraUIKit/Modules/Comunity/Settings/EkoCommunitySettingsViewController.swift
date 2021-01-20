//
//  EkoCommunitySettingsViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 14/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoCommunitySettingsViewController: EkoViewController {
    
    // MARK: - IBoutlet Properties
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private var screenViewModel: EkoCommunitySettingsScreenViewModelType!
    private var comunitySettingModels: [EkoCommunitySettingsModel] {
        EkoCommunitySettingsModel.prepareData(isCreator: screenViewModel.dataSource.isCreator)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenViewModel.delegate = self
        setupView()
        screenViewModel.action.getCommunity()
    }
    
    static func make(communityId: String) -> EkoCommunitySettingsViewController {
        let viewModel: EkoCommunitySettingsScreenViewModelType = EkoCommunitySettingsScreenViewModel(communityId: communityId)
        let vc = EkoCommunitySettingsViewController(nibName: EkoCommunitySettingsViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
}

// MARK: - Setup view
private extension EkoCommunitySettingsViewController {
    func setupView() {
        view.backgroundColor = EkoColorSet.backgroundColor
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(EkoCommunitySettingsTableViewCell.nib, forCellReuseIdentifier: EkoCommunitySettingsTableViewCell.identifier)
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = EkoColorSet.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableView Delegate
extension EkoCommunitySettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = comunitySettingModels[indexPath.row].type
        switch type {
        case .editProfile:
            let vc = EkoCommunityProfileEditViewController.make(viewType: .edit(communityId: screenViewModel.dataSource.communityId))
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .member:
            let communityId = screenViewModel.dataSource.communityId
            let vc = EkoCommunityMemberSettingsViewController.make(communityId: communityId)
            navigationController?.pushViewController(vc, animated: true)
        case .leave:
            let alertController = UIAlertController(title: EkoLocalizedStringSet.communitySettingsAlertLeaveTitle.localizedString, message: EkoLocalizedStringSet.communitySettingsAlertLeaveDesc.localizedString, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .default, handler: nil))
            alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.leave.localizedString, style: .destructive, handler: { [weak self] action in
                EkoHUD.show(.loading)
                self?.screenViewModel.action.leaveCommunity()
            }))
            present(alertController, animated: true, completion: nil)
        case .close:
            let alertController = UIAlertController(title: EkoLocalizedStringSet.communitySettingsAlertCloseTitle.localizedString, message: EkoLocalizedStringSet.communitySettingsAlertCloseDesc.localizedString, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .default, handler: nil))
            alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.close.localizedString, style: .destructive, handler: { [weak self] action in
                EkoHUD.show(.loading)
                self?.screenViewModel.action.deleteCommunity()
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
    
}

// MARK: - UITableView DataSource
extension EkoCommunitySettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comunitySettingModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EkoCommunitySettingsTableViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoCommunitySettingsTableViewCell {
            cell.display(with: comunitySettingModels[indexPath.row])
        }
    }
    
}

// MARK: - ViewModel Delegate
extension EkoCommunitySettingsViewController: EkoCommunitySettingsScreenViewModelDelegate {
    
    func screenViewModelDidGetCommunitySuccess(community: EkoCommunityModel) {
        title = community.displayName
        tableView.reloadData()
    }
    
    func screenViewModelDidLeaveCommunitySuccess() {
        EkoHUD.hide()
        navigationController?.popViewController(animated: true)
    }
    
    func screenVieWModelDidDeleteCommunitySuccess() {
        EkoHUD.hide()
        if let communityHomePage = navigationController?.viewControllers.first(where: { $0.isKind(of: EkoCommunityHomePageViewController.self) }) {
            navigationController?.popToViewController(communityHomePage, animated: true)
        } else if let globalFeedViewController = navigationController?.viewControllers.first(where: { $0.isKind(of: EkoGlobalFeedViewController.self) }) {
            navigationController?.popToViewController(globalFeedViewController, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func screenViewModelFailure() {
        EkoHUD.hide {
            EkoHUD.show(.error(message: EkoLocalizedStringSet.HUD.somethingWentWrong.localizedString))
        }
    }
    
}

extension EkoCommunitySettingsViewController: EkoCommunityProfileEditViewControllerDelegate {
    
    func viewController(_ viewController: EkoCommunityProfileEditViewController, didFinishCreateCommunity communityId: String) {
        EkoEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
}
