//
//  AmityPostCreateViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 9/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

/// A view controller for providing post creator.
public class AmityPostCreatorViewController: AmityPostTextEditorViewController {

    // This is a wrapper class to help fill in parameters.
    public static func make(postTarget: AmityPostTarget, settings: AmityPostEditorSettings = AmityPostEditorSettings()) -> AmityPostCreatorViewController {
        return AmityPostCreatorViewController(postTarget: postTarget, postMode: .create, settings: settings)
    }
    
}
