//
//  AmityMemberSearchScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Hamlet on 11.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

protocol AmityMemberSearchScreenViewModelDelegate: AnyObject {
    func screenViewModelDidSearch(_ viewModel: AmityMemberSearchScreenViewModelType)
    func screenViewModelDidClearText(_ viewModel: AmityMemberSearchScreenViewModelType)
    func screenViewModelDidSearchNotFound(_ viewModel: AmityMemberSearchScreenViewModelType)
    func screenViewModel(_ viewModel: AmityMemberSearchScreenViewModelType, loadingState: AmityLoadingState)
}

protocol AmityMemberSearchScreenViewModelDataSource {
    func numberOfmembers() -> Int
    func item(at indexPath: IndexPath) -> AmityUserModel?
}

protocol AmityMemberSearchScreenViewModelAction {
    func search(withText text: String?)
    func loadMore()
}

protocol AmityMemberSearchScreenViewModelType: AmityMemberSearchScreenViewModelAction, AmityMemberSearchScreenViewModelDataSource {
    var delegate: AmityMemberSearchScreenViewModelDelegate? { get set }
    var action: AmityMemberSearchScreenViewModelAction { get }
    var dataSource: AmityMemberSearchScreenViewModelDataSource { get }
}

extension AmityMemberSearchScreenViewModelType {
    var action: AmityMemberSearchScreenViewModelAction { return self }
    var dataSource: AmityMemberSearchScreenViewModelDataSource { return self }
}
