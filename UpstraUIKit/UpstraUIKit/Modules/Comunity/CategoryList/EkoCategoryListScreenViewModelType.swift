//
//  EkoCategoryListScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 24/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

protocol EkoCategoryListScreenViewModelDataSource {
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> EkoCommunityCategory?
    func loadNext()
}

protocol EkoCategoryListScreenViewModelDelegate: class {
    func screenViewModelDidUpdateData(_ viewModel: EkoCategoryListScreenViewModel)
}

protocol EkoCategoryListScreenViewModelAction {}

protocol EkoCategoryListScreenViewModelType: EkoCategoryListScreenViewModelAction, EkoCategoryListScreenViewModelDataSource {
    var action: EkoCategoryListScreenViewModelAction { get }
    var dataSource: EkoCategoryListScreenViewModelDataSource { get }
    var delegate: EkoCategoryListScreenViewModelDelegate? { get set }
}

extension EkoCategoryListScreenViewModelType {
    var action: EkoCategoryListScreenViewModelAction { return self }
    var dataSource: EkoCategoryListScreenViewModelDataSource { return self }
}
