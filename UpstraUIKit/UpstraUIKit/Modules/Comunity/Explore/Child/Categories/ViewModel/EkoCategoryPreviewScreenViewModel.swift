//
//  EkoCategoryPreviewScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCategoryPreviewScreenViewModel: EkoCategoryPreviewScreenViewModelType {
    private let repository = EkoCommunityRepository(client: UpstraUIKitManager.shared.client)
    private var categoryCollection: EkoCollection<EkoCommunityCategory>?
    private var categoryToken: EkoNotificationToken?
    private let CATEGORY_MAX: UInt = 8
    
    // MARK: - DataSource
    var categories: EkoBoxBinding<[EkoCommunityCategoryModel]> = EkoBoxBinding([])
}

// MARK: - Action
extension EkoCategoryPreviewScreenViewModel {
    
    func getCategory() {
        categoryCollection = repository.getAllCategories(.displayName, includeDeleted: false)
        categoryToken = categoryCollection?.observe { [weak self] (collection, change, error) in
            if collection.dataStatus == .fresh {
                self?.categoryToken?.invalidate()
                self?.prepareDataSource()
            }
        }
    }
    
    func numberOfItem() -> Int {
        return categories.value.count
    }
    
    func item(at indexPath: IndexPath) -> EkoCommunityCategoryModel {
        return categories.value[indexPath.row]
    }
}

// MARK: - Private function
extension EkoCategoryPreviewScreenViewModel {
    
    private func prepareDataSource() {
        guard let categoryCollection = categoryCollection else { return }
        
        var items: [EkoCommunityCategoryModel] = []
        let numberOfItems = min(categoryCollection.count(), CATEGORY_MAX)
        
        for index in 0..<numberOfItems {
            if let object =  categoryCollection.object(at: index) {
                items.append(EkoCommunityCategoryModel(name: object.name, avatarFileId: object.avatarFileId, categoryId: object.categoryId))
            }
        }
        self.categories.value = items
    }
    
}
