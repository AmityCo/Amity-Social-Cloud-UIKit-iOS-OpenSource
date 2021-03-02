//
//  EkoMessageListHeaderView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 1/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoMessageListHeaderView: EkoView {
    
    // MARK: - Properties
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var backButton: UIButton!
    
    // MARK: - Properties
    private var screenViewModel: EkoMessageListScreenViewModelType?

    convenience init(viewModel: EkoMessageListScreenViewModelType) {
        self.init(frame: .zero)
        
        loadNibContent()
        screenViewModel = viewModel
        setupView()
    }
}

// MARK: - Action
private extension EkoMessageListHeaderView {
    @IBAction func backTap() {
        screenViewModel?.action.route(for: .pop)
    }
}

private extension EkoMessageListHeaderView {
    func setupView() {
        contentView.backgroundColor = EkoColorSet.backgroundColor
        
        backButton.tintColor = EkoColorSet.base
        backButton.setImage(EkoIconSet.iconBack, for: .normal)
        
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.font = EkoFontSet.title
        
        avatarView.image = nil
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
}

extension EkoMessageListHeaderView {
    
    func updateViews(channel: EkoChannel) {
        displayNameLabel.text = channel.displayName ?? EkoLocalizedStringSet.anonymous.localizedString
        
        switch channel.channelType {
        case .standard:
            avatarView.image = nil
            avatarView.placeholder = EkoIconSet.defaultGroupChat
        case .conversation:
            if let avatarId = channel.avatarFileId {
                avatarView.setImage(withImageId: avatarId, placeholder: EkoIconSet.defaultAvatar)
            }
        default:
            break
        }
    }
}
