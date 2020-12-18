//
//  EkoRecentChatViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import EkoChat

/// Recent chat
public final class EkoRecentChatViewController: EkoViewController, IndicatorInfoProvider {
    
    var pageTitle: String?
    
    func indicatorInfo(for pagerTabStripController: EkoPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
    
    public var messageDataSource: EkoMessageListDataSource?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private var messageListVC: EkoMessageListViewController?
    private var screenViewModel: EkoRecentChatScreenViewModelType!
    
    private lazy var emptyView: EkoEmptyView = {
        let emptyView = EkoEmptyView(frame: tableView.frame)
        emptyView.update(title: EkoLocalizedStringSet.emptyChatList,
                         subtitle: nil,
                         image: EkoIconSet.emptyChat)
        return emptyView
    }()
    
    // MARK: - View lifecycle
    private init(viewModel: EkoRecentChatScreenViewModelType) {
        screenViewModel = viewModel
        super.init(nibName: EkoRecentChatViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScreenViewModel()
    }
    
    public static func make() -> EkoRecentChatViewController {
        let viewModel: EkoRecentChatScreenViewModelType = EkoRecentChatScreenViewModel()
        return EkoRecentChatViewController(viewModel: viewModel)
    }
}

// MARK: - Setup ViewModel
private extension EkoRecentChatViewController {
    func setupScreenViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.viewDidLoad()
    }
}

// MARK: - Setup View
private extension EkoRecentChatViewController {
    func setupView() {
        setupTableView()
    }
    
    func setupTableView() {
        view.backgroundColor = EkoColorSet.backgroundColor
        tableView.register(EkoRecentChatTableViewCell.nib, forCellReuseIdentifier: EkoRecentChatTableViewCell.identifier)
        tableView.backgroundColor = EkoColorSet.backgroundColor
        tableView.separatorInset.left = 64
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.backgroundView = emptyView
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableView Delegate
extension EkoRecentChatViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        screenViewModel.action.join(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isBottomReached {
            screenViewModel.action.loadMore()
        }
    }
}

// MARK: - UITableView DataSource
extension EkoRecentChatViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfRow(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EkoRecentChatTableViewCell.identifier, for: indexPath)
            configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoRecentChatTableViewCell {
            let channel = screenViewModel.dataSource.channel(at: indexPath)
            cell.display(with: channel)
        }
    }
}

extension EkoRecentChatViewController: EkoRecentChatScreenViewModelDelegate {
    func screenViewModelDidGetChannel() {
        tableView.reloadData()
    }
    
    func screenViewModelLoadingState(for state: EkoLoadingState) {
        switch state {
        case .loaded:
            tableView.tableFooterView = UIView()
        case .loadmore:
            tableView.showLoadingIndicator()
        default:
            break
        }
    }
    
    func screenViewModelRoute(for route: EkoRecentChatScreenViewModel.Route) {
        switch route {
        case .messageView(let channelId):
            messageListVC = EkoMessageListViewController.make(channelId: channelId)
            guard let messageListVC = messageListVC else { return }
            messageListVC.dataSource = messageDataSource
            navigationController?.pushViewController(messageListVC, animated: true)
        }
    }
    
    func screenViewModelEmptyView(isEmpty: Bool) {
        tableView.backgroundView = isEmpty ? emptyView : nil
    }
}
