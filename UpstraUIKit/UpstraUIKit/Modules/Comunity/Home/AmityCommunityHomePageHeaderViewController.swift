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
    @IBOutlet weak private var headerTitleLabel: UILabel!
    @IBOutlet weak private var searchitleLabel: UILabel!
    @IBOutlet weak private var searchContentView: UIView!
    
    // MARK: Initializer
    static func make() -> AmityCommunityHomePageHeaderViewController {
        let vc = AmityCommunityHomePageHeaderViewController(nibName: AmityCommunityHomePageHeaderViewController.identifier, bundle: AmityUIKitManager.bundle)
        return vc
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderTitle()
        setupSearchView()
    }
    
    private func setupHeaderTitle() {
        headerTitleLabel.font = AmityFontSet.headerLine.withSize(28)
        headerTitleLabel.textColor = AmityColorSet.base
        headerTitleLabel.text = AmityLocalizedStringSet.communityTitle.localizedString
    }
    
    private func setupSearchView() {
        searchContentView.layer.cornerRadius = 20
        searchContentView.layer.borderWidth = 0.5
        searchContentView.layer.borderColor = UIColor.gray.cgColor
        searchContentView.clipsToBounds = true
        searchitleLabel.font = AmityFontSet.caption.withSize(16)
        searchitleLabel.text = AmityLocalizedStringSet.communitySearchTitle.localizedString
    }
}

private extension AmityCommunityHomePageHeaderViewController {
    
    @IBAction func searchBarTapped(_ sender: UIButton) {
        AmityEventHandler.shared.communityTopbarSearchTracking()
        let searchVC = AmitySearchViewController.make()
        let nav = UINavigationController(rootViewController: searchVC)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func scanQRTapped(_ sender: UIButton) {
        AmityEventHandler.shared.homeCommunityScanQRCodeTapped()
    }
}

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            
            // If masksToBounds is true, subviews will be
            // clipped to the rounded corners.
            layer.masksToBounds = (newValue > 0)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
