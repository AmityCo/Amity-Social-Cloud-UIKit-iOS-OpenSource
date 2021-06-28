//
//  AmityCommunityCreatorViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 23/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

public class AmityCommunityCreatorViewController: AmityCommunityProfileEditorViewController {
    
    public static func make() -> AmityCommunityCreatorViewController {
        return AmityCommunityCreatorViewController(viewType: .create)
    }
    
}
