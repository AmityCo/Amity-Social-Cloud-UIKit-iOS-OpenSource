//
//  EkoTrendingCommunityScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoTrendingCommunityScreenViewModel: EkoTrendingCommunityScreenViewModelType {
    
    weak var delegate: EkoTrendingCommunityScreenViewModelDelegate?
    
    // MARK: - Controller
    private let trendingController: EkoCommunityTrendingControllerProtocol
    
    // MARK: - Properties
    private var communities: [EkoCommunityModel] = []
    private let debouncer = Debouncer(delay: 0.3)
    
    init(trendingController: EkoCommunityTrendingControllerProtocol) {
        self.trendingController = trendingController
    }
    
}

// MARK: - DataSource {
extension EkoTrendingCommunityScreenViewModel {
    
    func numberOfTrending() -> Int {
        return communities.count
    }
    
    func community(at indexPath: IndexPath) -> EkoCommunityModel {
        return communities[indexPath.row]
    }

}

// MARK: - Action
extension EkoTrendingCommunityScreenViewModel {
    func retrieveTrending() {
        trendingController.retrieve { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.debouncer.run {
                switch result {
                case .success(let community):
                    strongSelf.communities = community
                    strongSelf.delegate?.screenViewModel(strongSelf, didRetrieveTrending: community, isEmpty: community.isEmpty)
                case .failure(let error):
                    strongSelf.delegate?.screenViewModel(strongSelf, didFail: error)
                }
            }
        }
    }

}
