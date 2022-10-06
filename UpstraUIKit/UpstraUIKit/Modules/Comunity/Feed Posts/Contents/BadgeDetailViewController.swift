//
//  BadgeDetailViewController.swift
//  AmityUIKit
//
//  Created by GuIDe'MacbookAmityHQ on 3/10/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit

class BadgeDetailViewController: UIViewController {
    
    @IBOutlet weak var roleIconImageView: UIImageView!
    @IBOutlet weak var roleNameLabel: UILabel!
    @IBOutlet weak var roleDescLabel: UILabel!
    
    public var userBadge: UserBadge.BadgeProfile!
    
    // MARK: - Initializer
    
    public static func make(withUserBadge userBadge: UserBadge.BadgeProfile) -> BadgeDetailViewController {
                
        let vc = BadgeDetailViewController(nibName: BadgeDetailViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.userBadge = userBadge
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayView()
    }
    
    func setupView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        
        roleNameLabel.font = AmityFontSet.title
        roleDescLabel.font = AmityFontSet.body
    }
    
    func displayView() {
        if let role = userBadge {
            roleIconImageView.downloaded(from: role.badgeIcon ?? "")
            var roleTitle = role.badgeTitleLocal
            var roleDesc = role.badgeDescriptionLocal
            if AmityUIKitManager.AmityLanguage != "th" {
                roleTitle = role.badgeTitleEn
                roleDesc = role.badgeDescriptionEn
            }
            roleNameLabel.text = roleTitle
            roleDescLabel.text = roleDesc
        }
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}
