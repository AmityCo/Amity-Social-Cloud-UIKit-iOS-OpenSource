//
//  EkoCommunitiesScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 24/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunitiesScreenViewModel: EkoCommunitiesScreenViewModelType {
    enum Route {
        case initial
        case communityProfile(indexPath: IndexPath)
        case myCommunity
        case create
    }
    
    enum ListType {
        case newsfeedMyCommunities
        case myCommunities
        case searchCommunities
    }
    
    private let repository: EkoCommunityRepository
    private var searchCollection: EkoCollection<EkoCommunity>?
    private var searchToken: EkoNotificationToken?

    private let listType: ListType
    
    init(listType: ListType) {
        repository = EkoCommunityRepository(client: UpstraUIKitManager.shared.client)
        self.listType = listType
    }
    
    // MARK: - DataSource
    var searchCommunities: EkoBoxBinding<[EkoCommunityModel]> = EkoBoxBinding([])
    var route: EkoBoxBinding<Route> = EkoBoxBinding(.initial)
    var numberOfItems: EkoBoxBinding<Int> = EkoBoxBinding(0)
    var loading: EkoBoxBinding<EkoLoadingState> = EkoBoxBinding(.initial)
}

// MARK: - Action
extension EkoCommunitiesScreenViewModel {
    func route(to route: Route) {
        self.route.value = route
    }
    
    func search(with text: String?) {
        searchCommunities.value = []
        let filter: EkoCommunityQueryFilter
        switch listType {
        case .searchCommunities:
            filter = .all
            guard let text = text, !text.isEmpty else {
                return
            }
        case .myCommunities:
            filter = .userIsMember
        case .newsfeedMyCommunities:
            filter = .userIsMember
        }
        
        searchCollection = repository.getCommunitiesWithKeyword(text, filter: filter, sortBy: .lastCreated, categoryId: nil, includeDeleted: false)
        searchToken?.invalidate()
        searchToken = searchCollection?.observe ({ [weak self] (collection, change, error) in
            guard let self = self, self.searchCommunities.value.count < collection.count() else { return }
            for index in (UInt(self.searchCommunities.value.count)..<collection.count()) {
                guard let object = collection.object(at: index) else { continue }
                let model = EkoCommunityModel(object: object)
                let index = self.searchCommunities.value.firstIndex(where: { $0.communityId == object.communityId })
                if let index = index {
                    self.searchCommunities.value[index] = model
                } else {
                    self.searchCommunities.value.append(model)
                }
            }
            
            if self.listType != .searchCommunities && text == "" {
                self.searchCommunities.value = self.searchCommunities.value.sorted(by: {
                    return $0.displayName.localizedCaseInsensitiveCompare($01.displayName) == .orderedAscending
                })
            }
            self.numberOfItems.value = Int(collection.count())
            self.loading.value = .loaded
        })
    }

    func loadMore() {
        guard let collection = searchCollection else { return }
        switch collection.loadingStatus {
        case .loaded:
            if collection.hasNext {
                collection.nextPage()
                loading.value = .loadmore
            }
        default:
            break
        }
    }
    
    func community(at indexPath: IndexPath) -> EkoCommunityModel {
        return searchCommunities.value[indexPath.row]
    }
    
    func reset() {
        searchCommunities.value = []
    }
}
