//
//  AmityCommentEditorViewController.swift.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 19/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

/// A view controller for providing comment editor.
public class AmityCommentEditorViewController: AmityEditTextViewController {
    
    // This is a wrapper class to help fill in parameters.
    public static func make(comment: AmityCommentModel, communityId: String?) -> AmityCommentEditorViewController {
        return AmityCommentEditorViewController(headerTitle: nil, text: comment.text, editMode: .edit(communityId: communityId, metadata: comment.metadata, isReply: comment.parentId != nil))
    }
    
}
