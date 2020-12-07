//
//  EkoRecommendedCommunityScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoRecommendedCommunityScreenViewModel: EkoRecommendedCommunityScreenViewModelType {
    private let repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var recommendedCollection: EkoCollection<EkoCommunity>?
    private var recommendedToken: EkoNotificationToken?
    private let RECOMMENDED_MAX: Int = 4
    
    // MARK: - DataSource
    var community: EkoBoxBinding<[EkoCommunityModel]> = EkoBoxBinding([])
    var isNoData: EkoBoxBinding<Bool> = EkoBoxBinding(true)
    
}

extension EkoRecommendedCommunityScreenViewModel {
    func getRecommendedCommunity() {
        isNoData.value = true
        community.value.removeAll()
        recommendedCollection = repository.getRecommendedCommunities()
        
        recommendedToken = recommendedCollection?.observe { [weak self] (collection, change, error) in
            guard let strongSelf = self, strongSelf.community.value.isEmpty else { return }
            if collection.dataStatus == .fresh {
                strongSelf.recommendedToken?.invalidate()
                strongSelf.prepareDataSource()
            }
        }
    }
    
    func item(at indexPath: IndexPath) -> EkoCommunityModel? {
        guard !community.value.isEmpty else { return nil }
        return community.value[indexPath.row]
    }
    
    private func prepareDataSource() {
        guard let collection = recommendedCollection else { return }
        var community: [EkoCommunityModel] = []
        for index in 0..<collection.count() {
            guard index < self.RECOMMENDED_MAX else { break }
            guard let object = collection.object(at: index) else { continue }
            let model = EkoCommunityModel(object: object)
            community.append(model)
            isNoData.value = false
        }
        self.community.value = community
    }
    
}
