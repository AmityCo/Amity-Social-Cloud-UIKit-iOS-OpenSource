//
//  EkoSelectCategoryListScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 2/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

class EkoSelectCategoryListScreenViewModel: EkoSelectCategoryListScreenViewModelType {
    
    weak var delegate: EkoSelectCategoryListScreenViewModelDelegate?
    
    private let categoryRepository = EkoCommunityRepository(client: UpstraUIKitManager.shared.client)
    private var categoryCollection: EkoCollection<EkoCommunityCategory>?
    private var categoryToken: EkoNotificationToken?
    
    init() {
        setupCollection()
    }
    
    private func setupCollection() {
        categoryCollection = categoryRepository.getAllCategories(.displayName, includeDeleted: false)
        categoryToken = categoryCollection?.observe { [weak self] collection, _, error in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.screenViewModelDidUpdateData(strongSelf)
        }
    }
    
    // MARK: - Data Source
    
    func numberOfItems() -> Int {
        return Int(categoryCollection?.count() ?? 0)
    }
    
    func item(at indexPath: IndexPath) -> EkoCommunityCategory? {
        return categoryCollection?.object(at: UInt(indexPath.row))
    }
    
    func loadNext() {
        guard let collection = categoryCollection else { return }
        switch collection.loadingStatus {
        case .loaded:
            collection.nextPage()
        default:
            break
        }
    }
    
}
