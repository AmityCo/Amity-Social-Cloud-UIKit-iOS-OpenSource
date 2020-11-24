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
        
        var text: String {
            switch self {
            case .chatHome:
                return "Chat Home"
            case .chatList:
                return "Chat List"
            case .chatListCustomize:
                return "Chat List with customization"
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
