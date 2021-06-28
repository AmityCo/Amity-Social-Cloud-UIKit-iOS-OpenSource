//
//  AmityCommunityProfilePageViewController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

public class AmityCommunityProfilePageSettings {
    public init() { }
    public var shouldChatButtonHide: Bool = true
}

/// A view controller for providing community profile and community feed.
public final class AmityCommunityProfilePageViewController: AmityProfileViewController {
    
    static var newCreatedCommunityIds =  Set<String>()
    
    // MARK: - Properties
    private var settings: AmityCommunityProfilePageSettings!
    private var header: AmityCommunityProfileHeaderViewController!
    private var bottom: AmityCommunityFeedViewController!
    private var postButton: AmityFloatingButton = AmityFloatingButton()
    
    private var screenViewModel: AmityCommunityProfileScreenViewModelType!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        screenViewModel.delegate = self
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setBackgroundColor(with: .white)
        screenViewModel.action.getCommunity()
        screenViewModel.action.getUserRole()
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
    
    public static func make(withCommunityId communityId: String, settings: AmityCommunityProfilePageSettings = AmityCommunityProfilePageSettings()) -> AmityCommunityProfilePageViewController {
        let viewModel: AmityCommunityProfileScreenViewModelType = AmityCommunityProfileScreenViewModel(communityId: communityId)
        let vc = AmityCommunityProfilePageViewController()
        vc.screenViewModel = viewModel
        vc.header = AmityCommunityProfileHeaderViewController.make(with: viewModel, settings: settings)
        vc.bottom = AmityCommunityFeedViewController.make(communityId: communityId)
        vc.settings = settings
        return vc
    }
    
    public override func didTapLeftBarButton() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Setup view
private extension AmityCommunityProfilePageViewController {
    func setupView() {
        setupPostButton()
    }
    
    func setupPostButton() {
        postButton.image = AmityIconSet.iconCreatePost
        postButton.add(to: view, position: .bottomRight)
        postButton.actionHandler = { [weak self] button in
            self?.postAction()
        }
    }
    
    func setupNavigationItem(with isJoined: Bool) {
        let item = UIBarButtonItem(image: AmityIconSet.iconOption, style: .plain, target: self, action: #selector(optionTap))
        item.tintColor = AmityColorSet.base
        navigationItem.rightBarButtonItem = isJoined ? item : nil
    }
    
}

// MARK: - Action
private extension AmityCommunityProfilePageViewController {
    
    @objc func optionTap() {
        screenViewModel.action.route(.settings)
    }
    
    func postAction() {
        screenViewModel.action.route(.post)
    }
}

// MARK: - Refreshable
extension AmityCommunityProfilePageViewController: AmityRefreshable {
    func handleRefreshing() {
        screenViewModel.action.getCommunity()
    }
}

// MARK: - Screen ViewModel Delegate
extension AmityCommunityProfilePageViewController: AmityCommunityProfileScreenViewModelDelegate {
    func screenViewModelDidGetCommunity(with community: AmityCommunityModel) {
        setupNavigationItem(with: community.isJoined)
        header.update(with: community)
    }
    
    /// Routing to another scenes
    /// - Parameter route: to destination view
    func screenViewModelRoute(_ viewModel: AmityCommunityProfileScreenViewModel, route: AmityCommunityProfileRoute) {
        switch route {
        case .member:
            if let community = viewModel.community?.object {
                let vc = AmityCommunityMemberSettingsViewController.make(community: community)
                navigationController?.pushViewController(vc, animated: true)
            }
        case .editProfile:
            let vc = AmityCommunityEditorViewController.make(withCommunityId: viewModel.communityId)
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .post:
            guard let community = viewModel.community?.object else { return }
            let vc = AmityPostCreatorViewController.make(postTarget: .community(object: community))
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .settings:
            if let community = viewModel.community {
                let vc = AmityCommunitySettingsViewController.make(community: community)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func screenViewModelDidJoinCommunitySuccess() {
        AmityHUD.hide()
    }
    
    func screenViewModelDidJoinCommunity(_ status: AmityCommunityProfileScreenViewModel.CommunityJoinStatus) {
        postButton.isHidden = status == .notJoin
    }
    
    func screenViewModelFailure() {
        AmityHUD.hide {
            AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
        }
    }
    
    func screenViewModelShowCommunitySettingsModal(_ viewModel: AmityCommunityProfileScreenViewModel, withModel model: AmityDefaultModalModel) {
        let communitySettingsModalView = AmityDefaultModalView.make(content: model)
        communitySettingsModalView.firstActionHandler = {
            AmityHUD.hide { [weak self] in
                self?.screenViewModel.action.route(.settings)
            }
        }
        
        communitySettingsModalView.secondActionHandler = {
            AmityHUD.hide()
        }
    
        AmityHUD.show(.custom(view: communitySettingsModalView))
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
