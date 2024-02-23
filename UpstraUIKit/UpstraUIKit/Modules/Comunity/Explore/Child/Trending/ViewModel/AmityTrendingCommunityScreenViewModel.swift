//
//  AmityTrendingCommunityScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

final class AmityTrendingCommunityScreenViewModel: AmityTrendingCommunityScreenViewModelType {
    
    weak var delegate: AmityTrendingCommunityScreenViewModelDelegate?
    
    // MARK: - Controller
    private let trendingController: AmityCommunityTrendingControllerProtocol
    
    // MARK: - Properties
    private var communities: [AmityCommunityModel] = []
    private let debouncer = Debouncer(delay: 0.3)
    
    init(trendingController: AmityCommunityTrendingControllerProtocol) {
        self.trendingController = trendingController
    }
    
}

// MARK: - DataSource {
extension AmityTrendingCommunityScreenViewModel {
    
    func numberOfTrending() -> Int {
        return communities.count
    }
    
    func community(at indexPath: IndexPath) -> AmityCommunityModel {
        return communities[indexPath.row]
    }

}

// MARK: - Action
extension AmityTrendingCommunityScreenViewModel {
    func retrieveTrending() {
        // This method can be called when explore page appears.
        self.debouncer.run { [weak self] in
            guard let self else { return }
            
            self.trendingController.retrieve { result in
                switch result {
                case .success(let community):
                    self.communities = community
                    self.delegate?.screenViewModel(self, didRetrieveTrending: community, isEmpty: community.isEmpty)
                case .failure(let error):
                    self.delegate?.screenViewModel(self, didFail: error)
                }
            }
        }
    }

}
