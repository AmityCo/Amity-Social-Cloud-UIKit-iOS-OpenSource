//
//  EkoCreateCommunityScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 26/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

enum EkoCreateCommunityRoute {
    case communityProfile
}

enum EkoCreateCommunityTypes: Int {
    case `public`, `private`
}

enum EkoCreateCommunityMemberState {
    case add
    case adding(number: Int)
    case max(number: Int)
}

enum EkoCreateCommunityState {
    case textFieldOnChanged(text: String, lenght: Int)
    case textViewOnChanged(text: String, lenght: Int, hasValue: Bool)
    case selectedCommunityType(type: EkoCreateCommunityTypes)
    case updateAddMember
    case validateField(status: Bool)
    case createSuccess(communityId: String)
    case communityAlreadyExist
    case onDismiss(isChange: Bool)
    case updateSuccess
}

protocol EkoCreateCommunityScreenViewModelDataSource {
    var storeUsers: [EkoSelectMemberModel] { get }
    var addMemberState: EkoCreateCommunityMemberState { get set }
    var selectedCategoryId: String? { get }
    var community: EkoBoxBinding<EkoCommunityModel?> { get set }
    func numberOfMemberSelected() -> Int
    func user(at indexPath: IndexPath) -> EkoSelectMemberModel?
}

protocol EkoCreateCommunityScreenViewModelDelegate: class {
    func screenViewModel(_ viewModel: EkoCreateCommunityScreenViewModel, state: EkoCreateCommunityState)
    func screenViewModel(_ viewModel: EkoCreateCommunityScreenViewModel, failure error: EkoError)
}

protocol EkoCreateCommunityScreenViewModelAction {
    func textFieldEditingChanged(_ textField: EkoTextField)
    func text<T>(_ object: T, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textViewDidChanged(_ textView: EkoTextView)
    func selectCommunityType(_ tag: Int)
    func updateSelectUser(users: [EkoSelectMemberModel])
    func removeUser(at indexPath: IndexPath)
    func updateSelectedCategory(categoryId: String?)
    func create()
    func performDismiss()
    func getInfo(communityId: String)
    func update()
    
    func setImage(for image: UIImage)
}

protocol EkoCreateCommunityScreenViewModelType: EkoCreateCommunityScreenViewModelAction, EkoCreateCommunityScreenViewModelDataSource {
    var action: EkoCreateCommunityScreenViewModelAction { get }
    var dataSource: EkoCreateCommunityScreenViewModelDataSource { get }
    var delegate: EkoCreateCommunityScreenViewModelDelegate? { get set }
}

extension EkoCreateCommunityScreenViewModelType {
    var action: EkoCreateCommunityScreenViewModelAction { return self }
    var dataSource: EkoCreateCommunityScreenViewModelDataSource { return self }
}
