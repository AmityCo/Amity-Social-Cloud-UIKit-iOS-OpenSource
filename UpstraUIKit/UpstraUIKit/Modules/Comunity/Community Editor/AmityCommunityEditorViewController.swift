//
//  AmityCommunityEditorViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 23/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

public class AmityCommunityEditorViewController: AmityCommunityProfileEditorViewController {
    
    public static func make(withCommunityId communityId: String) -> AmityCommunityEditorViewController {
        return AmityCommunityEditorViewController(viewType: .edit(communityId: communityId))
    }
    
}

