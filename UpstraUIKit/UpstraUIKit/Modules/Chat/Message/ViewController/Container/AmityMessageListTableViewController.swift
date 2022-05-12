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
    
    struct Constant {
        static let estimatedTextMessageCellHeight: CGFloat = 112
        static let estimatedImageMessageCellHeight: CGFloat = 226
    }
    
    private let estimatedCellHeight: CGFloat = 112
    
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
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    func updateScrollPosition(to indexPath: IndexPath) {
        
        let contentHeight = tableView.contentSize.height
        let contentYOffset = tableView.contentOffset.y
        let viewHeight = tableView.bounds.height
        
        Log.add("Content Height: \(contentHeight), Content Offset: \(contentYOffset), ViewHeight: \(viewHeight)")
        
        // We update scroll position based on the view state. User can be in multiple view state.
        //
        // State 1:
        // All message fits inside the visible part of the view. We don't need to scoll
        if viewHeight >= contentHeight {
            return
        }
        
        tableView.layoutIfNeeded()
        
        let pageThreshold = 2.25 // It means user scroll up more than 2 and a quarter of pages.
        if contentHeight - contentYOffset <= (viewHeight * pageThreshold) {
            // State 2:
            //
            // User is at the bottom-most page. So we just scroll to the bottom when new message appears.
            Log.add("Scrolling tableview to show latest message")
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        } else {
            // State 3:
            //
            // User is looking at older messages. Prevent bringing user to the bottom.
        }
        
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
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let message = screenViewModel.dataSource.message(at: indexPath)else { return Constant.estimatedTextMessageCellHeight }
        let messageType = message.messageType
        
        switch messageType {
        case .text:
            return Constant.estimatedTextMessageCellHeight
        case .image:
            return Constant.estimatedImageMessageCellHeight
        default:
            return 0
        }
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

extension AmityMessageListTableViewController: AmityExpandableLabelDelegate {
    
    public func expandableLabeldidTap(_ label: AmityExpandableLabel) {
        // Intentionally left empty
    }
    
    public func willExpandLabel(_ label: AmityExpandableLabel) {
        tableView.beginUpdates()
    }
    
    public func didExpandLabel(_ label: AmityExpandableLabel) {
        tableView.endUpdates()
    }
    
    public func willCollapseLabel(_ label: AmityExpandableLabel) {
        tableView.beginUpdates()
    }
    
    public func didCollapseLabel(_ label: AmityExpandableLabel) {
        tableView.endUpdates()
    }
    
    public func didTapOnMention(_ label: AmityExpandableLabel, withUserId userId: String) {
        // Intentionally left empty
    }
}

// MARK: - Private functions
extension AmityMessageListTableViewController {
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
        if let cell = cell as? AmityMessageTableViewCell {
            cell.delegate = self
            cell.setViewModel(with: screenViewModel)
            cell.setIndexPath(with: indexPath)
            (cell as? AmityMessageTextTableViewCell)?.textDelegate = self
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
