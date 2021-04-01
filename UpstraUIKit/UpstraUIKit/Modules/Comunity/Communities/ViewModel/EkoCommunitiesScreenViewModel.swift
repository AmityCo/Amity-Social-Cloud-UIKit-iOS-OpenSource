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
    
    weak var delegate: EkoCommunitiesScreenViewModelDelegate?
    
    private let repository: EkoCommunityRepository
    private var searchCollection: EkoCollection<EkoCommunity>?
    private var searchToken: EkoNotificationToken?
    private let listType: ListType
    private let debouncer = Debouncer(delay: 0.3)
    
    init(listType: ListType) {
        repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
        self.listType = listType
    }
    
    // MARK: - DataSource
    private(set) var communities: [EkoCommunityModel] = []
    private(set) var loadingState: EkoLoadingState = .initial {
        didSet {
            delegate?.screenViewModel(self, didUpdateLoadingState: loadingState)
        }
    }
}

// MARK: - Action
extension EkoCommunitiesScreenViewModel {
    
    func search(with text: String?) {
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
        
        searchCollection = repository.getCommunitiesWithKeyword(text, filter: filter, sortBy: .displayName, categoryId: nil, includeDeleted: false)

        searchToken?.invalidate()
        searchToken = searchCollection?.observe { [weak self] (collection, change, error) in
            self?.debouncer.run {
                self?.prepareData()
            }
        }
    }
    
    private func prepareData() {
        guard let collection = searchCollection, collection.dataStatus == .fresh else {
            return
        }
        
        var communites: [EkoCommunityModel] = []
        for index in 0..<collection.count() {
            guard let object = collection.object(at: index) else { continue }
            let model = EkoCommunityModel(object: object)
            communites.append(model)
        }
        communities = communites
        loadingState = .loaded
        delegate?.screenViewModel(self, didUpdateCommunities: communites)
        
    }

    func loadMore() {
        guard let collection = searchCollection else { return }
        switch collection.loadingStatus {
        case .loaded:
            if collection.hasNext {
                collection.nextPage()
                loadingState = .loading
            }
        default:
            break
        }
    }
    
    func community(at indexPath: IndexPath) -> EkoCommunityModel {
        return communities[indexPath.row]
    }
    
    func resetData() {
        communities.removeAll()
        delegate?.screenViewModel(self, didUpdateCommunities: communities)
    }
}
