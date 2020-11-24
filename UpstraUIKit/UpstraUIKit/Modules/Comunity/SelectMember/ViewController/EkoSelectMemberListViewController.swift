//
//  EkoSelectMemberListViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final public class EkoSelectMemberListViewController: EkoViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var selectMemberCollectionView: EkoDynamicHeightCollectionView!
    @IBOutlet private var memberListTableView: UITableView!
    @IBOutlet private var noUserFoundLabel: UILabel!
    
    // MARK: - Properties
    private var screenViewModel: EkoSelectMemberListScreenViewModelType
    private var doneButton: UIBarButtonItem?
    // MARK: - Callback handler
    var didSelectUserHandler: (([(String, [EkoSelectMemberModel])], [EkoSelectMemberModel]) -> Void)?
    
    private init() {
        screenViewModel = EkoSelectMemberListScreenViewModel()
        super.init(nibName: EkoSelectMemberListViewController.identifier, bundle: UpstraUIKit.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        screenViewModel.action.resetSearch()
    }
    
    static func make(groupUsers: [(key: String, value: [EkoSelectMemberModel])] = [], selectedUsers: [EkoSelectMemberModel] = []) -> EkoSelectMemberListViewController {
        let vc = EkoSelectMemberListViewController()
        vc.screenViewModel.action.updateAllUsersAndSelectedUsers(groupUsers: groupUsers, selectedUsers: selectedUsers)
        return vc
    }
    
    private func setupView() {
        setupScreenViewModel()
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationBarType = .custom
        view.backgroundColor = .white
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor)
        ])
        navigationItem.titleView = customView
        if screenViewModel.dataSource.selectedUsers.isEmpty {
            title = EkoLocalizedStringSet.selectMemberListTitle
        } else {
            let number = screenViewModel.dataSource.selectedUsers.count
            title = String.localizedStringWithFormat(EkoLocalizedStringSet.selectMemberListSelectedTitle, "\(number)")
        }
        
        
        doneButton = UIBarButtonItem(title: EkoLocalizedStringSet.done, style: .plain, target: self, action: #selector(doneTap))
        doneButton?.tintColor = EkoColorSet.primary
        doneButton?.isEnabled = !screenViewModel.dataSource.selectedUsers.isEmpty
        
        let cancelButton = UIBarButtonItem(title: EkoLocalizedStringSet.cancel, style: .plain, target: self, action: #selector(cancelTap))
        cancelButton.tintColor = EkoColorSet.base
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.tintColor = EkoColorSet.base
        searchBar.returnKeyType = .done
        (searchBar.value(forKey: "searchField") as? UITextField)?.textColor = EkoColorSet.base
        ((searchBar.value(forKey: "searchField") as? UITextField)?.leftView as? UIImageView)?.tintColor = EkoColorSet.base.blend(.shade2)
    }
    
    private func setupCollectionView() {
        selectMemberCollectionView.register(UINib(nibName: EkoSelectMemberListCollectionViewCell.identifier, bundle: UpstraUIKit.bundle), forCellWithReuseIdentifier: EkoSelectMemberListCollectionViewCell.identifier)
        selectMemberCollectionView.delegate = self
        selectMemberCollectionView.dataSource = self
        (selectMemberCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        selectMemberCollectionView.showsHorizontalScrollIndicator = false
        selectMemberCollectionView.isHidden = screenViewModel.dataSource.selectedUsers.isEmpty
        selectMemberCollectionView.backgroundColor = .white
    }
    
    private func setupTableView() {
        noUserFoundLabel.text = EkoLocalizedStringSet.noUserFound
        noUserFoundLabel.textColor = EkoColorSet.base.blend(.shade3)
        noUserFoundLabel.font = EkoFontSet.title
        noUserFoundLabel.isHidden = true
        
        memberListTableView.register(UINib(nibName: EkoSelectMemberListTableViewCell.identifier, bundle: UpstraUIKit.bundle), forCellReuseIdentifier: EkoSelectMemberListTableViewCell.identifier)
        memberListTableView.delegate = self
        memberListTableView.dataSource = self
        memberListTableView.tableFooterView = UIView()
        memberListTableView.backgroundColor = .white
    }

    private func setupScreenViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.getUser()
    }
}

private extension EkoSelectMemberListViewController {
    @objc func doneTap() {
        let allUsers = screenViewModel.dataSource.groupUsers
        let allSelectedUsers = screenViewModel.dataSource.selectedUsers
        
        dismiss(animated: true) { [weak self] in
            self?.didSelectUserHandler?(allUsers, allSelectedUsers)
        }
    }
    
    @objc func cancelTap() {
        dismiss(animated: true)
    }
    
    func deleteHandler(at indexPath: IndexPath) {
        screenViewModel.action.deselect(at: indexPath)
    }
}

extension EkoSelectMemberListViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        screenViewModel.action.search(text: searchText)
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

extension EkoSelectMemberListViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfSelectedMember()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EkoSelectMemberListCollectionViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoSelectMemberListCollectionViewCell {
            guard let user = screenViewModel.dataSource.selectedUser(at: indexPath) else { return }
            cell.indexPath = indexPath
            cell.display(with: user)
            cell.deleteHandler = deleteHandler
        }
    }
}

// MARK: - TableView Delegate
extension EkoSelectMemberListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        screenViewModel.action.selectUser(at: indexPath)
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EkoSelectMemberListHeaderView()
        headerView.text = screenViewModel.dataSource.isSearch ? EkoLocalizedStringSet.searchResults : screenViewModel.dataSource.alphabet(at: section)
        return headerView
    }
}

// MARK: - TableView DataSource
extension EkoSelectMemberListViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return screenViewModel.dataSource.numberInSection()
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfMember(in: section)
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
                screenViewModel.action.loadMore()
            }
        }
    }
}

private extension EkoSelectMemberListViewController {
    func bindingViewModel() {
        screenViewModel.dataSource.loading.bind { [weak self] (state) in
            switch state {
            case .loadmore:
                self?.memberListTableView.showLoadingIndicator()
            case .loaded:
                self?.memberListTableView.tableFooterView = nil
            default:
                break
            }
        }
    }
}

extension EkoSelectMemberListViewController: EkoSelectMemberListScreenViewModelDelegate {
    func screenViewModel(_ viewModel: EkoSelectMemberListScreenViewModel, state: EkoSelectMemberListState) {
        switch state {
        case .updateUser:
            memberListTableView.isScrollEnabled = true
            memberListTableView.bounces = true
            noUserFoundLabel.isHidden = true
            memberListTableView.reloadData()
        case .selectUser(let number):
            updateTitle(with: number)
            selectMemberCollectionView.reloadData()
        case .deselectUser(let number):
            updateTitle(with: number)
            selectMemberCollectionView.reloadData()
            memberListTableView.reloadData()
        case .displaySelectUser(let isDisplay):
            selectMemberCollectionView.isHidden = isDisplay
            doneButton?.isEnabled = !isDisplay
        case .search(let results):
            memberListTableView.isScrollEnabled = results
            memberListTableView.bounces = results
            noUserFoundLabel.isHidden = results
        }
    }
    
    private func updateTitle(with number: Int) {
        if number == 0 {
            title = EkoLocalizedStringSet.selectMemberListTitle
        } else {
            title = String.localizedStringWithFormat(EkoLocalizedStringSet.selectMemberListSelectedTitle, "\(number)")
        }
    }
}
