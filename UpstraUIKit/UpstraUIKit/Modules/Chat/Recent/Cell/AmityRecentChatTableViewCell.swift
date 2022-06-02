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
    private var participateToken: AmityNotificationToken?
    private var repository: AmityUserRepository?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        previewMessageLabel.text = AmityLocalizedStringSet.RecentMessage.noMessage.localizedString
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
        previewMessageLabel.isHidden = true
        
        titleLabel.font = AmityFontSet.title
        titleLabel.textColor = AmityColorSet.base
        memberLabel.font = AmityFontSet.caption
        memberLabel.textColor = AmityColorSet.base.blend(.shade1)
        
        previewMessageLabel.text = AmityLocalizedStringSet.RecentMessage.noMessage.localizedString
        previewMessageLabel.numberOfLines = 2
        previewMessageLabel.font = AmityFontSet.body
        previewMessageLabel.textColor = AmityColorSet.base.blend(.shade2)
        previewMessageLabel.alpha = 1
        
        dateTimeLabel.font = AmityFontSet.caption
        dateTimeLabel.textColor = AmityColorSet.base.blend(.shade2)
        
    }
    
    func display(with channel: AmityChannelModel) {
        badgeView.badge = channel.unreadCount
        memberLabel.text = ""
        dateTimeLabel.text = AmityDateFormatter.Chat.getDate(date: channel.lastActivity)
        titleLabel.text = channel.displayName
        avatarView.placeholder = AmityIconSet.defaultAvatar
        previewMessageLabel.text = channel.recentMessage
        
        switch channel.channelType {
        case .standard:
            avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultGroupChat)
            memberLabel.text = "(\(channel.memberCount))"
        case .conversation:
            memberLabel.text = nil
            
            if let userIndex = RecentChatAvatarArray.shared.avatarArray.firstIndex(where: {$0.channelId == channel.channelId }) {
                let currentArray = RecentChatAvatarArray.shared.avatarArray[userIndex]
                titleLabel.text = (currentArray.displayName != "") ? currentArray.displayName : channel.displayName
                if currentArray.isCustom {
                    avatarView.setImage(withCustomURL: currentArray.avatarURL,
                                             placeholder: AmityIconSet.defaultAvatar)
                } else {
                    avatarView.setImage(withImageURL: currentArray.avatarURL,
                                             placeholder: AmityIconSet.defaultAvatar)
                }
            } else {
                participateToken?.invalidate()
                participateToken = channel.participation.getMembers(filter: .all, sortBy: .firstCreated, roles: []).observe { collection, change, error in
                    for i in 0..<collection.count(){
                        let userId = collection.object(at: i)?.userId
                        if userId != AmityUIKitManagerInternal.shared.currentUserId {
                            self.token = self.repository?.getUser(userId ?? "").observe { [weak self] user, error in
                                self?.token?.invalidate()
                                guard let userObject = user.object else { return }
                                self?.titleLabel.text = userObject.displayName
                                let userModel = AmityUserModel(user: userObject)
                                if !userModel.avatarCustomURL.isEmpty {
                                    self?.avatarView.setImage(withCustomURL: userModel.avatarCustomURL,
                                                             placeholder: AmityIconSet.defaultAvatar)
                                    RecentChatAvatarArray.shared.avatarArray.append(RecentChatAvatar(channelId: channel.channelId, avatarURL: userModel.avatarCustomURL, displayName: userModel.displayName, isCustom: true))
                                } else {
                                    self?.avatarView.setImage(withImageURL: userModel.avatarURL,
                                                              placeholder: AmityIconSet.defaultAvatar)
                                    RecentChatAvatarArray.shared.avatarArray.append(RecentChatAvatar(channelId: channel.channelId, avatarURL: userModel.avatarURL, displayName: userModel.displayName, isCustom: false))
                                }
                            }
                        }
                    }
                }
            }
            
        case .community:
            token?.invalidate()
            if !channel.getOtherUserId().isEmpty {
                token = repository?.getUser(channel.getOtherUserId()).observeOnce { [weak self] user, error in
                    guard let userObject = user.object else { return }
                    self?.titleLabel.text = userObject.displayName
                    let userModel = AmityUserModel(user: userObject)
                    if !userModel.avatarCustomURL.isEmpty {
                        self?.avatarView.setImage(withCustomURL: userModel.avatarCustomURL,
                                                 placeholder: AmityIconSet.defaultAvatar)
                    } else {
                        self?.avatarView.setImage(withImageURL: userModel.avatarURL,
                                                  placeholder: AmityIconSet.defaultAvatar)
                    }
                }
            }
        case .private, .live, .broadcast, .unknown:
            break
        @unknown default:
            break
        }
        
        
    }
}
