//
//  AmityEditUserProfileScreenViewModelType.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

protocol AmityUserProfileEditorScreenViewModelAction {
    func update(displayName: String, about: String)
    func update(avatar: UIImage, completion: ((Bool) -> Void)?)
}

protocol AmityUserProfileScreenEditorViewModelDataSource {
    var user: AmityUserModel? { get }
}

protocol AmityUserProfileEditorScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdate(_ viewModel: AmityUserProfileEditorScreenViewModelType)
}

protocol AmityUserProfileEditorScreenViewModelType: AmityUserProfileEditorScreenViewModelAction, AmityUserProfileScreenEditorViewModelDataSource {
    var action: AmityUserProfileEditorScreenViewModelAction { get }
    var dataSource: AmityUserProfileScreenEditorViewModelDataSource { get }
    var delegate: AmityUserProfileEditorScreenViewModelDelegate? { get set }
}

extension AmityUserProfileEditorScreenViewModelType {
    var action: AmityUserProfileEditorScreenViewModelAction { return self }
    var dataSource: AmityUserProfileScreenEditorViewModelDataSource { return self }
}
