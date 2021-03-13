//
//  EkoRecommendedCommunityScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoRecommendedCommunityScreenViewModel: EkoRecommendedCommunityScreenViewModelType {
    
    weak var delegate: EkoRecommendedCommunityScreenViewModelDelegate?
    
    // MARK: - Controller
    private let recommendedController: EkoCommunityRecommendedControllerProtocol
    
    // MARK: - Properties
    private var communities: [EkoCommunityModel] = []
    private let debouncer = Debouncer(delay: 0.3)
    
    init(recommendedController: EkoCommunityRecommendedControllerProtocol) {
        self.recommendedController = recommendedController
    }
    
}

// MARK: - DataSource
extension EkoRecommendedCommunityScreenViewModel {
    
    func numberOfRecommended() -> Int {
        return communities.count
    }
    
    func community(at indexPath: IndexPath) -> EkoCommunityModel {
        return communities[indexPath.row]
    }
    
}

// MARK: - Action
extension EkoRecommendedCommunityScreenViewModel {
    func retrieveRecommended() {
        recommendedController.retrieve { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.debouncer.run {
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
