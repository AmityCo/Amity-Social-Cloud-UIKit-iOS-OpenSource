//
//  AmityCreateCommunityScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityCreateCommunityRoute {
    case communityProfile
}

enum AmityCreateCommunityTypes: Int {
    case `public`, `private`
}

enum AmityCreateCommunityMemberState {
    case add
    case adding(number: Int)
    case max(number: Int)
}

enum AmityCreateCommunityState {
    case textFieldOnChanged(text: String, lenght: Int)
    case textViewOnChanged(text: String, lenght: Int, hasValue: Bool)
    case selectedCommunityType(type: AmityCreateCommunityTypes)
    case updateAddMember
    case validateField(status: Bool)
    case createSuccess(communityId: String)
    case communityAlreadyExist
    case onDismiss(isChange: Bool)
    case updateSuccess
}

protocol AmityCreateCommunityScreenViewModelDataSource {
    var storeUsers: [AmitySelectMemberModel] { get }
    var addMemberState: AmityCreateCommunityMemberState { get set }
    var selectedCategoryId: String? { get }
    var community: AmityBoxBinding<AmityCommunityModel?> { get set }
    func numberOfMemberSelected() -> Int
    func user(at indexPath: IndexPath) -> AmitySelectMemberModel?
}

protocol AmityCreateCommunityScreenViewModelDelegate: AnyObject {
    func screenViewModel(_ viewModel: AmityCreateCommunityScreenViewModel, state: AmityCreateCommunityState)
    func screenViewModel(_ viewModel: AmityCreateCommunityScreenViewModel, failure error: AmityError)
}

protocol AmityCreateCommunityScreenViewModelAction {
    func textFieldEditingChanged(_ textField: AmityTextField)
    func text<T>(_ object: T, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textViewDidChanged(_ textView: AmityTextView)
    func selectCommunityType(_ tag: Int)
    func updateSelectUser(users: [AmitySelectMemberModel])
    func removeUser(at indexPath: IndexPath)
    func updateSelectedCategory(categoryId: String?)
    func create()
    func performDismiss()
    func getInfo(communityId: String)
    func update()
    
    func setImage(for image: UIImage)
}

protocol AmityCreateCommunityScreenViewModelType: AmityCreateCommunityScreenViewModelAction, AmityCreateCommunityScreenViewModelDataSource {
    var action: AmityCreateCommunityScreenViewModelAction { get }
    var dataSource: AmityCreateCommunityScreenViewModelDataSource { get }
    var delegate: AmityCreateCommunityScreenViewModelDelegate? { get set }
}

extension AmityCreateCommunityScreenViewModelType {
    var action: AmityCreateCommunityScreenViewModelAction { return self }
    var dataSource: AmityCreateCommunityScreenViewModelDataSource { return self }
}
