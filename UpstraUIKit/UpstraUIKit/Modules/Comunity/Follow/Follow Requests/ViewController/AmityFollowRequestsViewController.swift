//
//  AmityFollowRequestsViewController.swift
//  AmityUIKit
//
//  Created by Hamlet on 17.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

/// A view controller for providing all follow requests list.
public final class AmityFollowRequestsViewController: AmityViewController {
    // MARK:- IBOutlet
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var refreshErrorView: UIView!
    @IBOutlet weak private var refreshErrorLabel: UILabel!
    
    // MARK:- Properties
    private var screenViewModel: AmityFollowRequestsScreenViewModelType!
    private let refreshControl = UIRefreshControl()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenViewModel.action.getFollowRequests()
    }
    
    public static func make(withUserId userId: String) -> AmityFollowRequestsViewController {
        let vc = AmityFollowRequestsViewController(nibName: AmityFollowRequestsViewController.identifier, bundle: AmityUIKitManager.bundle)
        let viewModel: AmityFollowRequestsScreenViewModelType = AmityFollowRequestsScreenViewModel(userId: userId)
        vc.screenViewModel = viewModel
        return vc
    }
}

// MARK: - Setup view
private extension AmityFollowRequestsViewController {
    func setupView() {
        title = AmityLocalizedStringSet.Follow.followRequestsTitle.localizedString
        screenViewModel.delegate = self
        setupTableView()
        setupRefreshControl()
        setupRefreshErrorView()
    }
    
    func setupTableView() {
        tableView.register(AmityFollowRequestTableViewCell.nib, forCellReuseIdentifier: AmityFollowRequestTableViewCell.identifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = AmityColorSet.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefreshingControl), for: .valueChanged)
        refreshControl.tintColor = AmityColorSet.base.blend(.shade3)
        tableView.refreshControl = refreshControl
    }
    
    func setupRefreshErrorView() {
        refreshErrorView.backgroundColor = AmityColorSet.secondary
        refreshErrorView.alpha = 0.8
        refreshErrorView.isHidden = true
        
        refreshErrorLabel.font = AmityFontSet.bodyBold
        refreshErrorLabel.textColor = .white
        refreshErrorLabel.textAlignment = .center
        refreshErrorLabel.text = AmityLocalizedStringSet.Follow.canNotRefreshFeed.localizedString
    }
    
    func setupViewModel() {
        screenViewModel.delegate = self
    }
}

// MARK: - UITableView Delegate
extension AmityFollowRequestsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableView DataSource
extension AmityFollowRequestsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfRequests()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AmityFollowRequestTableViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? AmityFollowRequestTableViewCell {
            let item = screenViewModel.dataSource.item(at: indexPath)
            cell.display(with: item)
            cell.setIndexPath(with: indexPath)
            cell.delegate = self
        }
    }
}

extension AmityFollowRequestsViewController: AmityFollowRequestTableViewCellDelegate {
    func didPerformAction(at indexPath: IndexPath, action: AmityFollowRequestAction) {
        switch action {
        case .tapAvatar, .tapDisplayName:
            AmityEventHandler.shared.userDidTap(from: self, userId: screenViewModel.dataSource.item(at: indexPath).sourceUserId)
        case .tapAccept:
            screenViewModel.action.acceptRequest(at: indexPath)
        case .tapDecline:
            screenViewModel.action.declineRequest(at: indexPath)
        }
    }
}

extension AmityFollowRequestsViewController :AmityFollowRequestsScreenViewModelDelegate {
    func screenViewModelDidGetRequests() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, loadingState state: AmityLoadingState) {
        switch state {
        case .loading:
            tableView.showLoadingIndicator()
        case .loaded:
            tableView.tableFooterView = nil
        case .initial:
            break
        }
    }
    
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didAcceptRequestAt indexPath: IndexPath) {
        tableView.reloadData()
        AmityHUD.show(.success(message: AmityLocalizedStringSet.General.done.localizedString))
    }
    
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didDeclineRequestAt indexPath: IndexPath) {
        tableView.reloadData()
        AmityHUD.show(.success(message: AmityLocalizedStringSet.General.done.localizedString))
    }
    
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didFailToAcceptRequestAt indexPath: IndexPath) {
        showAcceptOrDecileRequestFailureMessage(for: indexPath)
    }
    
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didFailToDeclineRequestAt indexPath: IndexPath) {
        showAcceptOrDecileRequestFailureMessage(for: indexPath)
    }
    
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, failure error: AmityError) {
        refreshControl.endRefreshing()
        refreshErrorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.refreshErrorView.isHidden = true
        }
    }
    
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didRemoveRequestAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}

private extension AmityFollowRequestsViewController {
    func showAcceptOrDecileRequestFailureMessage(for indexPath: IndexPath) {
        AmityAlertController.present(title: AmityLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString,
                                   message: AmityLocalizedStringSet.Follow.unavailableFollowRequest.localizedString,
                                   actions: [.ok(handler: { [weak self] in
                                    self?.screenViewModel.action.removeRequest(at: indexPath)
                                   })], from: self)
    }
    
    @objc func handleRefreshingControl() {
        screenViewModel.action.reload()
    }
}
