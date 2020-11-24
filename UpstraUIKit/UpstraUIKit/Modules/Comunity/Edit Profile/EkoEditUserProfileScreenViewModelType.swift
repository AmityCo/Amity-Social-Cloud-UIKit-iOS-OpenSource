//
//  EkoEditUserProfileScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

protocol EkoEditUserProfileScreenViewModelAction {
    func update(displayName: String, about: String)
    func update(avatar: UIImage, completion: ((Bool) -> Void)?)
}

protocol EkoEditUserProfileScreenViewModelDataSource {
    var user: EkoUserModel? { get }
}

protocol EkoEditUserProfileScreenViewModelDelegate: class {
    func screenViewModelDidUpdate(_ viewModel: EkoEditUserProfileScreenViewModelType)
}

protocol EkoEditUserProfileScreenViewModelType: EkoEditUserProfileScreenViewModelAction, EkoEditUserProfileScreenViewModelDataSource {
    var action: EkoEditUserProfileScreenViewModelAction { get }
    var dataSource: EkoEditUserProfileScreenViewModelDataSource { get }
    var delegate: EkoEditUserProfileScreenViewModelDelegate? { get set }
}

extension EkoEditUserProfileScreenViewModelType {
    var action: EkoEditUserProfileScreenViewModelAction { return self }
    var dataSource: EkoEditUserProfileScreenViewModelDataSource { return self }
}
