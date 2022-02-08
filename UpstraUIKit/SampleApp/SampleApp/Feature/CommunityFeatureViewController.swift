//
//  CommunityFeatureViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK
import AmityUIKit
import SwiftUI

class CommunityFeatureViewController: UIViewController {
    
    let userNotificationManager = AmityUIKitManager.client.notificationManager
    
    private enum UserDefaultsKey {
        static let userId = "userId"
        static let userIds = "userIds"
        static let deviceToken = "deviceToken"
    }
    
    enum FeatureList: CaseIterable {
        case home
        case newsfeed
        case globalFeed
        case myProfile
        case PostCreator
        case myFeed
        case homeByDeeplink
        case th
        case id
        case km
        case ph
        case vn
        case en
        case my
        case gallery
        case notification
        case client
        
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
            case .PostCreator:
                return "Post Creator"
            case .myFeed:
                return "MyFeed"
            case .homeByDeeplink:
                return "Home by deep link"
            case .th:
                return "th"
            case .id:
                return "id"
            case .km:
                return "km"
            case .ph:
                return "ph"
            case .vn:
                return "vn"
            case .en:
                return "en"
            case .my:
                return "my"
            case .gallery:
                return "gallery"
            case .notification:
                return "notification"
            case .client:
                return "client"
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
            let homepage = AmityCommunityHomePageViewController.make()
//            homepage.navigationBarType = .custom
//            navigationController?.pushViewController(homepage, animated: true)
            
            let navController = UINavigationController(rootViewController: homepage)
            navController.modalPresentationStyle = .fullScreen
            navigationController?.present(navController, animated: true, completion: nil)
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
        case .PostCreator:
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
        case .myFeed:
            let feedViewController = AmityUserFeedViewController.makeMyFeed()
            navigationController?.pushViewController(feedViewController, animated: true)
        case .homeByDeeplink:
            let home = AmityCommunityHomePageViewController.make(amityCommunityEventType: AmityCommunityEventTypeModel(openType: .post, postID: "890615e34219985839035d50881506fd", communityID: "56701fa0443c1e92b43d89961fdc0cd4"))
//            let home = AmityCommunityHomePageViewController.make(amityCommunityEventType: AmityCommunityEventTypeModel(openType: .community, communityID: "56701fa0443c1e92b43d89961fdc0cd4"))
//            let home = AmityCommunityHomePageViewController.make(amityCommunityEventType: AmityCommunityEventTypeModel(openType: .category, categoryID: "b2f4c60313f99a7cb59a222cfcaccda1"))
            navigationController?.pushViewController(home, animated: true)
        
        case .th:
            AmityUIKitManager.setLanguage(language: "th")
            openHomePage()
        case .id:
            AmityUIKitManager.setLanguage(language: "id")
            openHomePage()
        case .km:
            AmityUIKitManager.setLanguage(language: "km")
            openHomePage()
        case .ph:
            AmityUIKitManager.setLanguage(language: "ph")
            openHomePage()
        case .vn:
            AmityUIKitManager.setLanguage(language: "vn")
            openHomePage()
        case .en:
            AmityUIKitManager.setLanguage(language: "en")
            openHomePage()
        case .my:
            AmityUIKitManager.setLanguage(language: "my")
            openHomePage()
        case .gallery:
            let galleryVC = AmityPostGalleryViewController.makeByTrueID(targetType: .user, targetId: UserDefaults.standard.value(forKey: UserDefaultsKey.userId) as! String, isHiddenButtonCreate: false)
            navigationController?.pushViewController(galleryVC, animated: true)
        case .notification:
            let model: [AmityUserNotificationModule] = [AmityUserNotificationModule(moduleType: .videoStreaming, isEnabled: false, roleFilter: nil)]
            self.userNotificationManager.enable(for: model) { (success, error) in
                if success {
                    debugPrint("Notification Success" as Any)
                } else {
                    debugPrint("Error" as Any)
                }
            }
        case .client:
            debugPrint(AmityUIKitManager.client)
        }
        
    }
    
    private func openHomePage() {
        let homepage = AmityCommunityHomePageViewController.make()
        let navController = UINavigationController(rootViewController: homepage)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: true, completion: nil)
        AmityFeedUISettings.shared.register(UINib(nibName: "AmityPostBirthdayTableViewCell", bundle: nil), forCellReuseIdentifier: "AmityPostBirthdayTableViewCell")
        AmityFeedUISettings.shared.register(UINib(nibName: "AmityPostThumbsupTableViewCell", bundle: nil), forCellReuseIdentifier: "AmityPostThumbsupTableViewCell")
        AmityFeedUISettings.shared.register(UINib(nibName: "AmityPostNewJoinerTableViewCell", bundle: nil), forCellReuseIdentifier: "AmityPostNewJoinerTableViewCell")
        AmityFeedUISettings.shared.delegate = self
        AmityFeedUISettings.shared.dataSource = self
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
