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
        recommendedController.retrieve { [weak self] result in
            self?.debouncer.run {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let community):
                    strongSelf.communities = community
                    strongSelf.delegate?.screenViewModel(strongSelf, didRetrieveRecommended: community, isEmpty: community.isEmpty)
                case .failure(let error):
                    strongSelf.delegate?.screenViewModel(strongSelf, didFail: error)
                }
            }
        }
    }
}
