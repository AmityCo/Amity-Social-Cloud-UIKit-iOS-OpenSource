//
//  ChatFeatureViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmityUIKit
import AmitySDK

class ChatFeatureSetting {
    
    static let shared = ChatFeatureSetting()
    var iscustomMessageEnabled: Bool = false
    
    private init() { }
}

class ChatFeatureViewController: UIViewController {
    
    enum FeatureList: CaseIterable {
        case chatHome
        case chatList
        case chatListCustomize
        case messageListWithTextOnlyKeyboard

        var text: String {
            switch self {
            case .chatHome:
                return "Chat Home"
            case .chatList:
                return "Chat List"
            case .chatListCustomize:
                return "Chat List with customization"
            case .messageListWithTextOnlyKeyboard:
                return "Message List with text only keyboard"
            }
        }
        
    }
    
    @IBOutlet private var tableView: UITableView!
    
    private var channelObject: AmityObject<AmityChannel>?
    private var channelRepository: AmityChannelRepository?
    private var channelToken: AmityNotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat Feature"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func presentSpecificChatDialogue() {
        let alertController = UIAlertController(title: "Channel ID", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Insert channel id"
        }
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if
                let textField = alertController.textFields?.first,
                let channelId = textField.text,
                !channelId.isEmpty
            {
                self?.joinToTheChannel(channelId: channelId)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentChat(channelId: String, subChannelId: String) {
        ChatFeatureSetting.shared.iscustomMessageEnabled = true
        
        var settings = AmityMessageListViewController.Settings()
        settings.composeBarStyle = .textOnly
        let vc = AmityMessageListViewController.make(channelId: channelId, subChannelId: subChannelId, settings: settings)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func joinToTheChannel(channelId: String) {
        channelRepository = AmityChannelRepository(client: AmityUIKitManager.client)
        Task { @MainActor in
            do {
                let channel = try await channelRepository?.joinChannel(channelId: channelId)
                if let channel = channel {
                    presentChat(channelId: channel.channelId, subChannelId: channel.defaultSubChannelId)
                }
            } catch {
                let alertController = UIAlertController(title: "Something went wrong", message: "Can't join to the channel: \(error.localizedDescription)", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(ok)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension ChatFeatureViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch FeatureList.allCases[indexPath.row] {
        case .chatHome:
            ChatFeatureSetting.shared.iscustomMessageEnabled = false
            let vc = AmityChatHomePageViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .chatList:
            ChatFeatureSetting.shared.iscustomMessageEnabled = false
            let vc = AmityRecentChatViewController.make(channelType: .community)
            navigationController?.pushViewController(vc, animated: true)
        case .chatListCustomize:
            ChatFeatureSetting.shared.iscustomMessageEnabled = true
            let vc = AmityRecentChatViewController.make(channelType: .community)
            navigationController?.pushViewController(vc, animated: true)
        case .messageListWithTextOnlyKeyboard:
            presentSpecificChatDialogue()
        }
    }
}

extension ChatFeatureViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeatureList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.text = FeatureList.allCases[indexPath.row].text
        return cell
    }
}
