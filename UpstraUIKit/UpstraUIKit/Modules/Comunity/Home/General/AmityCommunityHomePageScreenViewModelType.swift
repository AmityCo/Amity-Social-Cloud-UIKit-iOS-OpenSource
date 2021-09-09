//
//  EkoCommunityHomePageScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Khwan Siricharoenporn on 11/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import Foundation
import UIKit

protocol AmityCommunityHomePageScreenViewModelDataSource {
    var baseOnJoinPage: PageType { get set }
    var fromDeeplinks: Bool { get set }
    var deeplinksType: DeeplinksType? { get set }
    var categoryItems: [AmityCommunityCategoryModel] { get set }
    func getCategoryItemBy(categoryId: String) -> AmityCommunityCategoryModel?
    func getCategoryItems() -> [AmityCommunityCategoryModel]
}

protocol AmityCommunityHomePageScreenViewModelDelegate: class {
    func didFetchCommunitiesSuccess(page: PageType)
    func didFetchCommunitiesFailure(error: Error)
    func didFetchProfileImageSuccess(image: UIImage)
    func didFetchProfileImageFailure()
    func didFetchCategoriesSuccess()
    func didFetchCategoriesFailure(error: Error)
}

protocol AmityCommunityHomePageScreenViewModelAction {
    func fetchCommunities()
    func fetchProfileImage(with userId: String)
    func fetchCategories()
}

protocol AmityCommunityHomePageScreenViewModelType: AmityCommunityHomePageScreenViewModelAction, AmityCommunityHomePageScreenViewModelDataSource {
    var action: AmityCommunityHomePageScreenViewModelAction { get }
    var dataSource: AmityCommunityHomePageScreenViewModelDataSource { get }
    var delegate: AmityCommunityHomePageScreenViewModelDelegate? { get set }
}

extension AmityCommunityHomePageScreenViewModelType {
    var action: AmityCommunityHomePageScreenViewModelAction { return self }
    var dataSource: AmityCommunityHomePageScreenViewModelDataSource { return self }
}
