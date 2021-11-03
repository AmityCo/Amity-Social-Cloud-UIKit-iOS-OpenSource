//
//  AmityCommunityProfilePageViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 20/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

public class AmityCommunityProfilePageSettings {
    public init() { }
    public var shouldChatButtonHide: Bool = true
}

/// A view controller for providing community profile and community feed.
public final class AmityCommunityProfilePageViewController: AmityProfileViewController {
    
    static var newCreatedCommunityIds = Set<String>()
    
    // MARK: - Properties
    private var settings: AmityCommunityProfilePageSettings!
    private var header: AmityCommunityProfileHeaderViewController!
    private var bottom: AmityCommunityFeedViewController!
    private var postButton: AmityFloatingButton = AmityFloatingButton()
    
    private var screenViewModel: AmityCommunityProfileScreenViewModelType!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        screenViewModel.delegate = self
        setupFeed()
        
        routeToDeeplinksPostIfNeed()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AmityEventHandler.shared.communityPageToTimelineTracking()
        setupViewModel()
        setupPostButton()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCommunitySettingModal()
    }
    
    public static func make(
        withCommunityId communityId: String, postId: String? = nil, fromDeeplinks: Bool = false, settings: AmityCommunityProfilePageSettings = .init()
    ) -> AmityCommunityProfilePageViewController {
        
        let communityRepositoryManager = AmityCommunityRepositoryManager(communityId: communityId)
        let viewModel = AmityCommunityProfileScreenViewModel(
            communityId: communityId,
            postId: postId,
            fromDeeplinks: fromDeeplinks,
            communityRepositoryManager: communityRepositoryManager
        )
        let vc = AmityCommunityProfilePageViewController()
        vc.screenViewModel = viewModel
        vc.header = AmityCommunityProfileHeaderViewController.make(rootViewController: vc, viewModel: viewModel, settings: settings)
        vc.bottom = AmityCommunityFeedViewController.make(communityId: communityId)
        vc.settings = settings
        return vc
        
    }
    
    override func headerViewController() -> UIViewController {
        return header
    }
    
    override func bottomViewController() -> UIViewController & AmityProfilePagerAwareProtocol {
        return bottom
    }
    
    override func minHeaderHeight() -> CGFloat {
        return topInset
    }
    
    public override func didTapLeftBarButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.retriveCommunity()
    }
    
    // MARK: - Setup views
    private func setupFeed() {
        header.didUpdatePostBanner = { [weak self] in
            self?.bottom.handleRefreshFeed()
        }
        
        bottom.dataDidUpdateHandler = { [weak self] in
            self?.header.updatePostsCount()
        }
    }
    private func setupPostButton() {
        postButton.image = AmityIconSet.iconCreatePost
        postButton.add(to: view, position: .bottomRight)
        postButton.actionHandler = { [weak self] button in
            self?.postAction()
        }
    }
    
    private func setupNavigationItemOption(show isJoined: Bool) {
        let item = UIBarButtonItem(image: AmityIconSet.iconOption, style: .plain, target: self, action: #selector(optionTap))
        item.tintColor = AmityColorSet.base
        
        let shareItem = UIBarButtonItem(image: AmityIconSet.iconShare, style: .plain, target: self, action: #selector(shareCommunityProfile))
        item.tintColor = AmityColorSet.base
        
        var items: [UIBarButtonItem] = []
        if isJoined { items.append(item) }
        items.append(shareItem)
        
        navigationItem.rightBarButtonItems = items
    }
    
    private func showCommunitySettingModal() {
        if AmityCommunityProfilePageViewController.newCreatedCommunityIds.contains(screenViewModel.dataSource.communityId) {
            let firstAction = AmityDefaultModalModel.Action(title: AmityLocalizedStringSet.communitySettings,
                                                          textColor: AmityColorSet.baseInverse,
                                                          backgroundColor: AmityColorSet.primary)
            let secondAction = AmityDefaultModalModel.Action(title: AmityLocalizedStringSet.skipForNow,
                                                           textColor: AmityColorSet.primary,
                                                           font: AmityFontSet.body,
                                                           backgroundColor: .clear)

            let communitySettingsModel = AmityDefaultModalModel(image: AmityIconSet.iconMagicWand,
                                                              title: AmityLocalizedStringSet.Modal.communitySettingsTitle,
                                                              description: AmityLocalizedStringSet.Modal.communitySettingsDesc,
                                                              firstAction: firstAction,
                                                              secondAction: secondAction,
                                                              layout: .vertical)
            let communitySettingsModalView = AmityDefaultModalView.make(content: communitySettingsModel)
            communitySettingsModalView.firstActionHandler = {
                AmityHUD.hide { [weak self] in
                    self?.screenViewModel.action.route(.settings)
                }
            }
            
            communitySettingsModalView.secondActionHandler = {
                AmityHUD.hide()
            }
        
            AmityHUD.show(.custom(view: communitySettingsModalView))
            AmityCommunityProfilePageViewController.newCreatedCommunityIds.remove(screenViewModel.dataSource.communityId)
        }
    }
    
}

// MARK: - Action
private extension AmityCommunityProfilePageViewController {
    @objc func optionTap() {
        screenViewModel.action.route(.settings)
    }
    
    @objc func shareCommunityProfile() {
        if let communityModel: AmityCommunityModel = screenViewModel.dataSource.community {
            let communityModelExternal: AmityCommunityModelExternal = AmityCommunityModelExternal(object: communityModel)
            AmityEventHandler.shared.shareCommunityProfileDidTap(from: self, communityModelExternal: communityModelExternal)
        }
    }
    
    func postAction() {
        AmityEventHandler.shared.communityCreatePostButtonTracking(screenName: ScreenName.communityProfile.rawValue)
        screenViewModel.action.route(.post)
    }
}

extension AmityCommunityProfilePageViewController: AmityCommunityProfileScreenViewModelDelegate {
    
    func screenViewModelDidGetCommunity(with community: AmityCommunityModel) {
        postButton.isHidden = !community.isJoined
        header.updateView()
        setupNavigationItemOption(show: community.isJoined)
        AmityHUD.hide()
    }
    
    func screenViewModelFailure() {
        AmityHUD.hide {
            AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
        }
    }
    
    func screenViewModelRoute(_ viewModel: AmityCommunityProfileScreenViewModel, route: AmityCommunityProfileRoute) {
        switch route {
        case .post:
            guard let community = viewModel.community else { return }
            let vc = AmityPostCreatorViewController.make(postTarget: .community(object: community.object))
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
//            AmityEventHandler.shared.createPostBeingPrepared(from: self, postTarget: .community(object: community.object))
        case .member:
            guard let community = viewModel.community else { return }
            let vc = AmityCommunityMemberSettingsViewController.make(community: community.object)
            navigationController?.pushViewController(vc, animated: true)
        case .settings:
            guard let community = viewModel.community else { return }
            let vc = AmityCommunitySettingsViewController.make(communityId: community.communityId)
            navigationController?.pushViewController(vc, animated: true)
        case .editProfile:
            guard let community = viewModel.community else { return }
            let vc = AmityCommunityEditorViewController.make(withCommunityId: community.communityId)
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .pendingPosts:
            let vc = AmityPendingPostsViewController.make(communityId: viewModel.communityId)
            navigationController?.pushViewController(vc, animated: true)
        case .deeplinksPost(id: let id):
            let viewController = AmityPostDetailViewController.make(withPostId: id)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    
}

extension AmityCommunityProfilePageViewController: AmityRefreshable {
    
    func handleRefreshing() {
        screenViewModel.action.retriveCommunity()
    }

}

extension AmityCommunityProfilePageViewController: AmityCommunityProfileEditorViewControllerDelegate {

    public func viewController(_ viewController: AmityCommunityProfileEditorViewController, didFinishCreateCommunity communityId: String) {
        AmityEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }

    public func viewController(_ viewController: AmityCommunityProfileEditorViewController, didFailWithNoPermission: Bool) {
        navigationController?.popToRootViewController(animated: true)
    }

}

//MARK: NCC
private extension AmityCommunityProfilePageViewController {
    func routeToDeeplinksPostIfNeed() {
        if !screenViewModel.dataSource.fromDeeplinks { return }
        
        guard let postId = screenViewModel.dataSource.postId else { return }
        
        screenViewModel.action.route(.deeplinksPost(id: postId))
    }
}
