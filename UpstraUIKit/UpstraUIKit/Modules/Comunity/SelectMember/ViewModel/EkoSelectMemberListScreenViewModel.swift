//
//  EkoSelectMemberListScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoSelectMemberListScreenViewModel: EkoSelectMemberListScreenViewModelType {
    
    weak var delegate: EkoSelectMemberListScreenViewModelDelegate?
    private var isFirst: Bool = false
    var isSearch: Bool = false
    
    private var userCollectionToken: EkoNotificationToken?
    private var userCollection: EkoCollection<EkoUser>?
    private let repository: EkoUserRepository = EkoUserRepository(client: UpstraUIKitManager.shared.client)
    
    var users: [EkoSelectMemberModel] = []
    var searchUsers: [EkoSelectMemberModel] = []
    var groupUsers: [(key: String, value: [EkoSelectMemberModel])] = []
    var selectedUsers: [EkoSelectMemberModel] = [] {
        didSet {
            delegate?.screenViewModel(self, state: .displaySelectUser(isDisplay: selectedUsers.isEmpty))
        }
    }
    
    var loading: EkoBoxBinding<EkoLoadingState> = EkoBoxBinding(.initial)
}

// MARK: - DataSourceObserver
extension EkoSelectMemberListScreenViewModel: EkoDataSourceListener {
    func dataSourceUpdated() {
        delegate?.screenViewModel(self, state: .updateUser)
    }
}
// MARK: - Data Source
extension EkoSelectMemberListScreenViewModel {
    
    func updateAllUsersAndSelectedUsers(groupUsers: [(key: String, value: [EkoSelectMemberModel])], selectedUsers: [EkoSelectMemberModel]) {
        guard !groupUsers.isEmpty else { return }
        isFirst = true
        self.groupUsers = groupUsers
        self.selectedUsers = selectedUsers
    }
    
    func numberInSection() -> Int {
        return isSearch ? 1 : groupUsers.count
    }
    
    func numberOfMember(in section: Int) -> Int {
        return isSearch ? searchUsers.count : groupUsers[section].value.count
    }
    
    func user(at indexPath: IndexPath) -> EkoSelectMemberModel? {
        if isSearch {
            guard !searchUsers.isEmpty else { return nil }
            return searchUsers[indexPath.row]
        } else {
            guard !groupUsers.isEmpty else { return nil }
            return groupUsers[indexPath.section].value[indexPath.row]
        }
    }
    
    func alphabet(at section: Int) -> String? {
        guard !groupUsers.isEmpty else { return nil }
        return groupUsers[section].key
    }
    
    func numberOfSelectedMember() -> Int {
        return selectedUsers.count
    }
    
    func selectedUser(at indexPath: IndexPath) -> EkoSelectMemberModel? {
        guard !selectedUsers.isEmpty else { return nil }
        return selectedUsers[indexPath.item]
    }

}

// MARK: - Action
extension EkoSelectMemberListScreenViewModel {
    func getUser() {
        if isFirst {
            isFirst = false
        } else {
            userCollection = repository.getAllUsersSorted(by: .displayName)
            userCollectionToken = userCollection?.observe({ [weak self] collection, change, error in
                self?.groupingUser(with: collection)
            })
        }
        
    }
    
    private func groupingUser(with collection: EkoCollection<EkoUser>) {
        
        for index in 0..<collection.count() {
            guard let object = collection.object(at: index) else { return }
            let model = EkoSelectMemberModel(userId: object.userId, displayName: object.displayName, avatarId: object.avatarFileId ?? "")
            let index = users.firstIndex(where: { $0.userId == object.userId })
            if index == nil {
                users.append(model)
            }
        }
        
        let predicate: (EkoSelectMemberModel) -> (String) = { user in
            guard let displayName = user.displayName else { return "#" }
            let c = String(displayName.prefix(1)).uppercased()
            let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            
            if alphabet.contains(c) {
                return c
            } else {
                return "#"
            }
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.groupUsers = Dictionary(grouping: self.users, by: predicate).sorted { $0.0 < $1.0 }
            DispatchQueue.main.async {
                self.delegate?.screenViewModel(self, state: .updateUser)
            }
        }
    }
    
    func selectUser(at indexPath: IndexPath) {
        if isSearch {
            let user = searchUsers[indexPath.row]
            selectUserLogic(with: user)
        } else {
            let user = groupUsers[indexPath.section].value[indexPath.row]
            selectUserLogic(with: user)
        }
        delegate?.screenViewModel(self, state: .selectUser(number: selectedUsers.count))
        
    }
    
    private func selectUserLogic(with user: EkoSelectMemberModel) {
        user.isSelect.toggle()
        if let _user = selectedUsers.first(where: { $0 == user }), let index = selectedUsers.firstIndex(of: _user) {
            selectedUsers.remove(at: index)
        } else {
            selectedUsers.append(user)
        }
    }
    
    func deselect(at indexPath: IndexPath) {
        let user = selectedUsers[indexPath.item]
        groupUsers.forEach { key, value in
            value.first(where: { $0 == user})?.isSelect.toggle()
        }
        selectedUsers.remove(at: indexPath.item)
        delegate?.screenViewModel(self, state: .deselectUser(number: selectedUsers.count))
    }
    
    func search(text: String) {
        
        searchUsers = []
        isSearch = text != ""
        if text == "" {
            isSearch = false
            delegate?.screenViewModel(self, state: .search(results: false))
            delegate?.screenViewModel(self, state: .updateUser)
            return
        }
        groupUsers.forEach { [weak self] (key, list) in
            guard let strongSelf = self else { return }
                
            for user in list {
                if let displayName = user.displayName,
                    displayName.lowercased().range(of: text, options: .caseInsensitive) != nil {
                    strongSelf.searchUsers.append(user)
                }
            }
        }
        
        delegate?.screenViewModel(self, state: .updateUser)
        delegate?.screenViewModel(self, state: .search(results: self.searchUsers.count > 0))
    }
    
    func loadMore() {
        if !isSearch {
            guard let collection = userCollection else { return }
            switch collection.loadingStatus {
            case .loaded:
                if collection.hasNext {
                    collection.nextPage()
                    self.loading.value = .loadmore
                } else {
                    self.loading.value = .loaded
                }
            default:
                break
            }
        }
    }
    
    func resetSearch() {
        isSearch = false
    }
}
