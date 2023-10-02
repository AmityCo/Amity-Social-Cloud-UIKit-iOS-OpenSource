//
//  AmityMyCommunityPreviewScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 27/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityMyCommunityPreviewScreenViewModel: AmityMyCommunityPreviewScreenViewModelType {
    private let maximumItems = 8
    private let debouncer = Debouncer(delay: 0.3)
    
    weak var delegate: AmityMyCommunityPreviewScreenViewModelDelegate?
    
    // MARK: - Manager
    private let communityListRepositoryManager: AmityCommunityListRepositoryManagerProtocol
    
    // MARK: - Properties
    
    private var communityList: [AmityCommunityModel] = []
    
    init(communityListRepositoryManager: AmityCommunityListRepositoryManagerProtocol) {
        self.communityListRepositoryManager = communityListRepositoryManager
    }
    
}

// MARK: - DataSource
extension AmityMyCommunityPreviewScreenViewModel {
    func numberOfCommunity() -> Int {
        let count = communityList.count
        if count <= maximumItems {
            return count
        } else {
            return maximumItems + 1
        }
    }
    
    func item(at indexPath: IndexPath) -> AmityCommunityModel {
        return communityList[indexPath.row]
    }
}

// MARK: - Action
extension AmityMyCommunityPreviewScreenViewModel {
    func retrieveMyCommunityList() {
        communityListRepositoryManager.search(withText: "", filter: .userIsMember) { [weak self] (communityList) in
            self?.debouncer.run {
                self?.prepareData(communityList: communityList)
            }
        }
    }
    
    func shouldShowSeeAll(indexPath: IndexPath) -> Bool {
        if communityList.count > maximumItems, indexPath.row == (numberOfCommunity() - 1) {
            return true
        }
        return false
    }
}

// MARK: - Helpers
extension AmityMyCommunityPreviewScreenViewModel {
    
    private func prepareData(communityList: [AmityCommunityModel]) {
        self.communityList = communityList
        delegate?.screenViewModel(self, didRetrieveCommunityList: communityList)
    }
    
}
