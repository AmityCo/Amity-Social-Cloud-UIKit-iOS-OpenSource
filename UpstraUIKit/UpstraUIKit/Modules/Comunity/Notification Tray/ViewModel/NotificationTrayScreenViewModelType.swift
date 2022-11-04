//
//  NotificationTrayScreenViewModelType.swift
//  AmityUIKit
//
//  Created by GuIDe'MacbookAmityHQ on 31/10/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import AmitySDK

protocol NotificationTrayScreenViewModelDataSource {
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> NotificationModel?
    func loadNext()
}

protocol NotificationTrayScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdateData(_ viewModel: NotificationTrayScreenViewModel)
}

protocol NotificationTrayScreenViewModelAction {}

protocol NotificationTrayScreenViewModelType: NotificationTrayScreenViewModelAction, NotificationTrayScreenViewModelDataSource {
    var action: NotificationTrayScreenViewModelAction { get }
    var dataSource: NotificationTrayScreenViewModelDataSource { get }
    var delegate: NotificationTrayScreenViewModelDelegate? { get set }
}

extension NotificationTrayScreenViewModelType {
    var action: NotificationTrayScreenViewModelAction { return self }
    var dataSource: NotificationTrayScreenViewModelDataSource { return self }
}
