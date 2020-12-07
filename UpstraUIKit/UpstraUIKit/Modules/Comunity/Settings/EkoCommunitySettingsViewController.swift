//
//  EkoCommunitySettingsViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 14/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit


final class EkoCommunitySettingsViewController: EkoViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private let screenViewModel: EkoCommunityProfileScreenViewModelType
    private lazy var data: [EkoCommunitySettingsModel] = {
        return EkoCommunitySettingsModel.prepareData(isCreator: screenViewModel.dataSource.community.value?.isCreator ?? false)
    }()
    
    // MARK: - View lifecycle
    private init(viewModel: EkoCommunityProfileScreenViewModelType) {
        self.screenViewModel = viewModel
        super.init(nibName: EkoCommunitySettingsViewController.identifier, bundle: UpstraUIKitManager.bundle)
        title = screenViewModel.dataSource.community.value?.displayName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        bindingViewModel()
    }

    static func make(viewModel: EkoCommunityProfileScreenViewModelType) -> EkoCommunitySettingsViewController {
        return EkoCommunitySettingsViewController(viewModel: viewModel)
    }
}

// MARK: - Setup view
private extension EkoCommunitySettingsViewController {
    
    func setupView() {
        view.backgroundColor = EkoColorSet.backgroundColor
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

// MARK: - Binding ViewModel
private extension EkoCommunitySettingsViewController {
    func bindingViewModel() {
        screenViewModel.dataSource.settingsAction.bind { [weak self] (complete) in
            guard let strongSelf = self else { return }
            switch complete {
            case .intial:
                break
            case .leave:
                strongSelf.navigationController?.popViewController(animated: true)
                self?.screenViewModel.dataSource.settingsAction.value = .intial
            case .close:
                if let _ = strongSelf.navigationController?.viewControllers.first(where: { $0.isKind(of: EkoCommunityProfileEditViewController.self)}) {
                    strongSelf.dismiss(animated: true, completion: nil)
                } else {
                    strongSelf.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
}

// MARK: - UITableView Delegate
extension EkoCommunitySettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = data[indexPath.row].type
        switch type {
        case .editProfile:
            if EkoUserManager.shared.isModerator() {
                let alertController = UIAlertController(title: nil, message: EkoLocalizedStringSet.roleSupportAlertDesc, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.ok, style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            } else {
                let vc = EkoCommunityProfileEditViewController.make(viewType: .edit(communityId: screenViewModel.dataSource.communityId))
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
            }
        case .member:
            let communityId = screenViewModel.dataSource.communityId
            let vc = EkoCommunityMemberSettingsViewController.make(communityId: communityId)
            navigationController?.pushViewController(vc, animated: true)
        case .leave:
            let alertController = UIAlertController(title: EkoLocalizedStringSet.communitySettingsAlertLeaveTitle, message: EkoLocalizedStringSet.communitySettingsAlertLeaveDesc, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .default, handler: nil))
            alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.leave, style: .destructive, handler: { [weak self] action in
                self?.screenViewModel.action.leaveCommunity()
            }))
            present(alertController, animated: true, completion: nil)
        case .close:
            let alertController = UIAlertController(title: EkoLocalizedStringSet.communitySettingsAlertCloseTitle, message: EkoLocalizedStringSet.communitySettingsAlertCloseDesc, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .default, handler: nil))
            alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.close, style: .destructive, handler: { [weak self] action in
                self?.screenViewModel.action.deleteCommunity()
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableView DataSource
extension EkoCommunitySettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EkoCommunitySettingsTableViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoCommunitySettingsTableViewCell {
            cell.display(with: data[indexPath.row])
        }
    }
}

