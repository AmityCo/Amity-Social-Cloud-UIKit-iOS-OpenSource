//
//  AmityCommentCreateViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 19/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

/// A view controller for providing comment creator.
public class AmityCommentCreatorViewController: AmityEditTextViewController {
    
    // This is a wrapper class to help fill in parameters.
    public static func make(forCommunity communityId: String?, isReply: Bool) -> AmityCommentCreatorViewController {
        return AmityCommentCreatorViewController(headerTitle: nil, text: "", editMode: .create(communityId: communityId, isReply: isReply))
    }
    
}
