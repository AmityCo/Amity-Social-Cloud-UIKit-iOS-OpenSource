//
//  AmitySelectCategoryListScreenViewModelType.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 2/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

protocol AmityCategoryPickerViewModelDataSource {
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> AmityCommunityCategory?
    func loadNext()
}

protocol AmityCategoryPickerScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdateData(_ viewModel: AmityCategoryPickerScreenViewModel)
}

protocol AmityCategoryPickerScreenViewModelAction {}

protocol AmityCategoryPickerScreenViewModelType: AmityCategoryPickerScreenViewModelAction, AmityCategoryPickerViewModelDataSource {
    var action: AmityCategoryPickerScreenViewModelAction { get }
    var dataSource: AmityCategoryPickerViewModelDataSource { get }
    var delegate: AmityCategoryPickerScreenViewModelDelegate? { get set }
}

extension AmityCategoryPickerScreenViewModelType {
    var action: AmityCategoryPickerScreenViewModelAction { return self }
    var dataSource: AmityCategoryPickerViewModelDataSource { return self }
}
