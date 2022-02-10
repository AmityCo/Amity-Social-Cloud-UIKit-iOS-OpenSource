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
        case customPostRankingGlobalFeed
        case myProfile
        case postCreator
        case multipleFeeds
        
        var text: String {
            switch self {
            case .home:
                return "Home"
            case .newsfeed:
                return "Newsfeed (GlobalFeed + MyCommunity)"
            case .globalFeed:
                return "GlobalFeed"
            case .customPostRankingGlobalFeed:
                return "Custom Post Ranking Global Feed"
            case .myProfile:
                return "My Profile"
            case .postCreator:
                return "Post Creator"
            case .multipleFeeds:
                return "Multiple Feeds"
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
    
    @available(iOS 14.0, *)
    private func presentPostCreator(parameters: PostCreatorSettingsPage.Parameters) {
        let postTarget: AmityPostTarget
        switch parameters.targetType {
        case .community:
            fatalError("Unsupported case")
        case .user:
            postTarget = .myFeed
        @unknown default:
            fatalError("Unsupported case")
        }
        
        let settings = AmityPostEditorSettings()
        var allowPostAttachments = Set<AmityPostAttachmentType>()
        if parameters.allowImage {
            allowPostAttachments.formUnion([.image])
        }
        if parameters.allowVideo {
            allowPostAttachments.formUnion([.video])
        }
        if parameters.allowFile {
            allowPostAttachments.formUnion([.file])
        }
        settings.allowPostAttachments = allowPostAttachments
        
        let postCreatorVC = AmityPostCreatorViewController.make(postTarget: postTarget, settings: settings)
        let navigationController = UINavigationController(rootViewController: postCreatorVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension CommunityFeatureViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch FeatureList.allCases[indexPath.row] {
        case .home:
            
            AmityFeedUISettings.shared.register(UINib(nibName: "AmityPostBirthdayTableViewCell", bundle: nil), forCellReuseIdentifier: "AmityPostBirthdayTableViewCell")
            AmityFeedUISettings.shared.register(UINib(nibName: "AmityPostThumbsupTableViewCell", bundle: nil), forCellReuseIdentifier: "AmityPostThumbsupTableViewCell")
            AmityFeedUISettings.shared.register(UINib(nibName: "AmityPostNewJoinerTableViewCell", bundle: nil), forCellReuseIdentifier: "AmityPostNewJoinerTableViewCell")
            
            AmityFeedUISettings.shared.delegate = self
            AmityFeedUISettings.shared.dataSource = self
            
            let homepage = AmityCommunityHomePageViewController.make()
            let navigationController = UINavigationController(rootViewController: homepage)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
            
        case .newsfeed:
            let newsfeedPage = AmityNewsfeedViewController.make()
            let navigationController = UINavigationController(rootViewController: newsfeedPage)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        case .globalFeed:
            let globalFeedPage = AmityGlobalFeedViewController.make()
            let navigationController = UINavigationController(rootViewController: globalFeedPage)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        case .customPostRankingGlobalFeed:
            let globalFeedPage = AmityGlobalFeedViewController.makeCustomPostRanking()
            let navigationController = UINavigationController(rootViewController: globalFeedPage)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        case .myProfile:
            let myUserProfileViewController = AmityUserProfilePageViewController.make(withUserId: AmityUIKitManager.client.currentUserId ?? "")
            navigationController?.pushViewController(myUserProfileViewController, animated: true)
        case .multipleFeeds:
            let samplePageViewController = SamplePageViewController()
            navigationController?.pushViewController(samplePageViewController, animated: true)
        case .postCreator:
            if #available(iOS 14.0, *) {
                var postCreateSettingsPage = PostCreatorSettingsPage()
                postCreateSettingsPage.didChooseParameters = { [weak self] parameters in
                    self?.navigationController?.popViewController(animated: true)
                    self?.presentPostCreator(parameters: parameters)
                }
                let hoistingVC = UIHostingController(rootView: postCreateSettingsPage)
                navigationController?.pushViewController(hoistingVC, animated: true)
            } else {
                print("iOS 14.0 is required to access this menu.")
            }
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
