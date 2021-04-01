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
    var birthday: BirthdayPostComponent?
    override func viewDidLoad() {
        super.viewDidLoad()


        
        title = "Community"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EkoFeedUISettings.shared.delegate = nil
        EkoFeedUISettings.shared.dataSource = nil
    }
}

extension CommunityFeatureViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch FeatureList.allCases[indexPath.row] {
        case .home:
            let homepage = EkoCommunityHomePageViewController.make()
            navigationController?.pushViewController(homepage, animated: true)
            
            EkoFeedUISettings.shared.register(UINib(nibName: "EkoPostBirthdayTableViewCell", bundle: nil), forCellReuseIdentifier: "EkoPostBirthdayTableViewCell")
            EkoFeedUISettings.shared.register(UINib(nibName: "EkoPostThumbsupTableViewCell", bundle: nil), forCellReuseIdentifier: "EkoPostThumbsupTableViewCell")
            EkoFeedUISettings.shared.register(UINib(nibName: "EkoPostNewJoinerTableViewCell", bundle: nil), forCellReuseIdentifier: "EkoPostNewJoinerTableViewCell")
            EkoFeedUISettings.shared.delegate = self
            EkoFeedUISettings.shared.dataSource = self
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

// MARK: - EkoFeedDelegate & EkoFeedDataSource
extension CommunityFeatureViewController: EkoFeedDelegate {
    func didPerformActionLikePost() {
    }
    
    func didPerformActionUnLikePost() {
    }
    
    func didPerformActionLikeComment() {
        
    }
    
    func didPerformActionUnLikeComment() {
        
    }
}

extension CommunityFeatureViewController: EkoFeedDataSource {
    func getUIComponentForPost(post: EkoPostModel, at index: Int) -> EkoPostComposable? {
        switch post.dataType {
        case "eko.birthday":
            birthday = BirthdayPostComponent(post: post)
            return birthday
        case "eko.recommendation":
            return ThumbsupPostComponent(post: post)
        case "eko.newEmployee":
            return NewJoinerPostComponent(post: post)
        default:
            return nil
        }
        
    }
}
