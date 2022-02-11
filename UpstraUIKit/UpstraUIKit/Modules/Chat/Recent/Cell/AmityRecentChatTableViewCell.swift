//
//  AmityRecentChatTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityRecentChatTableViewCell: UITableViewCell, Nibbable {
    
    @IBOutlet private var containerDisplayNameView: UIView!
    @IBOutlet private var containerMessageView: UIView!
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var statusImageView: UIImageView!
    @IBOutlet private var memberLabel: UILabel!
    @IBOutlet private var badgeView: AmityBadgeView!
    @IBOutlet private var previewMessageLabel: UILabel!
    @IBOutlet private var dateTimeLabel: UILabel!
    
    private var token: AmityNotificationToken?
    private var repository: AmityUserRepository?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        previewMessageLabel.text = ""
        dateTimeLabel.text = ""
        badgeView.badge = 0
        avatarView.image = nil
    }
    
    private func setupView() {
        repository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        
        containerDisplayNameView.backgroundColor = AmityColorSet.backgroundColor
        containerMessageView.backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        selectionStyle = .none
        
        iconImageView.isHidden = true
        statusImageView.isHidden = true
        
        titleLabel.font = AmityFontSet.title
        titleLabel.textColor = AmityColorSet.base
        memberLabel.font = AmityFontSet.caption
        memberLabel.textColor = AmityColorSet.base.blend(.shade1)
        
        previewMessageLabel.text = "No message yet\nNo message yet"
        previewMessageLabel.numberOfLines = 2
        previewMessageLabel.font = AmityFontSet.body
        previewMessageLabel.textColor = AmityColorSet.base.blend(.shade2)
        previewMessageLabel.alpha = 0
        
        dateTimeLabel.font = AmityFontSet.caption
        dateTimeLabel.textColor = AmityColorSet.base.blend(.shade2)
        
    }
    
    func display(with channel: AmityChannelModel) {
        badgeView.badge = channel.unreadCount
        memberLabel.text = ""
        dateTimeLabel.text = AmityDateFormatter.Chat.getDate(date: channel.lastActivity)
        titleLabel.text = AmityLocalizedStringSet.General.anonymous.localizedString
        avatarView.placeholder = AmityIconSet.defaultAvatar
        
        if channel.isDirectChat() {
            token?.invalidate()
            if !channel.getOtherUserId().isEmpty {
                token = repository?.getUser(channel.getOtherUserId()).observe({ [weak self] user, error in
                    guard let weakSelf = self else { return }
                    if let userObject = user.object {
                        weakSelf.titleLabel.text = userObject.displayName
                        weakSelf.avatarView.setImage(withImageURL: userObject.avatarCustomUrl,
                                                     placeholder: AmityIconSet.defaultAvatar)
                        weakSelf.token?.invalidate()
                    }

                })
            }
        } else {
            titleLabel.text = channel.displayName
            switch channel.channelType {
            case .standard:
                avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultGroupChat)
                memberLabel.text = "(\(channel.memberCount))"
            case .conversation:
                avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultAvatar)
                memberLabel.text = nil
                titleLabel.text = channel.displayName
            case .private:
                break
            case .broadcast:
                break
            case .unknown:
                break
            case .community:
                avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultGroupChat)
                memberLabel.text = "(\(channel.memberCount))"
            @unknown default:
                break
            }
        }
    }
}
