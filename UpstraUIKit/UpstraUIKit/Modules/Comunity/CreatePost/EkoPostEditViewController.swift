//
//  EkoPostEditViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 9/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat
import UIKit

/// A view controller for providing post editor.
public class EkoPostEditViewController: EkoPostTextEditorViewController {

    // This is a wrapper class to help fill in parameters.
    public static func make(withPostId postId: String, settings: EkoPostEditorSettings = EkoPostEditorSettings()) -> EkoPostEditViewController {
        return EkoPostEditViewController(postTarget: .myFeed, postMode: .edit(postId: postId), settings: settings)
    }
    
    #warning("Should support init with postId")
    
}
