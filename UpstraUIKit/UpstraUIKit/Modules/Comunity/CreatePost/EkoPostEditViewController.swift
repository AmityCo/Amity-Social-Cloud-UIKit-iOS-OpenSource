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
public class EkoPostEditViewController {

    // This is a wrapper class to help fill in parameters.
    public static func make(postTarget: EkoPostTarget, post: EkoPost) -> EkoViewController {
        let postModel = EkoPostModel(post: post)
        return EkoPostTextEditorViewController.make(postTarget: postTarget, postMode: .edit(postModel))
    }
    
    #warning("should support init with postId")
    
}
