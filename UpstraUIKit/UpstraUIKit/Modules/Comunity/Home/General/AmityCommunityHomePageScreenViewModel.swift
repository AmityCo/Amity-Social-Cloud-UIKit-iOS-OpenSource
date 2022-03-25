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
    var delegate: AmityCommunityHomePageScreenViewModelDelegate?
    var baseOnJoinPage: PageType
    var categoryItems: [AmityCommunityCategoryModel]
    var amityCommunityEventTypeModel: AmityCommunityEventTypeModel?
    
    init(amityCommunityEventTypeModel: AmityCommunityEventTypeModel? = nil) {
        baseOnJoinPage = .newsFeed
        categoryItems = []
        self.amityCommunityEventTypeModel = amityCommunityEventTypeModel
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
    
    func getChatBadge() {
        customAPIRequest.getChatBadgeCount(userId: AmityUIKitManagerInternal.shared.currentUserId, completion: {
            result in
            switch result {
            case .success(let badgeCount):
                DispatchQueue.main.async {
                    self.delegate?.screenViewModelDidGetChatBadge(badgeCount)
                }
            case .failure(let error):
                print("--->[AmitySDK]Error on get noti badge: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.delegate?.screenViewModelDidGetChatBadge(0)
                }
            }
            
        })
    }
}
