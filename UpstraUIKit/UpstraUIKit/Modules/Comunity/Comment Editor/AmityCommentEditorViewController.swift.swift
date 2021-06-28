//
//  AmityCommentEditorViewController.swift.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 19/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

/// A view controller for providing comment editor.
public class AmityCommentEditorViewController: AmityEditTextViewController {
    
    // This is a wrapper class to help fill in parameters.
    public static func make(text: String) -> AmityCommentEditorViewController {
        return AmityCommentEditorViewController(headerTitle: nil, text: text, editMode: .edit)
    }
    
}
