//
//  EkoTrendingCommunityScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoTrendingCommunityScreenViewModel: EkoTrendingCommunityScreenViewModelType {
    private let repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var trendingCollection: EkoCollection<EkoCommunity>?
    private var trendingToken: EkoNotificationToken?
    private let TRENDING_MAX: Int = 5
    
    // MARK: - DataSource
    var community: EkoBoxBinding<[EkoCommunityModel]> = EkoBoxBinding([])
}

// MARK: - Action
extension EkoTrendingCommunityScreenViewModel {
    func getTrending() {
        trendingCollection = repository.getRecommendedCommunities()
        trendingToken = trendingCollection?.observe { [weak self] (collection, change, error) in
            guard let strongSelf = self, strongSelf.community.value.isEmpty else { return }
            if collection.dataStatus == .fresh {
                strongSelf.trendingToken?.invalidate()
                strongSelf.prepareDataSource()
            }
        }
    }
    
    func item(at indexPath: IndexPath) -> EkoCommunityModel? {
        guard !community.value.isEmpty else { return nil }
        return community.value[indexPath.row]
    }
    
    private func prepareDataSource() {
        guard let collection = trendingCollection else { return }
        var community: [EkoCommunityModel] = []
        for index in 0..<collection.count() {
            guard index < TRENDING_MAX else { break }
            guard let object = collection.object(at: index) else { continue }
            let model = EkoCommunityModel(object: object)
            community.append(model)
        }
        self.community.value = community
    }
    
}
