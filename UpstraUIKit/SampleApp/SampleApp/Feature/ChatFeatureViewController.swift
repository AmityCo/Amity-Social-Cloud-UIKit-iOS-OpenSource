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

class ChatFeatureViewController: UIViewController {
    
    enum FeatureList: CaseIterable {
        case chatHome
        case chatList
        case chatListCustomize
        case messageListWithTextOnlyKeyboard
        case createFromContact

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
            case .createFromContact:
                return "Create chat from contact"
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
    
    private func presentChat(channelId: String) {
        var settings = AmityMessageListViewController.Settings()
        settings.composeBarStyle = .textOnly
        let vc = AmityMessageListViewController.make(channelId: channelId, settings: settings)
        vc.dataSource = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func joinToTheChannel(channelId: String) {
        channelRepository = AmityChannelRepository(client: AmityUIKitManager.client)
        channelObject = channelRepository?.joinChannel(channelId)
        channelToken = channelObject?.observe({ [weak self] channel, error in
            guard let strongSelf = self else { return }
            
            strongSelf.channelToken?.invalidate()
            if let error = error {
                let alertController = UIAlertController(title: "Something went wrong", message: "Can't join to the channel: \(error.localizedDescription)", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(ok)
                strongSelf.present(alertController, animated: true, completion: nil)
            } else {
                strongSelf.presentChat(channelId: channelId)
            }
        })
    }
}

extension ChatFeatureViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch FeatureList.allCases[indexPath.row] {
        case .chatHome:
            let vc = AmityChatHomePageViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .chatList:
            let vc = AmityRecentChatViewController.make(channelType: .conversation)
            navigationController?.pushViewController(vc, animated: true)
        case .chatListCustomize:
            let vc = AmityChatHomePageViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .messageListWithTextOnlyKeyboard:
            presentSpecificChatDialogue()
        case .createFromContact:
            let user = TrueUser(userId: "Mono29")
            AmityCreateChannelHandler.shared.createChatFromContactPage(trueUser: user) { result in
                switch result {
                case .success(let channelId):
                    let vc = AmityMessageListViewController.make(channelId: channelId)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print("Error from create channel: \(error.localizedDescription)")
                }
            }
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

extension ChatFeatureViewController: AmityMessageListDataSource {
    func cellForMessageTypes() -> [AmityMessageTypes : AmityMessageCellProtocol.Type] {
        return [
            .textIncoming: CustomMessageTextIncomingTableViewCell.self
        ]
    }
}
