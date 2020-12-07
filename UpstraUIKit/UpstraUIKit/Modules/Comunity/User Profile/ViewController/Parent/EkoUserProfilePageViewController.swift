//
//  EkoUserProfileViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

public class EkoUserProfilePageSettings {
    public init() { }
    public var shouldChatButtonHide: Bool = true
}

public final class EkoUserProfilePageViewController: EkoProfileViewController {
    
    // MARK: - Properties
    
    private var settings: EkoUserProfilePageSettings!
    private var header: EkoUserProfileHeaderViewController!
    private var bottom: EkoUserProfileBottomViewController!
    private let postButton: EkoFloatingButton = EkoFloatingButton()
    
    // MARK: - Initializer
    
    public static func make(withUserId userId: String, settings: EkoUserProfilePageSettings = EkoUserProfilePageSettings()) -> EkoUserProfilePageViewController {
        let vc = EkoUserProfilePageViewController()
        vc.header = EkoUserProfileHeaderViewController.make(withUserId: userId, settings: settings)
        vc.bottom = EkoUserProfileBottomViewController.make(withUserId: userId)
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
        postButton.image = EkoIconSet.iconCreatePost
        postButton.add(to: view, position: .bottomRight)
        postButton.actionHandler = { [weak self] _ in
            let vc = EkoPostTextEditorViewController.make(postTarget: .myFeed)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            self?.present(nav, animated: true, completion: nil)
        }
    }
    
    private func setupNavigationItem(isOwner: Bool) {
        let item = UIBarButtonItem(image: EkoIconSet.iconOption, style: .plain, target: self, action: #selector(optionTap))
        item.tintColor = EkoColorSet.base
        navigationItem.rightBarButtonItem = isOwner ? item : nil
    }
    
    // MARK: - EkoProfileDataSource
    
    override func headerViewController() -> UIViewController {
        return header
    }
    
    override func bottomViewController() -> UIViewController & EkoProfilePagerAwareProtocol {
        return bottom
    }
    
    override func minHeaderHeight() -> CGFloat {
        return topInset
    }
    
}

private extension EkoUserProfilePageViewController {
    
    @objc func optionTap() {
        
    }
    
}

extension EkoUserProfilePageViewController: EkoUserProfileHeaderViewControllerDelegate {
    
    func userProfileHeader(_ viewController: EkoUserProfileHeaderViewController, didUpdateUser user: EkoUserModel) {
        setupNavigationItem(isOwner: user.isCurrentUser)
        postButton.isHidden = !user.isCurrentUser
    }
    
}
