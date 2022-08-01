//
//  AmityRecentChatViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

/// Recent chat
public final class AmityRecentChatViewController: AmityViewController, IndicatorInfoProvider {
    
    var pageTitle: String?
    var channelID: String?
    
    func indicatorInfo(for pagerTabStripController: AmityPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var announcementLabel: UILabel!
    @IBOutlet private var announcementView: UIView!

    // MARK: - Properties
    private var screenViewModel: AmityRecentChatScreenViewModelType!
    
    private lazy var emptyView: AmityEmptyView = {
        AmityHUD.hide()
        let emptyView = AmityEmptyView(frame: tableView.frame)
        emptyView.update(title: AmityLocalizedStringSet.emptyChatList.localizedString,
                         subtitle: nil,
                         image: AmityIconSet.emptyChat)
        return emptyView
    }()
    
    // MARK: - View lifecycle
    private init(viewModel: AmityRecentChatScreenViewModelType, channelID: String? = nil) {
        screenViewModel = viewModel
        self.channelID = channelID
        super.init(nibName: AmityRecentChatViewController.identifier, bundle: AmityUIKitManager.bundle)
//        AmityHUD.show(.loading)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenViewModel()
        setupView()
        openChannelByDeppLink()
    }
    
    public static func make(channelType: AmityChannelType = .conversation, channelID: String? = nil) -> AmityRecentChatViewController {
        let viewModel: AmityRecentChatScreenViewModelType = AmityRecentChatScreenViewModel(channelType: channelType)
        return AmityRecentChatViewController(viewModel: viewModel,channelID: channelID)
    }
    
    
}

// MARK: - Setup ViewModel
private extension AmityRecentChatViewController {
    func setupScreenViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.viewDidLoad()
    }
}

// MARK: - Setup View
private extension AmityRecentChatViewController {
    func setupView() {
        self.title = "Chat"
        let addImage = UIImage(named: "icon_chat_contact", in: AmityUIKitManager.bundle, compatibleWith: nil)
        let barButton = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(didClickContact))
        barButton.tintColor = .black
        navigationItem.rightBarButtonItem = barButton
        setupTableView()
        
        /// Set attribute string
        let announcementAttributeString = NSMutableAttributedString(string: AmityLocalizedStringSet.RecentMessage.announcementMessage.localizedString)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributeString = NSAttributedString(string: AmityLocalizedStringSet.RecentMessage.announcementUnderlineMessage.localizedString, attributes: underlineAttribute)
        let announcementExtAttributeString = NSMutableAttributedString(string: AmityLocalizedStringSet.RecentMessage.announcementMessageExt.localizedString)
        announcementAttributeString.append(underlineAttributeString)
        announcementAttributeString.append(announcementExtAttributeString)
        
        self.announcementLabel.font = AmityFontSet.caption
        self.announcementLabel.attributedText = announcementAttributeString
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didClickAnnouncement(_:)))
        self.announcementView.addGestureRecognizer(tap)
    }
    
    func setupTableView() {
        view.backgroundColor = AmityColorSet.backgroundColor
        tableView.register(AmityRecentChatTableViewCell.nib, forCellReuseIdentifier: AmityRecentChatTableViewCell.identifier)
        tableView.backgroundColor = AmityColorSet.backgroundColor
        tableView.separatorInset.left = 64
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.backgroundView = emptyView
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func didClickAdd(_ barButton: UIBarButtonItem) {
        AmityChannelEventHandler.shared.channelCreateNewChat(
            from: self,
            completionHandler: { [weak self] storeUsers in
                guard let weakSelf = self else { return }
                weakSelf.screenViewModel.action.createChannel(users: storeUsers)
        })
    }
    
    @objc func didClickAnnouncement(_ sender: UITapGestureRecognizer? = nil) {
        AmityEventHandler.shared.routeToNewsfeedDidTap(from: self)
    }

    @objc func didClickContact() {
        AmityEventHandler.shared.openContactPageEvent()
    }
}

// MARK: - UITableView Delegate
extension AmityRecentChatViewController: UITableViewDelegate {
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
extension AmityRecentChatViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfRow(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AmityRecentChatTableViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? AmityRecentChatTableViewCell {
            let channel = screenViewModel.dataSource.channel(at: indexPath)
            cell.display(with: channel)
        }
    }
}

extension AmityRecentChatViewController: AmityRecentChatScreenViewModelDelegate {
    func screenViewModelDidCreateCommunity(channelId: String) {
        AmityChannelEventHandler.shared.channelDidTap(from: self, channelId: channelId)
    }
    
    func screenViewModelDidFailedCreateCommunity(error: String) {
        AmityHUD.show(.error(message: AmityLocalizedStringSet.CommunityChannelCreation.failedToCreate.localizedString))
    }
    
    func screenViewModelDidGetChannel() {
        tableView.reloadData()
    }
    
    func screenViewModelLoadingState(for state: AmityLoadingState) {
        switch state {
        case .loaded:
            tableView.tableFooterView = UIView()
        case .loading:
            tableView.showLoadingIndicator()
        case .initial:
            break
        }
    }
    
    func screenViewModelRoute(for route: AmityRecentChatScreenViewModel.Route) {
        switch route {
        case .messageView(let channelId):
            AmityChannelEventHandler.shared.channelDidTap(from: self, channelId: channelId)
        }
    }
    
    func screenViewModelEmptyView(isEmpty: Bool) {
        tableView.backgroundView = isEmpty ? emptyView : nil
        AmityHUD.hide()
    }
}

extension AmityRecentChatViewController {
    
    func openChannelByDeppLink() {
        guard let _ = channelID else { return }
        if channelID == "" { return }
        let messageVC = AmityMessageListViewController.make(channelId: channelID ?? "")
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
}
