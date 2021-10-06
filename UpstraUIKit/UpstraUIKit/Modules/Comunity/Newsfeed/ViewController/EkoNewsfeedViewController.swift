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
    private var communityViewModel: EkoCommunitiesScreenViewModelType!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupFeedView()
        setupHeaderView()
        setupEmptyView()
        setupPostButton()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        communityViewModel.action.search(with: "")
    }
    
    public static func make() -> EkoNewsfeedViewController {
        let communityViewModel = EkoCommunitiesScreenViewModel(listType: .newsfeedMyCommunities)
        let vc = EkoNewsfeedViewController(nibName: nil, bundle: nil)
        vc.communityViewModel = communityViewModel
        communityViewModel.delegate = vc
        return vc
    }
}

// MARK: - Setup view
private extension EkoNewsfeedViewController {
    
    private func setupFeedView() {
        addChild(viewController: feedViewController)
        feedViewController.dataDidUpdateHandler = { [weak self] itemCount in
            self?.createPostButton.isHidden = (itemCount == 0)
        }
        
        feedViewController.pullRefreshhHandler = { [weak self] in
            self?.communityViewModel.action.search(with: "")
        }
    }
    
    private func setupHeaderView() {
        headerView = EkoMyCommunityPreviewViewController.make()
        headerView?.delegate = self
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

extension EkoNewsfeedViewController: EkoCommunityProfileEditViewControllerDelegate {
    
    func viewController(_ viewController: EkoCommunityProfileEditViewController, didFinishCreateCommunity communityId: String) {
        EkoEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
}

extension EkoNewsfeedViewController: EkoCommunitiesScreenViewModelDelegate {
    
    func screenViewModel(_ model: EkoCommunitiesScreenViewModelType, didUpdateCommunities communities: [EkoCommunityModel]) {
        headerView?.configure(with: communities)
        feedViewController.headerView = communities.count > 0 ? headerView?.view : nil
    }
    
    func screenViewModel(_ model: EkoCommunitiesScreenViewModelType, didUpdateLoadingState loadingState: EkoLoadingState) {
        // Intentionally left empty
    }
    
}

extension EkoNewsfeedViewController: EkoMyCommunityPreviewViewControllerDelegate {
    
    public func viewController(_ viewController: EkoMyCommunityPreviewViewController, didPerformAction action: EkoMyCommunityPreviewViewController.ActionType) {
        switch action {
        case .seeAll:
            let vc = EkoMyCommunityViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .communityItem(indexPath: let indexPath):
            let communityId = communityViewModel.dataSource.community(at: indexPath).communityId
            EkoEventHandler.shared.communityDidTap(from: self, communityId: communityId)
        }
    }
    
}
