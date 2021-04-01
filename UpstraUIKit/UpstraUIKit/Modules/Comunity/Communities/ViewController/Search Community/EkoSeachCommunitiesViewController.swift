//
//  EkoSeachCommunitiesViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 23/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoSearchCommunityViewController: EkoSearchViewController {
    
    private var screenViewModel: EkoCommunitiesScreenViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyCommunity()
    }
    
    static func make(for viewController: UIViewController?, searchType: EkoSearchViewController.SearchType) -> EkoSearchCommunityViewController {
        var viewModel: EkoCommunitiesScreenViewModelType
        if searchType == .inTableView {
            viewModel = EkoCommunitiesScreenViewModel(listType: .myCommunities)
        } else {
            viewModel = EkoCommunitiesScreenViewModel(listType: .searchCommunities)
        }
        
        let viewControlelr = EkoSearchCommunityViewController(for: viewController, searchType: searchType)
        viewModel.delegate = viewControlelr
        viewControlelr.screenViewModel = viewModel
        return viewControlelr
    }

    private func setupView() {
        definesPresentationContext = true
        emptyText = EkoLocalizedStringSet.searchCommunityNotFound.localizedString
        tableView.register(EkoMyCommunityTableViewCell.nib, forCellReuseIdentifier: EkoMyCommunityTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset.left = view.frame.width
        
        if searchType == .inTableView {
            title = EkoLocalizedStringSet.myCommunityTitle.localizedString
            let rightItem = UIBarButtonItem(image: EkoIconSet.iconAdd, style: .plain, target: self, action: #selector(createCommunityTap))
            rightItem.tintColor = EkoColorSet.base
            navigationItem.rightBarButtonItem = rightItem
            navigationController?.reset()
        }
    }
}

// MARK: - Action
private extension EkoSearchCommunityViewController {
    @objc func createCommunityTap() {
        let vc = EkoCommunityProfileEditViewController.make(viewType: .create)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - Binding Search
private extension EkoSearchCommunityViewController {
    
    func bindingSearch() {
        cellForRowHandler = { [weak self] (tableView, indexPath) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: EkoMyCommunityTableViewCell.identifier, for: indexPath)
            self?.configure(tableView, for: cell, at: indexPath)
            return cell
        }
        
        selectedItemHandler = { [weak self] (indexPath) in
            guard let strongSelf = self else { return }
            let communityId = strongSelf.screenViewModel.dataSource.community(at: indexPath).communityId
            EkoEventHandler.shared.communityDidTap(from: strongSelf, communityId: communityId)
        }
        
        numberOfRowHandler = { [weak self] section in
            return self?.screenViewModel.dataSource.communities.count ?? 0
        }
        
        searchTextDidChangeHandler = { [weak self] text in
            self?.screenViewModel.search(with: text)
        }
        
        searchCancelHandler = { [weak self] in
            if self?.searchType == .inTableView {
                self?.screenViewModel.action.search(with: "")
            } else {
                self?.screenViewModel.action.resetData()
            }
        }
    }
    
    func configure(_ tableView: UITableView, for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoMyCommunityTableViewCell {
            let community = screenViewModel.dataSource.community(at: indexPath)
            cell.display(with: community)
            cell.delegate = self
            if tableView.isBottomReached {
                screenViewModel.action.loadMore()
            }
        }
    }
}

// MARK: - EkoMyCommunityTableViewCellDelegate
extension EkoSearchCommunityViewController: EkoMyCommunityTableViewCellDelegate {
    func cellDidTapOnAvatar(_ cell: EkoMyCommunityTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let community = screenViewModel.dataSource.community(at: indexPath)
        EkoEventHandler.shared.communityDidTap(from: self, communityId: community.communityId)
    }
}

// MARK: - Binding ViewModel
private extension EkoSearchCommunityViewController {
    
    func getMyCommunity() {
        if searchType == .inTableView {
            screenViewModel.action.search(with: "")
        }
    }
    
}

extension EkoSearchCommunityViewController: EkoCommunitiesScreenViewModelDelegate {
    
    func screenViewModel(_ model: EkoCommunitiesScreenViewModelType, didUpdateCommunities communities: [EkoCommunityModel]) {
        tableView.reloadData()
    }
    
    func screenViewModel(_ model: EkoCommunitiesScreenViewModelType, didUpdateLoadingState loadingState: EkoLoadingState) {
        switch loadingState {
        case .loading:
            tableView.showLoadingIndicator()
        case .loaded:
            tableView.tableFooterView = nil
        case .initial:
            break
        }
    }
    
}

extension EkoSearchCommunityViewController: EkoCommunityProfileEditViewControllerDelegate {
    
    func viewController(_ viewController: EkoCommunityProfileEditViewController, didFinishCreateCommunity communityId: String) {
        EkoEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
}
