//
//  EkoRecentChatTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import EkoChat

final class EkoRecentChatTableViewCell: UITableViewCell, Nibbable {
    
    @IBOutlet private var containerDisplayNameView: UIView!
    @IBOutlet private var containerMessageView: UIView!
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var statusImageView: UIImageView!
    @IBOutlet private var memberLabel: UILabel!
    @IBOutlet private var badgeView: EkoBadgeView!
    @IBOutlet private var previewMessageLabel: UILabel!
    @IBOutlet private var dateTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        titleLabel.text = ""
//        previewMessageLabel.text = ""
//        dateTimeLabel.text = ""
//        badgeView.badge = 0
    }
    
    private func setupView() {
        containerDisplayNameView.backgroundColor = EkoColorSet.backgroundColor
        containerMessageView.backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        selectionStyle = .none
        
        iconImageView.isHidden = true
        statusImageView.isHidden = true
        
        titleLabel.font = EkoFontSet.title
        titleLabel.textColor = EkoColorSet.base
        memberLabel.font = EkoFontSet.caption
        memberLabel.textColor = EkoColorSet.base.blend(.shade1)
        
        previewMessageLabel.text = "No message yet\nNo message yet"
        previewMessageLabel.numberOfLines = 2
        previewMessageLabel.font = EkoFontSet.body
        previewMessageLabel.textColor = EkoColorSet.base.blend(.shade2)
        previewMessageLabel.alpha = 0
        
        dateTimeLabel.font = EkoFontSet.caption
        dateTimeLabel.textColor = EkoColorSet.base.blend(.shade2)
        
    }
    
    func display(with channel: EkoChannelModel) {
        titleLabel.text = channel.channelId
        badgeView.badge = channel.unreadCount
        dateTimeLabel.text = EkoDateFormatter.Chat.getDate(date: channel.lastActivity)
        switch channel.channelType {
        case .standard:
            avatarView.placeholder = EkoIconSet.defaultGroupChat//channel.avatar == nil ? EkoIconSet.default_chat_group : UIImage()
            memberLabel.text = "(\(channel.memberCount))"
        case .conversation:
            avatarView.placeholder = EkoIconSet.defaultAvatar//channel.avatar == nil ? EkoIconSet.default_chat_direct : UIImage()
            memberLabel.text = nil
            titleLabel.text = channel.displayName ?? EkoLocalizedStringSet.anonymous
        case .private:
            break
        case .broadcast:
            break
        case .byTypes:
            break
        @unknown default:
            break
        }
    }
}
