//
//  EkoNewsfeedViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 24/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

/// A view controller for providing global feed with create post functionality.
public class EkoNewsfeedViewController: EkoViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: EkoPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
    
    // MARK: - Properties
    var pageTitle: String?
    
    private let emptyView = EkoNewsfeedEmptyView()
    private var headerView: EkoMyCommunityPreviewViewController?
    private let createPostButton: EkoFloatingButton = EkoFloatingButton()
    private let feedViewController = EkoFeedViewController.make(feedType: .globalFeed)
    private let communityViewModel: EkoCommunitiesScreenViewModelType
    
    private init(communityViewModel: EkoCommunitiesScreenViewModelType) {
        self.communityViewModel = communityViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        communityViewModel.action.search(with: "")
    }
    
    public static func make() -> EkoNewsfeedViewController {
        let communityViewModel = EkoCommunitiesScreenViewModel(listType: .newsfeedMyCommunities)
        let vc = EkoNewsfeedViewController(communityViewModel: communityViewModel)
        return vc
    }
}

// MARK: - Setup view
private extension EkoNewsfeedViewController {
    private func setupView() {
        setupFeedView()
        setupHeaderView()
        setupEmptyView()
        setupPostButton()
        bindingViewModel()
    }
    
    private func setupFeedView() {
        addChild(viewController: feedViewController)
        feedViewController.dataDidUpdateHandler = { [weak self] itemCount in
            self?.createPostButton.isHidden = (itemCount == 0)
        }
    }
    
    private func setupHeaderView() {
        headerView = EkoMyCommunityPreviewViewController.make(viewModel: communityViewModel)
        feedViewController.headerView = headerView?.view
    }
    
    private func setupEmptyView() {
        emptyView.exploreHandler = { [weak self] in
            guard let parent = self?.parent as? EkoCommunityHomePageViewController else { return }
            // Switch to explore tap which is an index 1.
            parent.setCurrentIndex(1)
        }
        emptyView.createHandler = { [weak self] in
            let vc = EkoCommunityProfileEditViewController.make(viewType: .create)
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            self?.present(nav, animated: true, completion: nil)
        }
        feedViewController.emptyView = emptyView

    }
    
    private func setupPostButton() {
        createPostButton.add(to: view, position: .bottomRight)
        createPostButton.image = EkoIconSet.iconCreatePost
        createPostButton.actionHandler = { [weak self] _ in
            let vc = EkoPostTargetSelectionViewController.make()
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .fullScreen
            self?.present(nvc, animated: true, completion: nil)
        }
    }
    
}

// MARK: - Binding ViewModel
private extension EkoNewsfeedViewController {
    
    func bindingViewModel() {
        communityViewModel.dataSource.numberOfItems.bind { [weak self] (count) in
            self?.feedViewController.headerView = count > 0 ? self?.headerView?.view : nil
        }
        
        communityViewModel.dataSource.route.bind { [weak self] (route) in
            guard let strongSelf = self else { return }
            switch route {
            case .initial:
                break
            case .myCommunity:
                let vc = EkoMyCommunityViewController.make()
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case .communityProfile(let indexPath):
                let communityId = strongSelf.communityViewModel.dataSource.community(at: indexPath).communityId
                EkoEventHandler.shared.communityDidTap(from: strongSelf, communityId: communityId)
            case .create:
                break
            }
        }
    }
    
}

extension EkoNewsfeedViewController: EkoCommunityProfileEditViewControllerDelegate {
    
    func viewController(_ viewController: EkoCommunityProfileEditViewController, didFinishCreateCommunity communityId: String) {
        EkoEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
}
