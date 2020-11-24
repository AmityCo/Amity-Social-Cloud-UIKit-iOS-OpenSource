//
//  EkoSelectMemberListScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

enum EkoSelectMemberListState {
    case updateUser
    case selectUser(number: Int)
    case deselectUser(number: Int)
    case displaySelectUser(isDisplay: Bool)
    case search(results: Bool)
}

protocol EkoSelectMemberListScreenViewModelDataSource {
    var groupUsers: [(key: String, value: [EkoSelectMemberModel])] { get set }
    var selectedUsers: [EkoSelectMemberModel] { get set }
    var isSearch: Bool { get set }
    func numberInSection() -> Int
    func numberOfMember(in section: Int) -> Int
    func numberOfSelectedMember() -> Int
    func user(at indexPath: IndexPath) -> EkoSelectMemberModel?
    func alphabet(at section: Int) -> String?
    func selectedUser(at indexPath: IndexPath) -> EkoSelectMemberModel?
    var loading: EkoBoxBinding<EkoLoadingState> { get set }
}

protocol EkoSelectMemberListScreenViewModelDelegate: class {
    func screenViewModel(_ viewModel: EkoSelectMemberListScreenViewModel, state: EkoSelectMemberListState)
}

protocol EkoSelectMemberListScreenViewModelAction {
    func updateAllUsersAndSelectedUsers(groupUsers: [(key: String, value: [EkoSelectMemberModel])], selectedUsers: [EkoSelectMemberModel])
    func getUser()
    func selectUser(at indexPath: IndexPath)
    func deselect(at indexPath: IndexPath)
    func search(text: String)
    func loadMore()
    func resetSearch()
}

protocol EkoSelectMemberListScreenViewModelType: EkoSelectMemberListScreenViewModelAction, EkoSelectMemberListScreenViewModelDataSource {
    var action: EkoSelectMemberListScreenViewModelAction { get }
    var dataSource: EkoSelectMemberListScreenViewModelDataSource { get }
    var delegate: EkoSelectMemberListScreenViewModelDelegate? { get set }
}

extension EkoSelectMemberListScreenViewModelType {
    var action: EkoSelectMemberListScreenViewModelAction { return self }
    var dataSource: EkoSelectMemberListScreenViewModelDataSource { return self }
}
