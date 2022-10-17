//
//  AmityPostCreateViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 9/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import Photos

/// A view controller for providing post creator.
public class AmityPostCreatorViewController: AmityPostTextEditorViewController {

    // This is a wrapper class to help fill in parameters.
    public static func make(postTarget: AmityPostTarget, settings: AmityPostEditorSettings = AmityPostEditorSettings()) -> AmityPostCreatorViewController {
        return AmityPostCreatorViewController(postTarget: postTarget, postMode: .create, settings: settings)
    }
    
    // This is a wrapper class make for new make post button.
    public static func make(postTarget: AmityPostTarget, settings: AmityPostEditorSettings = AmityPostEditorSettings(), contentType: AmityPostContentType) -> AmityPostCreatorViewController {
        return AmityPostCreatorViewController(postTarget: postTarget, postMode: .create, settings: settings, contentType: contentType)
    }
    
    // This is a wrapper class to help fill in parameters when post from Today.
    public static func make(postTarget: AmityPostTarget, postType: PostFromTodayType, settings: AmityPostEditorSettings = AmityPostEditorSettings()) -> AmityPostCreatorViewController {
        return AmityPostCreatorViewController(postTarget: postTarget, postType: postType, postMode: .create, settings: settings)
    }
    
    // This is a wrapper class to help pre-image from gallery with URL.
    public static func make(postTarget: AmityPostTarget, url: [URL], mediaType: ShareExtensionMediaType, settings: AmityPostEditorSettings = AmityPostEditorSettings()) -> AmityPostCreatorViewController {
        return AmityPostCreatorViewController(postTarget: postTarget, postMode: .create, settings: settings, url: url, mediaType: mediaType)
    }
}
