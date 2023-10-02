//
//  AmityMessageListHeaderView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 1/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityMessageListHeaderView: AmityView {
    
    // MARK: - Properties
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var backButton: UIButton!
    
    // MARK: - Collections
    private var repository: AmityUserRepository?
    private var token: AmityNotificationToken?
    
    // MARK: - Properties
    private var screenViewModel: AmityMessageListScreenViewModelType?

    convenience init(viewModel: AmityMessageListScreenViewModelType) {
        self.init(frame: .zero)
        loadNibContent()
        screenViewModel = viewModel
        setupView()
    }
}

// MARK: - Action
private extension AmityMessageListHeaderView {
    @IBAction func backTap() {
        screenViewModel?.action.route(for: .pop)
    }
}

private extension AmityMessageListHeaderView {
    func setupView() {
        repository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        
        contentView.backgroundColor = AmityColorSet.backgroundColor
        
        backButton.tintColor = AmityColorSet.base
        backButton.setImage(AmityIconSet.iconBack, for: .normal)
        
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.font = AmityFontSet.title
        
        avatarView.image = nil
        avatarView.placeholder = AmityIconSet.defaultAvatar
    }
}

extension AmityMessageListHeaderView {
    
    func updateViews(channel: AmityChannelModel) {
        displayNameLabel.text = channel.displayName
        switch channel.channelType {
        case .standard:
            avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultGroupChat)
        case .conversation:
            avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultAvatar)
            if !channel.getOtherUserId().isEmpty {
                token?.invalidate()
                token = repository?.getUser(channel.getOtherUserId()).observeOnce { [weak self] user, error in
                    guard let weakSelf = self else { return }
                    if let userObject = user.object {
                        weakSelf.displayNameLabel.text = userObject.displayName
                    }
                }
            }
        case .community:
            avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultGroupChat)
        default:
            break
        }
    }
}
