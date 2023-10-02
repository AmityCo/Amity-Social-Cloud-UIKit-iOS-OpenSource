//
//  AmityCategoryCommunityListScreenViewModelType.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import Foundation

protocol AmityCategoryCommunityListScreenViewModelDataSource {
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> AmityCommunityModel?
    func loadNext()
}

protocol AmityCategoryCommunityListScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdateData(_ viewModel: AmityCategoryCommunityListScreenViewModelType)
}

protocol AmityCategoryCommunityListScreenViewModelAction {}

protocol AmityCategoryCommunityListScreenViewModelType: AmityCategoryCommunityListScreenViewModelAction, AmityCategoryCommunityListScreenViewModelDataSource {
    var action: AmityCategoryCommunityListScreenViewModelAction { get }
    var dataSource: AmityCategoryCommunityListScreenViewModelDataSource { get }
    var delegate: AmityCategoryCommunityListScreenViewModelDelegate? { get set }
}

extension AmityCategoryCommunityListScreenViewModelType {
    var action: AmityCategoryCommunityListScreenViewModelAction { return self }
    var dataSource: AmityCategoryCommunityListScreenViewModelDataSource { return self }
}
