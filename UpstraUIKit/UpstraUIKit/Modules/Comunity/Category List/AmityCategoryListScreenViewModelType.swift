//
//  AmityCategoryListScreenViewModelType.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

protocol AmityCategoryListScreenViewModelDataSource {
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> AmityCommunityCategory?
    func loadNext()
}

protocol AmityCategoryListScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdateData(_ viewModel: AmityCategoryListScreenViewModel)
}

protocol AmityCategoryListScreenViewModelAction {}

protocol AmityCategoryListScreenViewModelType: AmityCategoryListScreenViewModelAction, AmityCategoryListScreenViewModelDataSource {
    var action: AmityCategoryListScreenViewModelAction { get }
    var dataSource: AmityCategoryListScreenViewModelDataSource { get }
    var delegate: AmityCategoryListScreenViewModelDelegate? { get set }
}

extension AmityCategoryListScreenViewModelType {
    var action: AmityCategoryListScreenViewModelAction { return self }
    var dataSource: AmityCategoryListScreenViewModelDataSource { return self }
}
