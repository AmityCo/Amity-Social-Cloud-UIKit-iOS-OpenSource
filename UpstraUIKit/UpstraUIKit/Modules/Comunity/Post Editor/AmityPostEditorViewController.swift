//
//  AmityPostEditorViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 9/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
import UIKit

/// A view controller for providing post editor.
public class AmityPostEditorViewController: AmityPostTextEditorViewController {

    // This is a wrapper class to help fill in parameters.
    public static func make(withPostId postId: String, settings: AmityPostEditorSettings = AmityPostEditorSettings()) -> AmityPostEditorViewController {
        return AmityPostEditorViewController(postTarget: .myFeed, postMode: .edit(postId: postId), settings: settings)
    }
    
}
