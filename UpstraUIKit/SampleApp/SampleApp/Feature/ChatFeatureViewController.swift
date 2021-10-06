//
//  ChatFeatureViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit

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
                self?.presentChat(channelId: channelId)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentChat(channelId: String) {
        var settings = EkoMessageListViewController.Settings()
        settings.composeBarStyle = .textOnly
        let vc = EkoMessageListViewController.make(channelId: channelId, settings: settings)
        vc.dataSource = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ChatFeatureViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch FeatureList.allCases[indexPath.row] {
        case .chatHome:
            let vc = EkoChatHomePageViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .chatList:
            let vc = EkoRecentChatViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .chatListCustomize:
            let vc = EkoChatHomePageViewController.make()
            vc.messageDataSource = self
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

extension ChatFeatureViewController: EkoMessageListDataSource {
    func cellForMessageTypes() -> [EkoMessageTypes : EkoMessageCellProtocol.Type] {
        return [
            .textIncoming: CustomMessageTextIncomingTableViewCell.self
        ]
    }
    
}
