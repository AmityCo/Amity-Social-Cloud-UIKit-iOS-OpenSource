//
//  EkoCommunityHomePageScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Khwan Siricharoenporn on 11/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import Foundation
import AmitySDK

class AmityCommunityHomePageScreenViewModel: AmityCommunityHomePageScreenViewModelType {
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    var baseOnJoinPage: PageType
    var fromDeeplinks: Bool
    var deeplinksType: DeeplinksType?
    var categoryItems: [AmityCommunityCategoryModel]
    
    init(deeplinksType: DeeplinksType? = nil, fromDeeplinks: Bool = false) {
        baseOnJoinPage = .newsFeed
        categoryItems = []
        self.fromDeeplinks = fromDeeplinks
        self.deeplinksType = deeplinksType
    }
}

//MARK: DataSource
extension AmityCommunityHomePageScreenViewModel {
    func getCategoryItemBy(categoryId: String) -> AmityCommunityCategoryModel? {
        var targetItem: AmityCommunityCategoryModel? = nil
        categoryItems.forEach { item in
            if item.categoryId == categoryId {
                targetItem = item
            }
        }
        return targetItem
    }
    
    func getCategoryItems() -> [AmityCommunityCategoryModel] {
        return categoryItems
    }
}
