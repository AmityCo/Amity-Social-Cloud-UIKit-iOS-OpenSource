//
//  AmityCommunitySearchScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityCommunitySearchScreenViewModel: AmityCommunitySearchScreenViewModelType {
    weak var delegate: AmityCommunitySearchScreenViewModelDelegate?
    
    // MARK: - Manager
    private let communityListRepositoryManager: AmityCommunityListRepositoryManagerProtocol
    
    // MARK: - Properties
    private let debouncer = Debouncer(delay: 0.3)
    private var communityList: [AmityCommunityModel] = []
    
    init(communityListRepositoryManager: AmityCommunityListRepositoryManagerProtocol) {
        self.communityListRepositoryManager = communityListRepositoryManager
    }
}

// MARK: - DataSource
extension AmityCommunitySearchScreenViewModel {
    
    func numberOfCommunity() -> Int {
        return communityList.count
    }
    
    func item(at indexPath: IndexPath) -> AmityCommunityModel? {
        guard !communityList.isEmpty else { return nil }
        return communityList[indexPath.row]
    }
    
}

// MARK: - Action
extension AmityCommunitySearchScreenViewModel {
    
    func search(withText text: String?) {
        communityList = []
        guard let text = text, !text.isEmpty else {
            delegate?.screenViewModelDidClearText(self)
            delegate?.screenViewModel(self, loadingState: .loaded)
            return
        }

        delegate?.screenViewModel(self, loadingState: .loading)
        communityListRepositoryManager.search(withText: text, filter: .all) { [weak self] (communityList) in
            self?.debouncer.run {
                self?.prepareData(communityList: communityList)
            }
        }
    }
    
    private func prepareData(communityList: [AmityCommunityModel]) {
        self.communityList = communityList
        if communityList.isEmpty {
            delegate?.screenViewModelDidSearchNotFound(self)
        } else {
            delegate?.screenViewModelDidSearch(self)
        }
        delegate?.screenViewModel(self, loadingState: .loaded)
    }
    
    func loadMore() {
        communityListRepositoryManager.loadMore()
    }
    
}
