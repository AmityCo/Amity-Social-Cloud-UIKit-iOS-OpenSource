//
//  AmityMyFeedViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 19/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

public class AmityMyFeedViewController: AmityUserFeedViewController {
    
    // This is a wrapper class to help fill in parameters.
    public static func make() -> AmityMyFeedViewController {
        return AmityMyFeedViewController(feedType: .myFeed)
    }
    
}
