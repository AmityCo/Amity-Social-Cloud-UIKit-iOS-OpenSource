//
//  EkoCommentEditorController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommentEditorControllerProtocol {
    func delete(withComment comment: EkoCommentModel, completion: EkoRequestCompletion?)
    func edit(withComment comment: EkoCommentModel, text: String, completion: EkoRequestCompletion?)
}

final class EkoCommentEditorController: EkoCommentEditorControllerProtocol {
    
    private var editor: EkoCommentEditor?
    func delete(withComment comment: EkoCommentModel, completion: EkoRequestCompletion?) {
        editor = EkoCommentEditor(client: UpstraUIKitManagerInternal.shared.client, comment: comment.comment)
        editor?.delete(completion: completion)
    }
        
    func edit(withComment comment: EkoCommentModel, text: String, completion: EkoRequestCompletion?) {
        editor = EkoCommentEditor(client: UpstraUIKitManagerInternal.shared.client, comment: comment.comment)
        editor?.editText(text, completion: completion)
    }
}
