//
//  NotificationTrayScreenViewModel.swift
//  AmityUIKit
//
//  Created by GuIDe'MacbookAmityHQ on 31/10/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import AmitySDK

class NotificationTrayScreenViewModel: NotificationTrayScreenViewModelType {
    
    weak var delegate: NotificationTrayScreenViewModelDelegate?
    
    private var collectionData: NotificationHistory?
    
    init() {
        fetchData()
        updateReadTray()
    }
    
    func fetchData() {
        customAPIRequest.getNotificationHistory() { [self] (result) in
            collectionData = result
            delegate?.screenViewModelDidUpdateData(self)
        }
    }
    
    private func updateReadTray() {
        customAPIRequest.updateHasReadTray() { result in
            if result != "Success" {
                
            }
        }
    }
    
    // MARK: - Data Source
    
    func numberOfItems() -> Int {
        return collectionData?.data?.count ?? 0
    }
    
    func item(at indexPath: IndexPath) -> NotificationModel? {
        return collectionData?.data?[indexPath.row]
    }
    
    func loadNext() {
//        guard let collection = categoryCollection else { return }
//        switch collection.loadingStatus {
//        case .loaded:
//            collection.nextPage()
//        default:
//            break
//        }
    }
    
    func updateReadItem(model: NotificationModel) {
        customAPIRequest.updateHasReadItem(verb: model.verb ?? "", targetId: model.targetId ?? "", targetGroup: model.targetGroup ?? "") { result in
            if result != "Success" {
            }
        }
    }
    
}
