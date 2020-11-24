//
//  EkoSelectCategoryListScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 2/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

protocol EkoSelectCategoryListScreenViewModelDataSource {
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> EkoCommunityCategory?
    func loadNext()
}

protocol EkoSelectCategoryListScreenViewModelDelegate: class {
    func screenViewModelDidUpdateData(_ viewModel: EkoSelectCategoryListScreenViewModel)
}

protocol EkoSelectCategoryListScreenViewModelAction {}

protocol EkoSelectCategoryListScreenViewModelType: EkoSelectCategoryListScreenViewModelAction, EkoSelectCategoryListScreenViewModelDataSource {
    var action: EkoSelectCategoryListScreenViewModelAction { get }
    var dataSource: EkoSelectCategoryListScreenViewModelDataSource { get }
    var delegate: EkoSelectCategoryListScreenViewModelDelegate? { get set }
}

extension EkoSelectCategoryListScreenViewModelType {
    var action: EkoSelectCategoryListScreenViewModelAction { return self }
    var dataSource: EkoSelectCategoryListScreenViewModelDataSource { return self }
}
