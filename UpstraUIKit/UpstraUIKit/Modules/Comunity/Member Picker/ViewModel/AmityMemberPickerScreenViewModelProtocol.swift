//
//  AmityMemberPickerViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityMemberPickerScreenViewModelDelegate: AnyObject {
    func screenViewModelDidFetchUser()
    func screenViewModelDidSearchUser()
    func screenViewModelDidSelectUser(title: String, isEmpty: Bool)
    func screenViewModelLoadingState(for state: AmityLoadingState)
    func screenViewModelCanDone(enable: Bool)
}

protocol AmityMemberPickerScreenViewModelDataSource {
    func numberOfAlphabet() -> Int
    func numberOfUsers(in section: Int) -> Int
    func numberOfSelectedUsers() -> Int
    func alphabetOfHeader(in section: Int) -> String
    func user(at indexPath: IndexPath) -> AmitySelectMemberModel?
    func selectUser(at indexPath: IndexPath) -> AmitySelectMemberModel
    func isSearching() -> Bool
    func getStoreUsers() -> [AmitySelectMemberModel]
}

protocol AmityMemberPickerScreenViewModelAction {
    func getUsers()
    func searchUser(with text: String)
    func selectUser(at indexPath: IndexPath)
    func deselectUser(at indexPath: IndexPath)
    func loadmore()
    func setCurrentUsers(users: [AmitySelectMemberModel])
}

protocol AmityMemberPickerScreenViewModelType: AmityMemberPickerScreenViewModelAction, AmityMemberPickerScreenViewModelDataSource {
    var action: AmityMemberPickerScreenViewModelAction { get }
    var dataSource: AmityMemberPickerScreenViewModelDataSource { get }
    var delegate: AmityMemberPickerScreenViewModelDelegate? { get set }
}

extension AmityMemberPickerScreenViewModelType {
    var action: AmityMemberPickerScreenViewModelAction { return self }
    var dataSource: AmityMemberPickerScreenViewModelDataSource { return self }
}
