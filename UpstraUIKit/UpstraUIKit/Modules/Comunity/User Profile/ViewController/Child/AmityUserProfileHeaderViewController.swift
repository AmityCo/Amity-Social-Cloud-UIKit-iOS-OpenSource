//
//  AmityUserProfileHeaderViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
import UIKit

protocol AmityUserProfileHeaderViewControllerDelegate: class {
func userProfileHeader(_ viewController: AmityUserProfileHeaderViewController, didUpdateUser user: AmityUserModel)
}

class AmityUserProfileHeaderViewController: AmityViewController, AmityRefreshable {
    
    // MARK: - Properties

    weak var delegate: AmityUserProfileHeaderViewControllerDelegate?
    
    @IBOutlet weak var avatarView: AmityAvatarView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editProfileButton: AmityButton!
    @IBOutlet weak var messageButton: AmityButton!
    
    private let screenViewModel: AmityUserProfileScreenViewModelType
    private let settings: AmityUserProfilePageSettings
    
    // MARK: Initializer
    
    private init(userId: String, settings: AmityUserProfilePageSettings) {
        screenViewModel = AmityUserProfileScreenViewModel(userId: userId)
        self.settings = settings
        super.init(nibName: AmityUserProfileHeaderViewController.identifier, bundle: AmityUIKitManager.bundle)
    }
    
    static func make(withUserId userId: String, settings: AmityUserProfilePageSettings) -> AmityUserProfileHeaderViewController {
        return AmityUserProfileHeaderViewController(userId: userId, settings: settings)
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
        avatarView.placeholder = AmityIconSet.defaultAvatar
        postCountLabel.isHidden = true
        displayNameLabel.text = ""
        displayNameLabel.font = AmityFontSet.headerLine
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.numberOfLines = 3
    }
    
    private func setupDescription() {
        descriptionLabel.text = ""
        descriptionLabel.font = AmityFontSet.body
        descriptionLabel.textColor = AmityColorSet.base
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupEditButton() {
        editProfileButton.setImage(AmityIconSet.iconEdit, position: .left)
        editProfileButton.setTitle(AmityLocalizedStringSet.communityDetailEditProfileButton.localizedString, for: .normal)
        editProfileButton.tintColor = AmityColorSet.secondary
        editProfileButton.layer.borderColor = AmityColorSet.base.blend(.shade3).cgColor
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.cornerRadius = 6
        editProfileButton.isHidden = true
    }
    
    private func setupChatButton() {
        messageButton.setImage(AmityIconSet.iconChat, position: .left)
        messageButton.setTitle(AmityLocalizedStringSet.communityDetailMessageButton.localizedString, for: .normal)
        messageButton.tintColor = AmityColorSet.secondary
        messageButton.layer.borderColor = AmityColorSet.secondary.blend(.shade3).cgColor
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
    
    private func updateView(with user: AmityUserModel) {
        avatarView.setImage(withImageURL: user.avatarURL, placeholder: AmityIconSet.defaultAvatar)
        displayNameLabel.text = user.displayName
        descriptionLabel.text = user.about
        editProfileButton.isHidden = !user.isCurrentUser
        messageButton.isHidden = settings.shouldChatButtonHide || user.isCurrentUser
    }
    
    @IBAction func editButtonTap(_ sender: Any) {
        AmityEventHandler.shared.editUserDidTap(from: self, userId: screenViewModel.userId)
    }
    
    @IBAction func chatButtonTap(_ sender: Any) {
        screenViewModel.action.createChannel { [weak self] channel in
            guard let strongSelf = self, let channelId = channel?.channelId else { return }
            AmityEventHandler.shared.channelDidTap(from: strongSelf, channelId: channelId)
        }
    }
    
}
