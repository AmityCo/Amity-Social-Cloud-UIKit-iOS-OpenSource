//
//  AmityRecommendedCommunityScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

final class AmityRecommendedCommunityScreenViewModel: AmityRecommendedCommunityScreenViewModelType {
    
    weak var delegate: AmityRecommendedCommunityScreenViewModelDelegate?
    
    // MARK: - Controller
    private let recommendedController: AmityCommunityRecommendedControllerProtocol
    
    // MARK: - Properties
    private var communities: [AmityCommunityModel] = []
    private let debouncer = Debouncer(delay: 0.3)
    
    init(recommendedController: AmityCommunityRecommendedControllerProtocol) {
        self.recommendedController = recommendedController
    }
    
}

// MARK: - DataSource
extension AmityRecommendedCommunityScreenViewModel {
    
    func numberOfRecommended() -> Int {
        return communities.count
    }
    
    func community(at indexPath: IndexPath) -> AmityCommunityModel {
        return communities[indexPath.row]
    }
    
}

// MARK: - Action
extension AmityRecommendedCommunityScreenViewModel {
    func retrieveRecommended() {
        self.debouncer.run { [weak self] in
            guard let self else { return }
            
            self.recommendedController.retrieve { result in
                switch result {
                case .success(let community):
                    self.communities = community
                    self.delegate?.screenViewModel(self, didRetrieveRecommended: community, isEmpty: community.isEmpty)
                case .failure(let error):
                    self.delegate?.screenViewModel(self, didFail: error)
                }
            }
        }
    }
}
