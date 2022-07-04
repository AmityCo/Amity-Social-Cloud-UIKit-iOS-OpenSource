//
//  FeatureViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmityUIKit
import UIKit

class FeatureViewController: UIViewController {
    
    enum FeatureList: CaseIterable {
        case chatFeature
        case community
        case data
        
        var text: String {
            switch self {
            case .chatFeature:
                return "Chat"
            case .community:
                return "Community"
            case .data:
                return "Data"
            }
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    private var logoutButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feature"
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
