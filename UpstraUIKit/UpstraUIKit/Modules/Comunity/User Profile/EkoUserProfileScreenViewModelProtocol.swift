//
//  EkoUserProfileScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoUserProfileScreenViewModelDataSource {
    var userId: String { get }
    var user: EkoBoxBinding<EkoUserModel?> { get }
    var userHeader: EkoBoxBinding<EkoUserModel?> { get }
    var channel: EkoBoxBinding<EkoChannel?> { get }
}

protocol EkoUserProfileScreenViewModelAction {
    func getInfo()
    func createChannel()
}

protocol EkoUserProfileScreenViewModelType: EkoUserProfileScreenViewModelAction, EkoUserProfileScreenViewModelDataSource {
    var action: EkoUserProfileScreenViewModelAction { get }
    var dataSource: EkoUserProfileScreenViewModelDataSource { get }
}

extension EkoUserProfileScreenViewModelType {
    var action: EkoUserProfileScreenViewModelAction { return self }
    var dataSource: EkoUserProfileScreenViewModelDataSource { return self }
}


