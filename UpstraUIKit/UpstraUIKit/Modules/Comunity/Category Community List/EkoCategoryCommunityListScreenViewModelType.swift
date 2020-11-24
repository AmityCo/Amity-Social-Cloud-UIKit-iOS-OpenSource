//
//  EkoCategoryCommunityListScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import Foundation

protocol EkoCategoryCommunityListScreenViewModelDataSource {
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> EkoCommunityModel?
    func loadNext()
}

protocol EkoCategoryCommunityListScreenViewModelDelegate: class {
    func screenViewModelDidUpdateData(_ viewModel: EkoCategoryCommunityListScreenViewModelType)
}

protocol EkoCategoryCommunityListScreenViewModelAction {}

protocol EkoCategoryCommunityListScreenViewModelType: EkoCategoryCommunityListScreenViewModelAction, EkoCategoryCommunityListScreenViewModelDataSource {
    var action: EkoCategoryCommunityListScreenViewModelAction { get }
    var dataSource: EkoCategoryCommunityListScreenViewModelDataSource { get }
    var delegate: EkoCategoryCommunityListScreenViewModelDelegate? { get set }
}

extension EkoCategoryCommunityListScreenViewModelType {
    var action: EkoCategoryCommunityListScreenViewModelAction { return self }
    var dataSource: EkoCategoryCommunityListScreenViewModelDataSource { return self }
}
