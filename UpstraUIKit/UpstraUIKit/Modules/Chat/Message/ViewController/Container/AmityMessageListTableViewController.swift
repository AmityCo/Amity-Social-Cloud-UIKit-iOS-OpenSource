//
//  AmityMessageListTableViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityMessageListTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var screenViewModel: AmityMessageListScreenViewModelType!
    
    // MARK: - View lifecycle
    private convenience init(viewModel: AmityMessageListScreenViewModelType) {
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
    
    static func make(viewModel: AmityMessageListScreenViewModelType) -> AmityMessageListTableViewController {
        return AmityMessageListTableViewController(viewModel: viewModel)
    }
    
}

// MARK: - Setup View
extension AmityMessageListTableViewController {
    func setupView() {
        tableView.separatorInset.left = UIScreen.main.bounds.width
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = AmityColorSet.backgroundColor
        screenViewModel.dataSource.allCells.forEach {
            tableView.register($0.value, forCellReuseIdentifier: $0.key)
        }
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

// MARK: - Update Views
extension AmityMessageListTableViewController {
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
extension AmityMessageListTableViewController {
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        screenViewModel.action.loadMoreScrollUp(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let message = screenViewModel.dataSource.message(at: indexPath) else { return 0 }
        switch message.messageType {
        case .image where !message.isDeleted:
            return UITableView.automaticDimension
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
        let dateView = AmityMessageDateView()
        dateView.text = message.date
        return dateView
    }
}

// MARK: - DataSource
extension AmityMessageListTableViewController {
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
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
        if let cell = cell as? AmityMessageTableViewCell {
            cell.delegate = self
            cell.setViewModel(with: screenViewModel)
            cell.setIndexPath(with: indexPath)
        }
        
        (cell as? AmityMessageCellProtocol)?.display(message: message)
    }
    
    private func cellIdentifier(for message: AmityMessageModel) -> String? {
        switch message.messageType {
        case .custom where message.isOwner:
            fallthrough
        case .text where message.isOwner:
            return AmityMessageTypes.textOutgoing.identifier
        case .text:
            return AmityMessageTypes.textIncoming.identifier
        case .image where message.isOwner:
            return AmityMessageTypes.imageOutgoing.identifier
        case .image:
            return AmityMessageTypes.imageIncoming.identifier
        case .audio where message.isOwner:
            return AmityMessageTypes.audioOutgoing.identifier
        case .audio:
            return AmityMessageTypes.audioIncoming.identifier
        default:
            return nil
        }
    }
}

extension AmityMessageListTableViewController: AmityMessageCellDelegate {
    func performEvent(_ cell: AmityMessageTableViewCell, events: AmityMessageCellEvents) {
        
        switch cell.message.messageType {
        case .audio:
            switch events {
            case .audioPlaying:
                tableView.reloadData()
            case .audioFinishPlaying:
                tableView.reloadRows(at: [cell.indexPath], with: .none)
            default:
                break
            }
        default:
            break
        }
    }
}
