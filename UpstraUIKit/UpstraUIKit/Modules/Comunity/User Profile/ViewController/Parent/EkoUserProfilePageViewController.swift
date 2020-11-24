//
//  EkoUserProfileViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

public class EkoUserProfilePageSetting {
    
    static let shared = EkoUserProfilePageSetting()
    
    // Child vc settings
    public var shouldChatButtonHide: Bool {
        get {
            return EkoUserProfileHeaderSetting.shared.shouldChatButtonHide
        }
        set {
            EkoUserProfileHeaderSetting.shared.shouldChatButtonHide = newValue
        }
    }
    
}

public final class EkoUserProfilePageViewController: EkoProfileViewController {
    
    // MARK: - Properties
    
    public var settings = EkoUserProfilePageSetting.shared
    
    private let header: EkoUserProfileHeaderViewController
    private let bottom: EkoUserProfileBottomViewController
    private let screenViewModel: EkoUserProfileScreenViewModelType
    private let postButton: EkoFloatingButton = EkoFloatingButton()
    
    private init(withUserId userId: String) {
        screenViewModel = EkoUserProfileScreenViewModel(userId: userId)
        header = EkoUserProfileHeaderViewController.make(with: screenViewModel)
        bottom = EkoUserProfileBottomViewController.make(with: screenViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make(withUserId userId: String) -> EkoUserProfilePageViewController {
        let vc = EkoUserProfilePageViewController(withUserId: userId)
        return vc
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
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

// MARK: - Binding ViewModel
private extension EkoUserProfilePageViewController {
    
    func bindingViewModel() {
        screenViewModel.action.getInfo()
        screenViewModel.dataSource.user.bind { [weak self] in
            guard let user = $0 else { return }
            self?.setupNavigationItem(isOwner: user.isCurrentUser)
            self?.postButton.isHidden = !user.isCurrentUser
        }
    }
    
}

