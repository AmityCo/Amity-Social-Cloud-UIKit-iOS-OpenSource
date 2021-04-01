//
//  EkoSelectMemberListScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoSelectMemberListScreenViewModel: EkoSelectMemberListScreenViewModelType {
    weak var delegate: EkoSelectMemberListScreenViewModelDelegate?
    
    // MARK: - Repository
    private var userRepository: EkoUserRepository?
    
    // MARK: - Controller
    private var fetchUserController: EkoFetchUserController?
    private var searchUserController: EkoSearchUserController?
    private var selectUserContrller: EkoSelectUserController?
    
    private var users: EkoFetchUserController.GroupUser = []
    private var searchUsers: [EkoSelectMemberModel] = []
    private var storeUsers: [EkoSelectMemberModel] = [] {
        didSet {
            delegate?.screenViewModelCanDone(enable: !storeUsers.isEmpty)
        }
    }
    
    private var isSearch: Bool = false
    
    init() {
        userRepository = EkoUserRepository(client: UpstraUIKitManagerInternal.shared.client)
        fetchUserController = EkoFetchUserController(repository: userRepository)
        searchUserController = EkoSearchUserController(repository: userRepository)
        selectUserContrller = EkoSelectUserController()
    }
}

// MARK: - DataSource
extension EkoSelectMemberListScreenViewModel {
    func numberOfAlphabet() -> Int {
        return isSearch ? 1 : users.count
    }
    
    func numberOfUsers(in section: Int) -> Int {
        return isSearch ? searchUsers.count : users[section].value.count
    }
    
    func numberOfSelectedUsers() -> Int {
        return storeUsers.count
    }
    
    func alphabetOfHeader(in section: Int) -> String {
        return users[section].key
    }
    
    func user(at indexPath: IndexPath) -> EkoSelectMemberModel? {
        if isSearch {
            guard !searchUsers.isEmpty else { return nil }
            return searchUsers[indexPath.row]
        } else {
            guard !users.isEmpty else { return nil }
            return users[indexPath.section].value[indexPath.row]
        }
    }
    
    func selectUser(at indexPath: IndexPath) -> EkoSelectMemberModel {
        return storeUsers[indexPath.item]
    }
    
    func isSearching() -> Bool {
        return isSearch
    }
    
    func getStoreUsers() -> [EkoSelectMemberModel] {
        return storeUsers
    }
}

// MARK: - Action
extension EkoSelectMemberListScreenViewModel {
    
    func getUserFromCreatePage(users: [EkoSelectMemberModel]) {
        storeUsers = users
    }
    
    func getUsers() {
        fetchUserController?.storeUsers = storeUsers
        fetchUserController?.getUser { (result) in
            switch result {
            case .success(let users):
                self.users = users
                self.delegate?.screenViewModelDidFetchUser()
            case .failure(let error):
                break
            }
        }
    }
    
    func searchUser(with text: String) {
        isSearch = true
        searchUserController?.search(with: text, storeUsers: storeUsers, { [weak self] (result) in
            switch result {
            case .success(let users):
                self?.searchUsers = users
                self?.delegate?.screenViewModelDidSearchUser()
            case .failure(let error):
                switch error {
                case .textEmpty:
                    self?.isSearch = false
                    self?.delegate?.screenViewModelDidSearchUser()
                case .unknown:
                    break
                }
            }
        })
    }
    
    func selectUser(at indexPath: IndexPath) {
        selectUserContrller?.selectUser(searchUsers: searchUsers, users: &users, storeUsers: &storeUsers, at: indexPath, isSearch: isSearch)
        if storeUsers.count == 0 {
            delegate?.screenViewModelDidSelectUser(title: EkoLocalizedStringSet.selectMemberListTitle.localizedString, isEmpty: true)
        } else {
            delegate?.screenViewModelDidSelectUser(title: String.localizedStringWithFormat(EkoLocalizedStringSet.selectMemberListSelectedTitle.localizedString, "\(storeUsers.count)"), isEmpty: false)
        }
    }
    
    func deselectUser(at indexPath: IndexPath) {
        selectUserContrller?.deselect(users: &users, storeUsers: &storeUsers, at: indexPath)
        if storeUsers.count == 0 {
            delegate?.screenViewModelDidSelectUser(title: EkoLocalizedStringSet.selectMemberListTitle.localizedString, isEmpty: true)
        } else {
            delegate?.screenViewModelDidSelectUser(title: String.localizedStringWithFormat(EkoLocalizedStringSet.selectMemberListSelectedTitle.localizedString, "\(storeUsers.count)"), isEmpty: false)
        }
    }
    
    func loadmore() {
        var success: Bool = false
        if isSearch {
            guard let controller = searchUserController else { return }
            success = controller.loadmore(isSearch: isSearch)
        } else {
            guard let controller = fetchUserController else { return }
            fetchUserController?.storeUsers = storeUsers
            success = controller.loadmore(isSearch: isSearch)
        }
        
        if success {
            delegate?.screenViewModelLoadingState(for: .loading)
        } else {
            delegate?.screenViewModelLoadingState(for: .loaded)
        }
    }
}
