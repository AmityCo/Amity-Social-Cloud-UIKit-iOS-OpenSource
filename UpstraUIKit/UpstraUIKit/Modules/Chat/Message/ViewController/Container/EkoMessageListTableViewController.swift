//
//  EkoMessageListTableViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoMessageListTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var screenViewModel: EkoMessageListScreenViewModelType!
    
    // MARK: - View lifecycle
    private convenience init(viewModel: EkoMessageListScreenViewModelType) {
        self.init(style: .plain)
        self.screenViewModel = viewModel
    }
    
    private override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenViewModel.action.getMessage()
    }
    
    static func make(viewModel: EkoMessageListScreenViewModelType) -> EkoMessageListTableViewController {
        return EkoMessageListTableViewController(viewModel: viewModel)
    }
    
}

// MARK: - Setup View
extension EkoMessageListTableViewController {
    func setupView() {
        tableView.separatorInset.left = UIScreen.main.bounds.width
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .white
        screenViewModel.dataSource.allCells.forEach {
            tableView.register($0.value, forCellReuseIdentifier: $0.key)
        }
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

// MARK: - Update Views
extension EkoMessageListTableViewController {
    func showBottomIndicator() {
        tableView.showHeaderLoadingIndicator()
    }
    
    func hideBottomIndicator() {
        tableView.tableHeaderView = UIView()
    }
    
    func scrollToBottom(indexPath: IndexPath) {
        tableView.layoutIfNeeded()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - Delegate
extension EkoMessageListTableViewController {
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        screenViewModel.action.loadMoreScrollUp(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let message = screenViewModel.dataSource.message(at: indexPath) else { return 0 }
        switch message.messageType {
        case .image where !message.isDeleted:
            return 250
        case .file: return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let message = screenViewModel.dataSource.message(at: IndexPath(row: 0, section: section)) else { return nil }
        let dateView = EkoMessageDateView()
        dateView.text = message.date
        return dateView
    }
}

// MARK: - DataSource
extension EkoMessageListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return screenViewModel.dataSource.numberOfSection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfMessage(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = screenViewModel.dataSource.message(at: indexPath),
            let cellIdentifier = cellIdentifier(for: message) else {
                return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        configure(for: cell, at: indexPath)
        
//        (cell as? EkoMessageTableViewCell)?.errorStateHandler = handleErrorMessage
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
        if let cell = cell as? EkoMessageTableViewCell {
            cell.setViewModel(with: screenViewModel)
            cell.setIndexPath(with: indexPath)
        }
        
        (cell as? EkoMessageCellProtocol)?.display(message: message)
    }
    
    private func cellIdentifier(for message: EkoMessageModel) -> String? {
        let client = UpstraUIKitManager.shared.client
        switch message.messageType {
        case .custom where message.userId == client.currentUserId:
            fallthrough
        case .text where message.userId == client.currentUserId:
            return EkoMessageTypes.textOutgoing.identifier
        case .text:
            return EkoMessageTypes.textIncoming.identifier
        case .image where message.userId == client.currentUserId:
            return EkoMessageTypes.imageOutgoing.identifier
        case .image:
            return EkoMessageTypes.imageIncoming.identifier
        default:
            return nil
        }
    }
}
