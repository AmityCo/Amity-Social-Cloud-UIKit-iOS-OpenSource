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
    
    private let screenViewModel: EkoCommunitiesScreenViewModelType
    
    private init(for viewController: UIViewController? = nil, duration: TimeInterval = 0.2, searchType: EkoSearchViewController.SearchType, viewModel: EkoCommunitiesScreenViewModelType) {
        self.screenViewModel = viewModel
        super.init(for: viewController, duration: duration, searchType: searchType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        emptyText = EkoLocalizedStringSet.searchCommunityNotFound
        tableView.register(EkoMyCommunityTableViewCell.nib, forCellReuseIdentifier: EkoMyCommunityTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset.left = view.frame.width
        setupView()
        bindingSearch()
        bindingViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyCommunity()
    }
    
    static func make(for viewController: UIViewController?, searchType: EkoSearchViewController.SearchType) -> EkoSearchCommunityViewController {
        let viewModel: EkoCommunitiesScreenViewModelType
        let vc: EkoSearchCommunityViewController
        if searchType == .inTableView {
            viewModel = EkoCommunitiesScreenViewModel(listType: .myCommunities)
            vc = EkoSearchCommunityViewController(searchType: .inTableView, viewModel: viewModel)
        } else {
            viewModel = EkoCommunitiesScreenViewModel(listType: .searchCommunities)
            vc = EkoSearchCommunityViewController(for: viewController, searchType: searchType, viewModel: viewModel)
        }
        return vc
    }

    private func setupView() {
        if searchType == .inTableView {
            title = EkoLocalizedStringSet.myCommunityTitle
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
        screenViewModel.action.route(to: .create)
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
        
        selectedItemHandler = ({ [weak self] (indexPath) in
            self?.screenViewModel.action.route(to: .communityProfile(indexPath: indexPath))
        })
        
        numberOfRowHandler = { [weak self] section in
            return self?.screenViewModel.dataSource.searchCommunities.value.count ?? 0
        }
        
        searchTextDidChangeHandler = { [weak self] text in
            self?.screenViewModel.search(with: text)
        }
        
        searchCancelHandler = { [weak self] in
            if self?.searchType == .inTableView {
                self?.screenViewModel.action.search(with: "")
            } else {
                self?.screenViewModel.action.reset()
                self?.tableView.reloadData()
            }
        }
    }
    
    func configure(_ tableView: UITableView, for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoMyCommunityTableViewCell {
            let community = screenViewModel.dataSource.community(at: indexPath)
            cell.display(with: community)
            if tableView.isBottomReached {
                screenViewModel.action.loadMore()
            }
        }
    }
}

// MARK: - Binding ViewModel
private extension EkoSearchCommunityViewController {
    
    func getMyCommunity() {
        if searchType == .inTableView {
            screenViewModel.action.search(with: "")
        }
    }
    
    func bindingViewModel() {
        screenViewModel.dataSource.searchCommunities.bind { [weak self] communities in
            self?.tableView.reloadData()
        }
        
        screenViewModel.dataSource.route.bind { [weak self] route in
            guard let strongSelf = self else { return }
            switch route {
            case .initial:
                break
            case .communityProfile(let indexPath):
                let communityId = strongSelf.screenViewModel.dataSource.community(at: indexPath).communityId
                EkoEventHandler.shared.communityDidTap(from: strongSelf, communityId: communityId)
            case .myCommunity:
                break
            case .create:
                let vc = EkoCommunityProfileEditViewController.make(viewType: .create)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true, completion: nil)
            }
        }
        
        screenViewModel.dataSource.loading.bind { (state) in
            switch state {
            case .loadmore:
                self.tableView.showLoadingIndicator()
            case .loaded:
                self.tableView.tableFooterView = nil
            default: break
            }
        }
    }
}
