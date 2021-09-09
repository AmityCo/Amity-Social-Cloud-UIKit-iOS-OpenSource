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
    weak var delegate: AmityCommunityHomePageScreenViewModelDelegate?
    
    private let communityRepository: AmityCommunityRepository
    private var communityCollection: AmityCollection<AmityCommunity>?
    private var communityToken: AmityNotificationToken?
    private var categoryCollection: AmityCollection<AmityCommunityCategory>?
    private var categoryToken: AmityNotificationToken?
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    var baseOnJoinPage: PageType
    var fromDeeplinks: Bool
    var deeplinksType: DeeplinksType?
    var categoryItems: [AmityCommunityCategoryModel]
    
    init(deeplinksType: DeeplinksType? = nil, fromDeeplinks: Bool = false) {
        communityRepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
        
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

//MARK: Action
extension AmityCommunityHomePageScreenViewModel {
    func fetchCommunities() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.communityCollection = self.communityRepository
//               .getCommunitiesWithKeyword(nil,
//                                          filter: .userIsMember,
//                                          sortBy: .firstCreated,
//                                          categoryId: nil,
//                                          includeDeleted: false)
//           
//            if self.communityCollection?.count() == 0 {
//                self.baseOnJoinPage = .explore
//                self.delegate?.didFetchCommunitiesSuccess(page: self.baseOnJoinPage)
//           } else {
//                self.communityToken = self.communityCollection?.observeOnce { [weak self] (collection, _, error) in
//                   guard let self = self else { return }
//                   
//                   if let error = error {
//                       self.delegate?.didFetchCommunitiesFailure(error: error)
//                       
//                       return
//                   }
//                   
//                   let page: PageType = collection.count() > 0 ? .newsFeed : .explore
//                   self.baseOnJoinPage = page
//                   self.delegate?.didFetchCommunitiesSuccess(page: page)
//               }
//           }
//        }
    }
    
    func fetchProfileImage(with userId: String) {
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
//        let requestWorkItem = DispatchWorkItem {
//            AmityFileService.shared.loadSingleProfileImage(with: userId) { [weak self] result in
//                switch result {
//                case .success(let image):
//                    self?.delegate?.didFetchProfileImageSuccess(image: image)
//                case .failure:
//                    self?.delegate?.didFetchProfileImageFailure()
//                    break
//                }
//            }
//        }
//
//        pendingRequestWorkItem = requestWorkItem
//        DispatchQueue.main.async(execute: requestWorkItem)
    }
    
    func fetchCategories() {
//        categoryCollection = communityRepository.getAllCategories(.displayName, includeDeleted: false)
        categoryCollection = communityRepository.getCategories(sortBy: .displayName, includeDeleted: false)
        categoryToken = categoryCollection?.observeOnce { [weak self] collection, _, error in
            if let error = error {
                self?.delegate?.didFetchCommunitiesFailure(error: error)
                return
            }
            self?.categoryItems = []
            let numberOfItem = collection.count()
            for index in 0..<numberOfItem {
                guard let item = collection.object(at: index) else { return }
                let model = AmityCommunityCategoryModel(object: item)
                self?.categoryItems.append(model)
            }
            self?.delegate?.didFetchCategoriesSuccess()
        }
    }
}
