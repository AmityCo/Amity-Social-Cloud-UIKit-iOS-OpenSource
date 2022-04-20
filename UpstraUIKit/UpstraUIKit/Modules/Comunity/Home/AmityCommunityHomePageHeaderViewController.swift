//
//  AmityCommunityHomePageHeaderViewControllerViewController.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 20/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

class AmityCommunityHomePageHeaderViewController: UIViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak private var searchBar: UISearchBar!
    
    // MARK: Initializer
    static func make() -> AmityCommunityHomePageHeaderViewController {
        let vc = AmityCommunityHomePageHeaderViewController(nibName: AmityCommunityHomePageHeaderViewController.identifier, bundle: AmityUIKitManager.bundle)
        return vc
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
