//
//  EkoRecentChatScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 8/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoRecentChatScreenViewModelDelegate: class {
    func screenViewModelDidGetChannel()
    func screenViewModelLoadingState(for state: EkoLoadingState)
    func screenViewModelRoute(for route: EkoRecentChatScreenViewModel.Route)
    func screenViewModelEmptyView(isEmpty: Bool)
}

protocol EkoRecentChatScreenViewModelDataSource {
    
    func channel(at indexPath: IndexPath) -> EkoChannelModel
    func numberOfRow(in section: Int) -> Int
}

protocol EkoRecentChatScreenViewModelAction {
    func viewDidLoad()
    func join(at indexPath: IndexPath)
    func loadMore()
}

protocol EkoRecentChatScreenViewModelType: EkoRecentChatScreenViewModelAction, EkoRecentChatScreenViewModelDataSource {
    var action: EkoRecentChatScreenViewModelAction { get }
    var dataSource: EkoRecentChatScreenViewModelDataSource { get }
    var delegate: EkoRecentChatScreenViewModelDelegate? { get set }
}

extension EkoRecentChatScreenViewModelType {
    var action: EkoRecentChatScreenViewModelAction { return self }
    var dataSource: EkoRecentChatScreenViewModelDataSource { return self }
}
