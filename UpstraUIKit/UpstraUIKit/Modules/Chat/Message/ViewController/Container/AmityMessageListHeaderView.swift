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
    
    func updateViews(channel: AmityChannel) {
        displayNameLabel.text = channel.displayName ?? AmityLocalizedStringSet.anonymous.localizedString
        
        switch channel.channelType {
        case .standard:
            avatarView.image = nil
            avatarView.placeholder = AmityIconSet.defaultGroupChat
        case .conversation:
            guard let fileURL = channel.getAvatarInfo()?.fileURL else { return }
            self.avatarView.setImage(withImageURL: fileURL, placeholder: AmityIconSet.defaultAvatar)
        default:
            break
        }
    }
}
