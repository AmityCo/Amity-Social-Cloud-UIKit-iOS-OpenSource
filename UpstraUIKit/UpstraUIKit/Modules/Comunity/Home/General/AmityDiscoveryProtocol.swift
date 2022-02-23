//
//  AmityDiscoveryProtocol.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 18/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import AmitySDK

protocol AmityDiscoveryScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdateDataSource(_ viewModel: AmityDiscoveryScreenViewModel)
}

protocol AmityDiscoveryScreenViewModelDataSource {
    func numberOfSections() -> Int
    func numberOfItemsInSection(_ section: Int) -> Int
    func item(at: IndexPath) -> AmityDiscoveryScreenViewModel.Item
    func discoveryItem(at: IndexPath) -> DiscoveryDataModel
}

protocol AmityDiscoveryScreenViewModelAction {
    func setup(postRepository: AmityPostRepository)
    func switchPostsQuery(to options: AmityPostQueryOptions)
    func loadDiscoveryItem()
    func loadMore()
}

protocol AmityDiscoveryScreenViewModelType {
    var delegate: AmityDiscoveryScreenViewModelDelegate? { get set }
    var action: AmityDiscoveryScreenViewModelAction { get }
    var dataSource: AmityDiscoveryScreenViewModelDataSource { get }
}

