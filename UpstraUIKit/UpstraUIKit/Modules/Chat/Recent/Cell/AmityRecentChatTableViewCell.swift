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
        titleLabel.text = channel.channelId
        badgeView.badge = channel.unreadCount
        dateTimeLabel.text = AmityDateFormatter.Chat.getDate(date: channel.lastActivity)
        switch channel.channelType {
        case .standard:
            avatarView.placeholder = AmityIconSet.defaultGroupChat//channel.avatar == nil ? AmityIconSet.default_chat_group : UIImage()
            memberLabel.text = "(\(channel.memberCount))"
        case .conversation:
            avatarView.placeholder = AmityIconSet.defaultAvatar//channel.avatar == nil ? AmityIconSet.default_chat_direct : UIImage()
            memberLabel.text = nil
            titleLabel.text = channel.displayName
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
