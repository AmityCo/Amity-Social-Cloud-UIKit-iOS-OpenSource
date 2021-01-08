//
//  EkoUserProfileHeaderViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat
import UIKit

protocol EkoUserProfileHeaderViewControllerDelegate: class {
func userProfileHeader(_ viewController: EkoUserProfileHeaderViewController, didUpdateUser user: EkoUserModel)
}

class EkoUserProfileHeaderViewController: EkoViewController, EkoRefreshable {
    
    // MARK: - Properties

    weak var delegate: EkoUserProfileHeaderViewControllerDelegate?
    
    @IBOutlet weak var avatarView: EkoAvatarView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editProfileButton: EkoButton!
    @IBOutlet weak var messageButton: EkoButton!
    
    private let screenViewModel: EkoUserProfileScreenViewModelType
    private let settings: EkoUserProfilePageSettings
    
    // MARK: Initializer
    
    private init(userId: String, settings: EkoUserProfilePageSettings) {
        screenViewModel = EkoUserProfileScreenViewModel(userId: userId)
        self.settings = settings
        super.init(nibName: EkoUserProfileHeaderViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    static func make(withUserId userId: String, settings: EkoUserProfilePageSettings) -> EkoUserProfileHeaderViewController {
        return EkoUserProfileHeaderViewController(userId: userId, settings: settings)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewNavigation()
        setupDisplayName()
        setupDescription()
        setupEditButton()
        setupChatButton()
        setupViewModel()
    }
    
    // MARK: - Refreshable
    
    func handleRefreshing() {
        screenViewModel.dataSource.fetchUserData { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                strongSelf.updateView(with: user)
                strongSelf.delegate?.userProfileHeader(strongSelf, didUpdateUser: user)
            case .failure:
                break
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupViewNavigation() {
        navigationController?.setBackgroundColor(with: .clear, shadow: false)
    }
    
    private func setupDisplayName() {
        avatarView.placeholder = EkoIconSet.defaultAvatar
        postCountLabel.isHidden = true
        displayNameLabel.text = ""
        displayNameLabel.font = EkoFontSet.headerLine
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.numberOfLines = 3
    }
    
    private func setupDescription() {
        descriptionLabel.text = ""
        descriptionLabel.font = EkoFontSet.body
        descriptionLabel.textColor = EkoColorSet.base
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupEditButton() {
        editProfileButton.setImage(EkoIconSet.iconEdit, position: .left)
        editProfileButton.setTitle(EkoLocalizedStringSet.communityDetailEditProfileButton, for: .normal)
        editProfileButton.tintColor = EkoColorSet.secondary
        editProfileButton.layer.borderColor = EkoColorSet.base.blend(.shade3).cgColor
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.cornerRadius = 6
        editProfileButton.isHidden = true
    }
    
    private func setupChatButton() {
        messageButton.setImage(EkoIconSet.iconChat2, position: .left)
        messageButton.setTitle(EkoLocalizedStringSet.communityDetailMessageButton, for: .normal)
        messageButton.tintColor = EkoColorSet.secondary
        messageButton.layer.borderColor = EkoColorSet.secondary.blend(.shade3).cgColor
        messageButton.layer.borderWidth = 1
        messageButton.layer.cornerRadius = 6
        messageButton.isHidden = settings.shouldChatButtonHide
    }
    
    private func setupViewModel() {
        screenViewModel.dataSource.fetchUserData { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                strongSelf.updateView(with: user)
                strongSelf.delegate?.userProfileHeader(strongSelf, didUpdateUser: user)
            case .failure:
                break
            }
        }
    }
    
    private func updateView(with user: EkoUserModel) {
        avatarView.setImage(withImageId: user.avatarFileId, placeholder: EkoIconSet.defaultAvatar)
        displayNameLabel.text = user.displayName
        descriptionLabel.text = user.about
        editProfileButton.isHidden = !user.isCurrentUser
        messageButton.isHidden = settings.shouldChatButtonHide || user.isCurrentUser
    }
    
    @IBAction func editButtonTap(_ sender: Any) {
        EkoEventHandler.shared.editUserDidTap(from: self, userId: screenViewModel.userId)
    }
    
    @IBAction func chatButtonTap(_ sender: Any) {
        screenViewModel.action.createChannel { [weak self] channel in
            guard let strongSelf = self, let channelId = channel?.channelId else { return }
            EkoEventHandler.shared.channelDidTap(from: strongSelf, channelId: channelId)
        }
    }
    
}
