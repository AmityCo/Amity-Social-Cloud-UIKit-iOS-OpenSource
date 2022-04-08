//
//  FeatureViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmityUIKit

class FeatureViewController: UIViewController {
    
    enum FeatureList: CaseIterable {
        case chatFeature
        case community
        case data
        case chatFromProfile
        case testUnreadFromOutsideAmity
        
        var text: String {
            switch self {
            case .chatFeature:
                return "Chat"
            case .community:
                return "Community"
            case .data:
                return "Data"
            case .chatFromProfile:
                return "Test chat from profile"
            case .testUnreadFromOutsideAmity:
                return "Test get unreadCount from outside Amity"
            }
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    private var logoutButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "[UIKit 2.11.0] [TrueID Build 2.11.0 (1)]"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        logoutButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTap))
        navigationItem.rightBarButtonItem = logoutButtonItem
        
    }
    
    @objc private func logoutTap() {
        AppManager.shared.unregister()
    }
    
}

extension FeatureViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch FeatureList.allCases[indexPath.row] {
        case .chatFeature:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatFeatureViewController")
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .community:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunityFeatureViewController")
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .data:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataListViewController")
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .chatFromProfile:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatFromCommunityViewController")
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .testUnreadFromOutsideAmity:
            var unreadCount = 0
            
            AmityChatHandler.shared.getNotiCountFromAPI{ result in
                switch result {
                case .success(let count):
                    unreadCount = count
                    let alert = UIAlertController(title: "Test unreadCount", message: "Total unread count = \(unreadCount)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
                        
                    }))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        }
        
    }
}

extension FeatureViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeatureList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.text = FeatureList.allCases[indexPath.row].text
        return cell
    }
}
