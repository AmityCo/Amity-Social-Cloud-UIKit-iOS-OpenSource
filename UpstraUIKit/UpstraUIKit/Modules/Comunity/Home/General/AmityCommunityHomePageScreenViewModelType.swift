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
    var amityCommunityEventTypeModel: AmityCommunityEventTypeModel? { get set }
    var categoryItems: [AmityCommunityCategoryModel] { get set }
    var delegate: AmityCommunityHomePageScreenViewModelDelegate? { get set }
    func getCategoryItemBy(categoryId: String) -> AmityCommunityCategoryModel?
    func getCategoryItems() -> [AmityCommunityCategoryModel]
    func getChatBadge()
}

protocol AmityCommunityHomePageScreenViewModelType: AmityCommunityHomePageScreenViewModelDataSource {
    var dataSource: AmityCommunityHomePageScreenViewModelDataSource { get }
}

protocol AmityCommunityHomePageScreenViewModelDelegate {
    func screenViewModelDidGetChatBadge(_ badge: Int)
}

extension AmityCommunityHomePageScreenViewModelType {
    var dataSource: AmityCommunityHomePageScreenViewModelDataSource { return self }
}
