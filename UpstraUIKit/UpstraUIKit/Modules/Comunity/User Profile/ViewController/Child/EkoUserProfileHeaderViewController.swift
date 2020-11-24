//
//  EkoUserProfileHeaderViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat
import UIKit

public class EkoUserProfileHeaderSetting {
    
    static let shared = EkoUserProfileHeaderSetting()
    
    public var shouldChatButtonHide: Bool = true
    
}

class EkoUserProfileHeaderViewController: EkoViewController {
    
    // MARK: - Properties
    
    public var settings = EkoUserProfileHeaderSetting.shared
    
    @IBOutlet weak var avatarView: EkoAvatarView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editProfileButton: EkoButton!
    @IBOutlet weak var messageButton: EkoButton!
    
    private let screenViewModel: EkoUserProfileScreenViewModelType
    
    // MARK: Initializer
    
    private init(viewModel: EkoUserProfileScreenViewModelType) {
        self.screenViewModel = viewModel
        super.init(nibName: EkoUserProfileHeaderViewController.identifier, bundle: UpstraUIKit.bundle)
    }
    
    static func make(with viewModel: EkoUserProfileScreenViewModelType) -> EkoUserProfileHeaderViewController {
        let vc = EkoUserProfileHeaderViewController(viewModel: viewModel)
        return vc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
    }
    
    // MARK: Setup
    
    private func setupView() {
        navigationController?.setBackgroundColor(with: .clear, shadow: false)
        setupDisplayName()
        setupDescription()
        setupEditButton()
        setupChatButton()
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
        messageButton.layer.borderColor = EkoColorSet.base.blend(.shade3).cgColor
        messageButton.layer.borderWidth = 1
        messageButton.layer.cornerRadius = 6
        messageButton.isHidden = settings.shouldChatButtonHide
    }
    
    private func update(with user: EkoUserModel) {
        avatarView.setImage(withImageId: user.avatarFileId, placeholder: EkoIconSet.defaultAvatar)
        displayNameLabel.text = user.displayName
        descriptionLabel.text = user.about
        editProfileButton.isHidden = !user.isCurrentUser
        messageButton.isHidden = settings.shouldChatButtonHide || user.isCurrentUser
    }
    
    @IBAction func editButtonTap(_ sender: Any) {
        let editProfileViewController = EkoEditUserProfileViewController.make()
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    @IBAction func chatButtonTap(_ sender: Any) {
        screenViewModel.action.createChannel()
    }
    
}

// MARK: - Binding ViewModel
private extension EkoUserProfileHeaderViewController {
    
    func bindingViewModel() {
        screenViewModel.dataSource.userHeader.bind { [weak self] in
            if let user = $0 {
                self?.update(with: user)
            }
        }
        screenViewModel.dataSource.channel.bind { [weak self] channel in
            guard let strongSelf = self, let channelId = channel?.channelId else { return }
            EkoEventHandler.shared.channelDidTap(from: strongSelf, channelId: channelId)
        }
    }
    
}
