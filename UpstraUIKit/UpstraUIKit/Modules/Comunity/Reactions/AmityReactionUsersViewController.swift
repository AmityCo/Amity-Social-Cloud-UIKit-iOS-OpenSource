//
//  AmityReactionUsersViewController.swift
//  AmityUIKit
//
//  Created by Amity on 26/4/2566 BE.
//  Copyright © 2566 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

public struct AmityReactionInfo {
    /// Reference Id of reaction
    public let referenceId: String
    
    /// Reference type of reaction
    public let referenceType: AmityReactionReferenceType
    
    /// Total count of this reactions. This appears in ViewPager title.
    public let reactionsCount: Int
    
    public init(referenceId: String, referenceType: AmityReactionReferenceType, reactionsCount: Int) {
        self.referenceId = referenceId
        self.referenceType = referenceType
        self.reactionsCount = reactionsCount
    }
}

/// Class for showing list of users who created particular reaction.
public final class AmityReactionUsersViewController: AmityViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    let reactionsInfo: AmityReactionInfo
    let viewModel: AmityReactionUsersScreenViewModel
    
    let emptyState = AmityEmptyView()
    let refreshControl = UIRefreshControl()
    
    required init(info: AmityReactionInfo) {
        self.reactionsInfo = info
        self.viewModel = AmityReactionUsersScreenViewModel(info: reactionsInfo)
        super.init(nibName: AmityReactionUsersViewController.identifier, bundle: AmityUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupScreenViewModel()
    }
    
    func setupScreenViewModel() {
        viewModel.observeScreenState = { [weak self] currentState in
            guard let weakSelf = self else { return }
            
            switch currentState {
                // When view is loaded for the first time
            case .initial:
                // Show skeleton loading view
                weakSelf.viewModel.loadDummyDataSet()
                weakSelf.tableView.reloadData()
                
                // Reset empty states
                weakSelf.resetViewState()
                
                // When data is being fetched from server
            case .loading(let isPagination):
                if isPagination {
                    weakSelf.tableView.showLoadingIndicator()
                }
                // When data fetching is complete.
            case .loaded(let data, let error):
                // Reset state
                weakSelf.resetViewState()
                // Removes skeleton view + reload data if available
                weakSelf.tableView.reloadData()
                
                if let error {
                    if data.isEmpty {
                        weakSelf.showEmptyState()
                    } else {
                        AmityHUD.show(.error(message: AmityLocalizedStringSet.somethingWentWrongWithTryAgain))
                    }
                } else if data.isEmpty && error == nil {
                     weakSelf.showEmptyState()
                }
            }
        }
        
        // Fetch list of users
        viewModel.fetchUserList()
    }

    private func setupViews() {
        title = AmityLocalizedStringSet.Reaction.reactionTitle.localizedString
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        tableView.register(cell: AmityReactionUserTableViewCell.self)
        tableView.register(cell: AmityReactionUserSkeletonCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
    }
    
    private func showEmptyState() {
        emptyState.update(title: AmityLocalizedStringSet.Reaction.emptyStateTitle.localizedString, subtitle: AmityLocalizedStringSet.Reaction.emptyStateSubtitle.localizedString, image: AmityIconSet.emptyReaction)
        tableView.setEmptyView(view: emptyState)
    }
    
    private func hideEmptyState() {
        emptyState.removeFromSuperview()
    }
    
    private func resetViewState() {
        tableView.tableFooterView = nil
        hideEmptyState()
        refreshControl.endRefreshing()
    }
    
    @objc private func refreshData() {
        viewModel.fetchUserList()
    }
    
    /// Ininitializes instance of AmityReactionUsersViewController.
    public class func make(with info: AmityReactionInfo) -> Self {
        return self.init(info: info)
    }
    
    private func showUserProfileScreen(for userId: String) {
        // Show profile view
        AmityEventHandler.shared.userDidTap(from: self, userId: userId)
    }
}

extension AmityReactionUsersViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: AmityPagerTabViewController) -> IndicatorInfo {
        // Default tab title
        var tabTitle = AmityLocalizedStringSet.General.generalAll.localizedString
        
        // Tab title if there is any reactions.
        if reactionsInfo.reactionsCount > 0 {
            tabTitle = AmityLocalizedStringSet.General.generalAll.localizedString + " " +  reactionsInfo.reactionsCount.formatUsingAbbrevation()
        }
        
        return IndicatorInfo(title: tabTitle)
    }
}

extension AmityReactionUsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reactionList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.currentScreenState {
        case .initial:
            let cell: AmityReactionUserSkeletonCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .loading(let isPagination):
            if isPagination {
                fallthrough
            } else {
                let cell: AmityReactionUserSkeletonCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            }

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: AmityReactionUserTableViewCell.identifier, for: indexPath) as! AmityReactionUserTableViewCell

            let reactionUser = viewModel.reactionList[indexPath.row]
            cell.display(with: reactionUser)
            cell.avatarTapAction = { [weak self] in
                guard let weakSelf = self else { return }
                // Show profile view
                weakSelf.showUserProfileScreen(for: reactionUser.userId)
            }
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .loaded = viewModel.currentScreenState else { return }

        // Show profile view
        let reactionUser = viewModel.reactionList[indexPath.row]
        self.showUserProfileScreen(for: reactionUser.userId)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case .loaded = viewModel.currentScreenState, tableView.isBottomReached else { return }
        
        viewModel.loadMoreUsers()
    }
}
