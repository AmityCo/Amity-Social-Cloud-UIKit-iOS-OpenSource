//
//  EkoSelectMemberListcreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoSelectMemberListScreenViewModelDelegate: class {
    func screenViewModelDidFetchUser()
    func screenViewModelDidSearchUser()
    func screenViewModelDidSelectUser(title: String, isEmpty: Bool)
    func screenViewModelLoadingState(for state: EkoLoadingState)
    func screenViewModelCanDone(enable: Bool)
}

protocol EkoSelectMemberListScreenViewModelDataSource {
    func numberOfAlphabet() -> Int
    func numberOfUsers(in section: Int) -> Int
    func numberOfSelectedUsers() -> Int
    func alphabetOfHeader(in section: Int) -> String
    func user(at indexPath: IndexPath) -> EkoSelectMemberModel?
    func selectUser(at indexPath: IndexPath) -> EkoSelectMemberModel
    func isSearching() -> Bool
    func getStoreUsers() -> [EkoSelectMemberModel]
}

protocol EkoSelectMemberListScreenViewModelAction {
    func getUsers()
    func searchUser(with text: String)
    func selectUser(at indexPath: IndexPath)
    func deselectUser(at indexPath: IndexPath)
    func loadmore()
    func getUserFromCreatePage(users: [EkoSelectMemberModel])
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
