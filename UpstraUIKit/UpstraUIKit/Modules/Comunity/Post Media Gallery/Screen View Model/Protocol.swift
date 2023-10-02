//
//  Protocols.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 4/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import Foundation
import AmitySDK

protocol AmityPostGalleryScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdateDataSource(_ viewModel: AmityPostGalleryScreenViewModel)
}

protocol AmityPostGalleryScreenViewModelDataSource {
    func numberOfSections() -> Int
    func numberOfItemsInSection(_ section: Int) -> Int
    func item(at: IndexPath) -> AmityPostGalleryScreenViewModel.Item
}

protocol AmityPostGalleryScreenViewModelAction {
    func setup(postRepository: AmityPostRepository)
    func switchPostsQuery(to options: AmityPostQueryOptions)
    func loadMore()
}

protocol AmityPostGalleryScreenViewModelType {
    var delegate: AmityPostGalleryScreenViewModelDelegate? { get set }
    var action: AmityPostGalleryScreenViewModelAction { get }
    var dataSource: AmityPostGalleryScreenViewModelDataSource { get }
}

