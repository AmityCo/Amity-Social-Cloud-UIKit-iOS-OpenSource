//
//  EkoSelectMemberListViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit

public final class EkoSelectMemberListViewController: EkoViewController {

    // MARK: - Callback
    var selectUsersHandler: (([EkoSelectMemberModel]) -> Void)?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var label: UILabel!
    
    // MARK: - Properties
    private var screenViewModel: EkoSelectMemberListScreenViewModelType!
    private var doneButton: UIBarButtonItem?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        screenViewModel.delegate = self
        screenViewModel.action.getUsers()
    }

    public static func make() -> EkoSelectMemberListViewController {
        let viewModeel: EkoSelectMemberListScreenViewModelType = EkoSelectMemberListScreenViewModel()
        let vc = EkoSelectMemberListViewController(nibName: EkoSelectMemberListViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.screenViewModel = viewModeel
        return vc
    }
    
    func getUsersFromCreatePage(users: [EkoSelectMemberModel]) {
        screenViewModel.action.getUserFromCreatePage(users: users)
    }
}

private extension EkoSelectMemberListViewController {
    @objc func doneTap() {
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.selectUsersHandler?(strongSelf.screenViewModel.dataSource.getStoreUsers())
        }
    }
    
    @objc func cancelTap() {
        dismiss(animated: true)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        screenViewModel.action.deselectUser(at: indexPath)
    }
}

private extension EkoSelectMemberListViewController {
    func setupView() {
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
        setupCollectionView()
    }
    
    func setupNavigationBar() {
        navigationBarType = .custom
        view.backgroundColor = EkoColorSet.backgroundColor
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor)
        ])
        navigationItem.titleView = customView
        let numberOfSelectedUseres = screenViewModel.dataSource.numberOfSelectedUsers()
        if numberOfSelectedUseres == 0 {
            title = EkoLocalizedStringSet.selectMemberListTitle
        } else {
            
            title = String.localizedStringWithFormat(EkoLocalizedStringSet.selectMemberListSelectedTitle, "\(numberOfSelectedUseres)")
        }
        
        doneButton = UIBarButtonItem(title: EkoLocalizedStringSet.done, style: .plain, target: self, action: #selector(doneTap))
        doneButton?.tintColor = EkoColorSet.primary
        doneButton?.isEnabled = !(numberOfSelectedUseres == 0)
        
        let cancelButton = UIBarButtonItem(title: EkoLocalizedStringSet.cancel, style: .plain, target: self, action: #selector(cancelTap))
        cancelButton.tintColor = EkoColorSet.base
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func setupSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.tintColor = EkoColorSet.base
        searchBar.returnKeyType = .done
        (searchBar.value(forKey: "searchField") as? UITextField)?.textColor = EkoColorSet.base
        ((searchBar.value(forKey: "searchField") as? UITextField)?.leftView as? UIImageView)?.tintColor = EkoColorSet.base.blend(.shade2)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: EkoSelectMemberListTableViewCell.identifier, bundle: UpstraUIKitManager.bundle), forCellReuseIdentifier: EkoSelectMemberListTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = EkoColorSet.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: EkoSelectMemberListCollectionViewCell.identifier, bundle: UpstraUIKitManager.bundle), forCellWithReuseIdentifier: EkoSelectMemberListCollectionViewCell.identifier)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = screenViewModel.dataSource.numberOfSelectedUsers() == 0
        collectionView.backgroundColor = EkoColorSet.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension EkoSelectMemberListViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        screenViewModel.action.searchUser(with: searchText)
    }
}

extension EkoSelectMemberListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = screenViewModel.dataSource.user(at: indexPath) else { return }
        if !user.isCurrnetUser {
            screenViewModel.action.selectUser(at: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EkoSelectMemberListHeaderView()
        if screenViewModel.dataSource.isSearching() {
            headerView.text = EkoLocalizedStringSet.searchResults
        } else {
            headerView.text = screenViewModel.dataSource.alphabetOfHeader(in: section)
        }
        return headerView
    }
}

extension EkoSelectMemberListViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return screenViewModel.numberOfAlphabet()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfUsers(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EkoSelectMemberListTableViewCell.identifier, for: indexPath)
        configure(tableView, for: cell, at: indexPath)
        return cell
    }
    
    private func configure(_ tableView: UITableView, for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoSelectMemberListTableViewCell {
            guard let user = screenViewModel.dataSource.user(at: indexPath) else { return }
            cell.display(with: user)
            if tableView.isBottomReached {
                screenViewModel.action.loadmore()
            }
        }
    }
}

extension EkoSelectMemberListViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfSelectedUsers()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EkoSelectMemberListCollectionViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoSelectMemberListCollectionViewCell {
            let user = screenViewModel.dataSource.selectUser(at: indexPath)
            cell.indexPath = indexPath
            cell.display(with: user)
            cell.deleteHandler = { [weak self] indexPath in
                self?.deleteItem(at: indexPath)
            }
        }
    }
}

extension EkoSelectMemberListViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension EkoSelectMemberListViewController: EkoSelectMemberListScreenViewModelDelegate {
    
    func screenViewModelDidFetchUser() {
        tableView.reloadData()
    }
    
    func screenViewModelDidSearchUser() {
        tableView.reloadData()
    }
    
    func screenViewModelCanDone(enable: Bool) {
        doneButton?.isEnabled = enable
    }
    
    func screenViewModelDidSelectUser(title: String, isEmpty: Bool) {
        self.title = title
        collectionView.isHidden = isEmpty
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func screenViewModelLoadingState(for state: EkoLoadingState) {
        switch state {
        case .loadmore:
            tableView.showLoadingIndicator()
        default:
            tableView.tableFooterView = UIView()
        }
    }
}
