//
//  AmityUserProfileViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public class AmityUserProfilePageSettings {
    public init() { }
    public var shouldChatButtonHide: Bool = true
}

public final class AmityUserProfilePageViewController: AmityProfileViewController {
    
    // MARK: - Properties
    
    private var settings: AmityUserProfilePageSettings!
    private var header: AmityUserProfileHeaderViewController!
    private var bottom: AmityUserProfileBottomViewController!
    private let postButton: AmityFloatingButton = AmityFloatingButton()
    
    // MARK: - Initializer
    
    public static func make(withUserId userId: String, settings: AmityUserProfilePageSettings = AmityUserProfilePageSettings()) -> AmityUserProfilePageViewController {
        let vc = AmityUserProfilePageViewController()
        vc.header = AmityUserProfileHeaderViewController.make(withUserId: userId, settings: settings)
        vc.bottom = AmityUserProfileBottomViewController.make(withUserId: userId)
        return vc
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setBackgroundColor(with: .white)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.reset()
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        header.delegate = self
        postButton.image = AmityIconSet.iconCreatePost
        postButton.add(to: view, position: .bottomRight)
        postButton.actionHandler = { [weak self] _ in
            let vc = AmityPostCreatorViewController.make(postTarget: .myFeed)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            self?.present(nav, animated: true, completion: nil)
        }
    }
    
    private func setupNavigationItem(isOwner: Bool) {
        let item = UIBarButtonItem(image: AmityIconSet.iconOption, style: .plain, target: self, action: #selector(optionTap))
        item.tintColor = AmityColorSet.base
        navigationItem.rightBarButtonItem = isOwner ? item : nil
    }
    
    // MARK: - AmityProfileDataSource
    
    override func headerViewController() -> UIViewController {
        return header
    }
    
    override func bottomViewController() -> UIViewController & AmityProfilePagerAwareProtocol {
        return bottom
    }
    
    override func minHeaderHeight() -> CGFloat {
        return topInset
    }
    
}

private extension AmityUserProfilePageViewController {
    
    @objc func optionTap() {
        
    }
    
}

extension AmityUserProfilePageViewController: AmityUserProfileHeaderViewControllerDelegate {
    
    func userProfileHeader(_ viewController: AmityUserProfileHeaderViewController, didUpdateUser user: AmityUserModel) {
        setupNavigationItem(isOwner: user.isCurrentUser)
        postButton.isHidden = !user.isCurrentUser
    }
    
}
