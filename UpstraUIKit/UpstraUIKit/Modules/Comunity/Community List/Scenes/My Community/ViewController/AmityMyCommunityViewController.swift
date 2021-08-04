//
//  AmityMyCommunityViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

/// A view controller for providing all community list.
public final class AmityMyCommunityViewController: AmityViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private var searchController = UISearchController(searchResultsController: nil)
    private var emptyView = AmitySearchEmptyView()
    private var screenViewModel: AmityMyCommunityScreenViewModelType!
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchController()
        setupTableView()
        setupScreenViewModel()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.text = screenViewModel.dataSource.searchText
    }
    
    public static func make() -> AmityMyCommunityViewController {
        let communityListRepositoryManager = AmityCommunityListRepositoryManager()
        let viewModel = AmityMyCommunityScreenViewModel(communityListRepositoryManager: communityListRepositoryManager)
        let vc = AmityMyCommunityViewController(nibName: AmityMyCommunityViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Setup viewModel
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.retrieveAllCommunity()
    }
    
    // MARK: - Setup views
    private func setupView() {
        title = AmityLocalizedStringSet.myCommunityTitle.localizedString
        if communityCreationButtonVisible() {
            let rightItem = UIBarButtonItem(image: AmityIconSet.iconAdd, style: .plain, target: self, action: #selector(createCommunityTap))
            rightItem.tintColor = AmityColorSet.base
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    
    private func communityCreationButtonVisible() -> Bool {
        // The default visibility of this button.
        var visible = true
        // If someone override this env, we then force visibility to be that value.
        if let overrideVisible = AmityUIKitManagerInternal.shared.env["amity_uikit_social_community_creation_button_visible"] as? Bool {
            visible = overrideVisible
        }
        return visible
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = AmityLocalizedStringSet.General.search.localizedString
        searchController.searchBar.tintColor = AmityColorSet.base
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.backgroundImage = UIImage()
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
    }
    
    private func setupTableView() {
        tableView.tableHeaderView = searchController.searchBar
        tableView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        tableView.register(cell: AmityMyCommunityTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorColor = .clear
        
        emptyView.topMargin = 100
    }
    
}

private extension AmityMyCommunityViewController {
    @objc func createCommunityTap() {
        let vc = AmityCommunityCreatorViewController.make()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

extension AmityMyCommunityViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        searchController.searchBar.text = screenViewModel.dataSource.searchText
        guard let communityId = screenViewModel.dataSource.item(at: indexPath)?.communityId else { return }
        AmityEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isBottomReached {
            screenViewModel.action.loadMore()
        }
    }
    
}

extension AmityMyCommunityViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfCommunity()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AmityMyCommunityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        guard let community = screenViewModel.dataSource.item(at: indexPath) else { return UITableViewCell() }
        cell.display(with: community)
        cell.delegate = self
        return cell
    }
}

extension AmityMyCommunityViewController: AmityMyCommunityTableViewCellDelegate {
    
    func cellDidTapOnAvatar(_ cell: AmityMyCommunityTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        searchController.isActive = false
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        searchController.searchBar.text = screenViewModel.dataSource.searchText
        guard let community = screenViewModel.dataSource.item(at: indexPath) else { return }
        AmityEventHandler.shared.communityDidTap(from: self, communityId: community.communityId)
    }
    
}

extension AmityMyCommunityViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        screenViewModel.action.search(withText: searchText)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        screenViewModel.action.searchCancel()
        screenViewModel.action.retrieveAllCommunity()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        screenViewModel.action.search(withText: searchBar.text)
        searchBar.resignFirstResponder()
    }
}

extension AmityMyCommunityViewController: AmityMyCommunityScreenViewModelDelegate {
    
    func screenViewModelDidRetrieveAllCommunity(_ viewModel: AmityMyCommunityScreenViewModelType) {
        emptyView.removeFromSuperview()
    }
    
    func screenViewModelDidSearch(_ viewModel: AmityMyCommunityScreenViewModelType) {
        emptyView.removeFromSuperview()
    }

    func screenViewModelDidSearchNotFound(_ viewModel: AmityMyCommunityScreenViewModelType) {
        tableView.setEmptyView(view: emptyView)
    }
    
    func screenViewModelDidSearchCancel(_ viewModel: AmityMyCommunityScreenViewModelType) {
    }
    
    func screenViewModel(_ viewModel: AmityMyCommunityScreenViewModelType, loadingState: AmityLoadingState) {
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

extension AmityMyCommunityViewController: AmityCommunityProfileEditorViewControllerDelegate {
    
    public func viewController(_ viewController: AmityCommunityProfileEditorViewController, didFinishCreateCommunity communityId: String) {
        AmityEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
}
