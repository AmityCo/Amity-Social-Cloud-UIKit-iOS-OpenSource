//
//  AmityPostTargetPickerScreenViewModelType.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 27/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityPostTargetPickerScreenViewModelDataSource {
    func numberOfItems() -> Int
    func community(at indexPath: IndexPath) -> AmityCommunity?
    func loadNext()
}

protocol AmityPostTargetPickerScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdateItems(_ viewModel: AmityPostTargetPickerScreenViewModel)
}

protocol AmityPostTargetPickerScreenViewModelAction {
}

protocol AmityPostTargetPickerScreenViewModelType: AmityPostTargetPickerScreenViewModelAction, AmityPostTargetPickerScreenViewModelDataSource {
    var action: AmityPostTargetPickerScreenViewModelAction { get }
    var dataSource: AmityPostTargetPickerScreenViewModelDataSource { get }
    var delegate: AmityPostTargetPickerScreenViewModelDelegate? { get set }
}

extension AmityPostTargetPickerScreenViewModelType {
    var action: AmityPostTargetPickerScreenViewModelAction { return self }
    var dataSource: AmityPostTargetPickerScreenViewModelDataSource { return self }
}
