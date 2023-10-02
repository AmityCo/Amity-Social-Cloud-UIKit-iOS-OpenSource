//
//  AmitySelectMemberListScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityMemberPickerScreenViewModel: AmityMemberPickerScreenViewModelType {
    weak var delegate: AmityMemberPickerScreenViewModelDelegate?
    
    // MARK: - Repository
    private var userRepository: AmityUserRepository?
    
    // MARK: - Controller
    private var fetchUserController: AmityFetchUserController?
    private var searchUserController: AmitySearchUserController?
    private var selectUserContrller: AmitySelectUserController?
    
    private var users: AmityFetchUserController.GroupUser = []
    private var searchUsers: [AmitySelectMemberModel] = []
    private var storeUsers: [AmitySelectMemberModel] = [] {
        didSet {
            delegate?.screenViewModelCanDone(enable: !storeUsers.isEmpty)
        }
    }
    
    private var isSearch: Bool = false
    
    init() {
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        fetchUserController = AmityFetchUserController(repository: userRepository)
        searchUserController = AmitySearchUserController(repository: userRepository)
        selectUserContrller = AmitySelectUserController()
    }
}

// MARK: - DataSource
extension AmityMemberPickerScreenViewModel {
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
    
    func user(at indexPath: IndexPath) -> AmitySelectMemberModel? {
        if isSearch {
            guard !searchUsers.isEmpty else { return nil }
            return searchUsers[indexPath.row]
        } else {
            guard !users.isEmpty else { return nil }
            return users[indexPath.section].value[indexPath.row]
        }
    }
    
    func selectUser(at indexPath: IndexPath) -> AmitySelectMemberModel {
        return storeUsers[indexPath.item]
    }
    
    func isSearching() -> Bool {
        return isSearch
    }
    
    func getStoreUsers() -> [AmitySelectMemberModel] {
        return storeUsers
    }
}

// MARK: - Action
extension AmityMemberPickerScreenViewModel {
    
    func setCurrentUsers(users: [AmitySelectMemberModel]) {
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
            delegate?.screenViewModelDidSelectUser(title: AmityLocalizedStringSet.selectMemberListTitle.localizedString, isEmpty: true)
        } else {
            delegate?.screenViewModelDidSelectUser(title: String.localizedStringWithFormat(AmityLocalizedStringSet.selectMemberListSelectedTitle.localizedString, "\(storeUsers.count)"), isEmpty: false)
        }
    }
    
    func deselectUser(at indexPath: IndexPath) {
        selectUserContrller?.deselect(users: &users, storeUsers: &storeUsers, at: indexPath)
        if storeUsers.count == 0 {
            delegate?.screenViewModelDidSelectUser(title: AmityLocalizedStringSet.selectMemberListTitle.localizedString, isEmpty: true)
        } else {
            delegate?.screenViewModelDidSelectUser(title: String.localizedStringWithFormat(AmityLocalizedStringSet.selectMemberListSelectedTitle.localizedString, "\(storeUsers.count)"), isEmpty: false)
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
