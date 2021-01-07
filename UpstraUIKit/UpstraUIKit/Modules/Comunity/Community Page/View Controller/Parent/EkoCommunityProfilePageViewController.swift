//
//  EkoCommunityProfilePageViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 10/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

public class EkoCommunityProfilePageSettings {
    public init() { }
    public var shouldChatButtonHide: Bool = true
}

/// A view controller for providing community profile and community feed.
public final class EkoCommunityProfilePageViewController: EkoProfileViewController, EkoRefreshable {
    
    // MARK: - Properties
    
    private let settings: EkoCommunityProfilePageSettings
    private let header: EkoCommunityProfileHeaderViewController
    private let bottom: EkoCommunityFeedViewController
    private let postButton: EkoFloatingButton = EkoFloatingButton()
    
    private let screenViewModel: EkoCommunityProfileScreenViewModelType
    
    private init(viewModel: EkoCommunityProfileScreenViewModelType, settings: EkoCommunityProfilePageSettings) {
        self.screenViewModel = viewModel
        self.header = EkoCommunityProfileHeaderViewController.make(with: screenViewModel, settings: settings)
        self.bottom = EkoCommunityFeedViewController.make(communityId: viewModel.communityId)
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
        screenViewModel.action.getInfo()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setBackgroundColor(with: .white)
    }
        
    override func didTapLeftBarButton() {
        if parent?.presentingViewController != nil {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func headerViewController() -> UIViewController {
        return header
    }
    
    override func bottomViewController() -> UIViewController & EkoProfilePagerAwareProtocol {
        return bottom
    }
    
    override func minHeaderHeight() -> CGFloat {
        return topInset
    }
    
    public static func make(withCommunityId communityId: String, settings: EkoCommunityProfilePageSettings = EkoCommunityProfilePageSettings()) -> EkoCommunityProfilePageViewController {
        let screenViewModel = EkoCommunityProfileScreenViewModel(communityId: communityId)
        let vc = EkoCommunityProfilePageViewController(viewModel: screenViewModel, settings: settings)
        return vc
    }
    
    private func setupView() {
        setupPostButton()
    }
    
    private func setupNavigationItem(with isJoined: Bool) {
        let item = UIBarButtonItem(image: EkoIconSet.iconOption, style: .plain, target: self, action: #selector(optionTap))
        item.tintColor = EkoColorSet.base
        navigationItem.rightBarButtonItem = isJoined ? item : nil
    }
    
    private func setupPostButton() {
        postButton.image = EkoIconSet.iconCreatePost
        postButton.add(to: view, position: .bottomRight)
        postButton.actionHandler = { [weak self] button in
            guard let self = self else { return }
            self.screenViewModel.action.route(to: .post)
        }
    }
    
    // MARK: - Refreshable
    
    func handleRefreshing() {
        screenViewModel.action.getInfo()
    }
    
}

private extension EkoCommunityProfilePageViewController {
    @objc func optionTap() {
        screenViewModel.action.route(to: .settings)
    }
}

// MARK: - Binding ViewModel
private extension EkoCommunityProfilePageViewController {
    func bindingViewModel() {
        
        screenViewModel.dataSource.community.bind { [weak self] in
            guard let community = $0 else { return }
            self?.setupNavigationItem(with: community.isJoined)
            self?.header.update(with: community)
        }
        
        screenViewModel.dataSource.route.bind { [weak self] (route) in
            guard let strongSelf = self else { return }
            switch route {
            case .intial:
                break
            case .post:
                guard let community = strongSelf.screenViewModel.dataSource.community.value else { return }
                let vc = EkoPostTextEditorViewController.make(postTarget: .community(object: community))
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true, completion: nil)
            case .settings:
                let vc = EkoCommunitySettingsViewController.make(viewModel: strongSelf.screenViewModel)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case .editProfile:
                let vc = EkoCommunityProfileEditViewController.make(viewType: .edit(communityId: strongSelf.screenViewModel.dataSource.communityId))
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true, completion: nil)
            case .member:
                let communityId = strongSelf.screenViewModel.dataSource.communityId
                let vc = EkoCommunityMemberSettingsViewController.make(communityId: communityId)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        screenViewModel.dataSource.parentObserveCommunityStatus.bind { [weak self] (status) in
            guard let self = self else { return }
            self.postButton.isHidden = status == .notJoin
        }
    }
}
