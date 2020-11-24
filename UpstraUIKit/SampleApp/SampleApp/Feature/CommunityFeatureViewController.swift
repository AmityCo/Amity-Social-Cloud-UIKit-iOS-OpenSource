//
//  CommunityFeatureViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit
import SwiftUI

class CommunityFeatureViewController: UIViewController {
    
    enum FeatureList: CaseIterable {
        case home
        case newsfeed
        case globalFeed
        case myFeed
        
        var text: String {
            switch self {
            case .home:
                return "Home"
            case .newsfeed:
                return "Newsfeed (GlobalFeed + MyCommunity)"
            case .globalFeed:
                return "GlobalFeed"
            case .myFeed:
                return "MyFeed"
            }
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Community"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension CommunityFeatureViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch FeatureList.allCases[indexPath.row] {
        case .home:
            let homepage = EkoCommunityHomePageViewController.make()
            navigationController?.pushViewController(homepage, animated: true)
        case .newsfeed:
            let newsfeedViewController = EkoNewsfeedViewController.make()
            navigationController?.pushViewController(newsfeedViewController, animated: true)
        case .globalFeed:
            let feedViewController = EkoGlobalFeedViewController.make()
            navigationController?.pushViewController(feedViewController, animated: true)
        case .myFeed:
            let feedViewController = EkoUserFeedViewController.makeMyFeed()
            navigationController?.pushViewController(feedViewController, animated: true)
        }
    }
}

extension CommunityFeatureViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeatureList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.text = FeatureList.allCases[indexPath.row].text
        return cell
    }
}
