//
//  AmityPostTextEditorScreenViewModelType.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 26/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityPostMode: Equatable {
    case create
    case edit(postId: String)
    
    static func == (lhs: AmityPostMode, rhs: AmityPostMode) -> Bool {
        if case .create = lhs, case .create = rhs {
            return true
        }
        return false
    }
}

public enum AmityPostTarget {
    case myFeed
    case community(object: AmityCommunity)
}

protocol AmityPostTextEditorScreenViewModelDataSource {
    func loadPost(for postId: String)
}

protocol AmityPostTextEditorScreenViewModelDelegate: AnyObject {
    func screenViewModelDidLoadPost(_ viewModel: AmityPostTextEditorScreenViewModel, post: AmityPost)
    func screenViewModelDidCreatePost(_ viewModel: AmityPostTextEditorScreenViewModel, post: AmityPost?, error: Error?)
    func screenViewModelDidUpdatePost(_ viewModel: AmityPostTextEditorScreenViewModel, error: Error?)
}

protocol AmityPostTextEditorScreenViewModelAction {
    func createPost(text: String, medias: [AmityMedia], files: [AmityFile], communityId: String?, metadata: [String: Any]?, mentionees: AmityMentioneesBuilder?)
    func updatePost(oldPost: AmityPostModel, text: String, medias: [AmityMedia], files: [AmityFile], metadata: [String: Any]?, mentionees: AmityMentioneesBuilder?)
}

protocol AmityPostTextEditorScreenViewModelType: AmityPostTextEditorScreenViewModelAction, AmityPostTextEditorScreenViewModelDataSource {
    var action: AmityPostTextEditorScreenViewModelAction { get }
    var dataSource: AmityPostTextEditorScreenViewModelDataSource { get }
    var delegate: AmityPostTextEditorScreenViewModelDelegate? { get set }
}

extension AmityPostTextEditorScreenViewModelType {
    var action: AmityPostTextEditorScreenViewModelAction { return self }
    var dataSource: AmityPostTextEditorScreenViewModelDataSource { return self }
}
