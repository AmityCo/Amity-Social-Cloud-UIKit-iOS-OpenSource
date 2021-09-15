//
//  CommunityFeatureViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmityUIKit
import SwiftUI

class CommunityFeatureViewController: UIViewController {
    
    enum FeatureList: CaseIterable {
        case home
        case newsfeed
        case globalFeed
        case myProfile
        
        var text: String {
            switch self {
            case .home:
                return "Home"
            case .newsfeed:
                return "Newsfeed (GlobalFeed + MyCommunity)"
            case .globalFeed:
                return "GlobalFeed"
            case .myProfile:
                return "My Profile"
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
        AmityFeedUISettings.shared.delegate = nil
        AmityFeedUISettings.shared.dataSource = nil
    }
}

extension CommunityFeatureViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch FeatureList.allCases[indexPath.row] {
        case .home:
            let homepage = AmityCommunityHomePageViewController.make()
            navigationController?.pushViewController(homepage, animated: true)
            
            AmityFeedUISettings.shared.register(UINib(nibName: "AmityPostBirthdayTableViewCell", bundle: nil), forCellReuseIdentifier: "AmityPostBirthdayTableViewCell")
            AmityFeedUISettings.shared.register(UINib(nibName: "AmityPostThumbsupTableViewCell", bundle: nil), forCellReuseIdentifier: "AmityPostThumbsupTableViewCell")
            AmityFeedUISettings.shared.register(UINib(nibName: "AmityPostNewJoinerTableViewCell", bundle: nil), forCellReuseIdentifier: "AmityPostNewJoinerTableViewCell")
            AmityFeedUISettings.shared.delegate = self
            AmityFeedUISettings.shared.dataSource = self
        case .newsfeed:
            let newsfeedViewController = AmityNewsfeedViewController.make()
            navigationController?.pushViewController(newsfeedViewController, animated: true)
        case .globalFeed:
            let feedViewController = AmityGlobalFeedViewController.make()
            navigationController?.pushViewController(feedViewController, animated: true)
        case .myProfile:
            let myUserProfileViewController = AmityUserProfilePageViewController.make(withUserId: AmityUIKitManager.client.currentUserId ?? "")
            navigationController?.pushViewController(myUserProfileViewController, animated: true)
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

// MARK: - AmityFeedDelegate & AmityFeedDataSource
extension CommunityFeatureViewController: AmityFeedDelegate {
    func didPerformActionLikePost() {
    }
    
    func didPerformActionUnLikePost() {
    }
    
    func didPerformActionLikeComment() {
        
    }
    
    func didPerformActionUnLikeComment() {
        
    }
}

extension CommunityFeatureViewController: AmityFeedDataSource {
    func getUIComponentForPost(post: AmityPostModel, at index: Int) -> AmityPostComposable? {
        switch post.dataType {
        case "Amity.birthday":
            birthday = BirthdayPostComponent(post: post)
            return birthday
        case "Amity.recommendation":
            return ThumbsupPostComponent(post: post)
        case "Amity.newEmployee":
            return NewJoinerPostComponent(post: post)
        default:
            return nil
        }
        
    }
}
