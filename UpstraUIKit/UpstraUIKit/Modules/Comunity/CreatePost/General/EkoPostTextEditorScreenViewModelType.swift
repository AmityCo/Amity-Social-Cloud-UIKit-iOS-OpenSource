//
//  EkoPostTextEditorScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 26/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

enum EkoPostMode: Equatable {
    case create
    case edit(EkoPostModel)
    
    static func == (lhs: EkoPostMode, rhs: EkoPostMode) -> Bool {
        if case .create = lhs, case .create = rhs {
            return true
        }
        return false
    }
}

public enum EkoPostTarget {
    case myFeed
    case community(object: EkoCommunityModel)
}

protocol EkoPostTextEditorScreenViewModelDataSource {
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> EkoPost?
}

protocol EkoPostTextEditorScreenViewModelDelegate: class {
    func screenViewModelDidCreatePost(_ viewModel: EkoPostTextEditorScreenViewModel, error: Error?)
    func screenViewModelDidUpdatePost(_ viewModel: EkoPostTextEditorScreenViewModel, error: Error?)
}

protocol EkoPostTextEditorScreenViewModelAction {
    func createPost(text: String, images: [EkoImage], files: [EkoDocument], communityId: String?)
    func likePost(postId: String)
    func unlikePost(postId: String)
    func likeComment(commentId: String)
    func unlikeComment(commentId: String)
}

protocol EkoPostTextEditorScreenViewModelType: EkoPostTextEditorScreenViewModelAction, EkoPostTextEditorScreenViewModelDataSource {
    var action: EkoPostTextEditorScreenViewModelAction { get }
    var dataSource: EkoPostTextEditorScreenViewModelDataSource { get }
    var delegate: EkoPostTextEditorScreenViewModelDelegate? { get set }
}

extension EkoPostTextEditorScreenViewModelType {
    var action: EkoPostTextEditorScreenViewModelAction { return self }
    var dataSource: EkoPostTextEditorScreenViewModelDataSource { return self }
}
