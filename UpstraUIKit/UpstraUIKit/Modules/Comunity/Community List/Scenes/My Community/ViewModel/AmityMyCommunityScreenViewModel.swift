//
//  AmityMyCommunityScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityMyCommunityScreenViewModel: AmityMyCommunityScreenViewModelType {
    
    weak var delegate: AmityMyCommunityScreenViewModelDelegate?
    
    // MARK: - Manager
    private let communityListRepositoryManager: AmityCommunityListRepositoryManagerProtocol
    
    // MARK: - Properties
    private let debouncer = Debouncer(delay: 0.3)
    private var communityList: [AmityCommunityModel] = []
    private(set) var searchText: String = ""
    private var isSearched: Bool = false
    
    init(communityListRepositoryManager: AmityCommunityListRepositoryManagerProtocol) {
        self.communityListRepositoryManager = communityListRepositoryManager
    }
    
}

// MARK: - DataSource
extension AmityMyCommunityScreenViewModel {
    
    func numberOfCommunity() -> Int {
        return communityList.count
    }
    
    func item(at indexPath: IndexPath) -> AmityCommunityModel? {
        guard !communityList.isEmpty else { return nil }
        return communityList[indexPath.row]
    }
    
}

// MARK: - Action
extension AmityMyCommunityScreenViewModel {
    
    func retrieveAllCommunity() {
        communityList = []
        
        delegate?.screenViewModel(self, loadingState: .loading)
        communityListRepositoryManager.search(withText: "", filter: .userIsMember) { [weak self] (communityList) in
            self?.debouncer.run {
                self?.prepareData(isRetrieveAllCommunity: true, communityList: communityList)
            }
        }
    }
    
    func search(withText text: String?) {
        guard let text = text else { return }
        searchText = text
        communityList = []

        delegate?.screenViewModel(self, loadingState: .loading)
        communityListRepositoryManager.search(withText: text, filter: .userIsMember) { [weak self] (communityList) in
            self?.debouncer.run {
                self?.prepareData(isRetrieveAllCommunity: false, communityList: communityList)
            }
        }
    }
    
    private func prepareData(isRetrieveAllCommunity: Bool, communityList: [AmityCommunityModel]) {
        self.communityList = communityList
        
        if isRetrieveAllCommunity {
            delegate?.screenViewModelDidRetrieveAllCommunity(self)
        } else {
            if communityList.isEmpty {
                delegate?.screenViewModelDidSearchNotFound(self)
            } else {
                delegate?.screenViewModelDidSearch(self)
            }
        }
        
        delegate?.screenViewModel(self, loadingState: .loaded)
    }
    
    func loadMore() {
        communityListRepositoryManager.loadMore()
    }

    func searchCancel() {
        communityList = []
        delegate?.screenViewModelDidSearchCancel(self)
    }
    
}

