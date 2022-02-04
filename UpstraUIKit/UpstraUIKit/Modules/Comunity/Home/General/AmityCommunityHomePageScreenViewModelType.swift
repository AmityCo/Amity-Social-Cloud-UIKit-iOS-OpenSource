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
    var amityDeepLink: AmityDeepLink? { get set }
    var categoryItems: [AmityCommunityCategoryModel] { get set }
    func getCategoryItemBy(categoryId: String) -> AmityCommunityCategoryModel?
    func getCategoryItems() -> [AmityCommunityCategoryModel]
}

protocol AmityCommunityHomePageScreenViewModelType: AmityCommunityHomePageScreenViewModelDataSource {
    var dataSource: AmityCommunityHomePageScreenViewModelDataSource { get }
}

extension AmityCommunityHomePageScreenViewModelType {
    var dataSource: AmityCommunityHomePageScreenViewModelDataSource { return self }
}
