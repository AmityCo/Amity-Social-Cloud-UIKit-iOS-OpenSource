//
//  AmityCommunitySearchViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityCommunitySearchViewController: AmityViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private var screenViewModel: AmityCommunitySearchScreenViewModelType!
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var emptyView = AmitySearchEmptyView()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchController()
        setupTableView()
        setupScreenViewModle()
    }
    
    static func make() -> AmityCommunitySearchViewController {
        let communityListRepositoryManager = AmityCommunityListRepositoryManager()
        let viewModel = AmityCommunitySearchScreenViewModel(communityListRepositoryManager: communityListRepositoryManager)
        let vc = AmityCommunitySearchViewController(nibName: AmityCommunitySearchViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Setup viewModel
    private func setupScreenViewModle() {
        screenViewModel.delegate = self
    }
    
    // MARK: - Setup views
    private func setupView() {
        navigationBarType = .custom
    }
    
    private func setupSearchController() {
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = AmityLocalizedStringSet.search.localizedString
        searchController.searchBar.tintColor = AmityColorSet.base
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.backgroundColor = AmityColorSet.backgroundColor
        searchController.searchBar.barTintColor = AmityColorSet.backgroundColor
        
        (searchController.searchBar.value(forKey: "cancelButton") as? UIButton)?.tintColor = AmityColorSet.base
        
        if #available(iOS 13, *) {
            searchController.searchBar.searchTextField.backgroundColor = AmityColorSet.secondary.blend(.shade4)
            searchController.searchBar.searchTextField.textColor = AmityColorSet.base
            searchController.searchBar.searchTextField.leftView?.tintColor = AmityColorSet.base.blend(.shade2)
        } else {
            if let textField = (searchController.searchBar.value(forKey: "searchField") as? UITextField) {
                textField.backgroundColor = AmityColorSet.secondary.blend(.shade4)
                textField.tintColor = AmityColorSet.base
                textField.textColor = AmityColorSet.base
                textField.leftView?.tintColor = AmityColorSet.base.blend(.shade2)
            }
        }
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setShowsCancelButton(true, animated: true)
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupTableView() {
        tableView.register(cell: AmityMyCommunityTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorColor = .clear
    }
}

extension AmityCommunitySearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        screenViewModel.action.search(withText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        screenViewModel.action.search(withText: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        screenViewModel.action.search(withText: searchBar.text)
        searchBar.resignFirstResponder()
    }
}

extension AmityCommunitySearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let communityId = screenViewModel.dataSource.item(at: indexPath)?.communityId else { return }
        AmityEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isBottomReached {
            screenViewModel.action.loadMore()
        }
    }
    
}

extension AmityCommunitySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfCommunity()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AmityMyCommunityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        guard let community = screenViewModel.dataSource.item(at: indexPath) else { return UITableViewCell() }
        cell.display(with: community)
        cell.delegate = self
        return cell
    }
}

extension AmityCommunitySearchViewController: AmityMyCommunityTableViewCellDelegate {
    func cellDidTapOnAvatar(_ cell: AmityMyCommunityTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let community = screenViewModel.dataSource.item(at: indexPath) else { return }
        AmityEventHandler.shared.communityDidTap(from: self, communityId: community.communityId)
    }
}

extension AmityCommunitySearchViewController: AmityCommunitySearchScreenViewModelDelegate {
    
    func screenViewModelDidSearch(_ viewModel: AmityCommunitySearchScreenViewModelType) {
        emptyView.removeFromSuperview()
    }
    
    func screenViewModelDidClearText(_ viewModel: AmityCommunitySearchScreenViewModelType) {
        emptyView.removeFromSuperview()
    }
    
    func screenViewModelDidSearchNotFound(_ viewModel: AmityCommunitySearchScreenViewModelType) {
        tableView.setEmptyView(view: emptyView)
    }
    
    func screenViewModel(_ viewModel: AmityCommunitySearchScreenViewModelType, loadingState: AmityLoadingState) {
        switch loadingState {
        case .initial:
            break
        case .loading:
            emptyView.removeFromSuperview()
            tableView.showLoadingIndicator()
            tableView.reloadData()
        case .loaded:
            tableView.tableFooterView = UIView()
            tableView.reloadData()
        }
    }
}
