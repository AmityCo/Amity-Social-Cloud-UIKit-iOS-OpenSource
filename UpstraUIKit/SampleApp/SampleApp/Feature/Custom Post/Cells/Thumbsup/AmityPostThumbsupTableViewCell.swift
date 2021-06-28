//
//  AmityPostThumbsupTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/4/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmityUIKit

private struct AmityThumbsupModel {
    
    let type: String
    let text: String
    let senderId: String
    let receiverDisplayName: String
    
    init(post: AmityPostModel) {
        type = post.data["type"] as? String ?? ""
        text = post.data["text"] as? String ?? ""
        senderId = post.data["senderId"] as? String ?? ""
        receiverDisplayName = post.postedUser?.displayName ?? ""
    }
    
}

final class AmityPostThumbsupTableViewCell: UITableViewCell {

    private enum Constant {
        static let DISPLAY_NAME_MAXIMUM_LINE = 3
        static let CONTENT_MAXIMUM_LINE = 8
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var senderAvatarView: AmityAvatarView!
    @IBOutlet private var senderDisplayNameLabel: UILabel!
    @IBOutlet private var receiverAvatarView: AmityAvatarView!
    @IBOutlet private var receiverDisplayNameLabel: UILabel!
    @IBOutlet private var contentLabel: AmityExpandableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func display(withPost post: AmityPostModel) {
        let thumbsup = AmityThumbsupModel(post: post)
        titleLabel.text = thumbsup.type
        contentLabel.text = thumbsup.text
        
        receiverDisplayNameLabel.text = thumbsup.receiverDisplayName
    }
     
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .white
        setupTitleLabel()
        setupSender()
        setupReceiver()
        setupPost()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Extraordinary!"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
    }
    
    private func setupSender() {
        
        // Avatar
        senderAvatarView.avatarShape = .circle
        senderAvatarView.placeholder = AmityIconSet.defaultAvatar
        senderAvatarView.actionHandler = { [weak self] in
            self?.avatarSenderTap()
        }
        
        // Label
        #warning("temporary text")
        senderDisplayNameLabel.text = "HubertBlaineWolfe­schlegel­stein­hausen­berger­doasdasdasadsadsa"
        senderDisplayNameLabel.textAlignment = .center
        
        senderDisplayNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        senderDisplayNameLabel.textColor = .white
        senderDisplayNameLabel.numberOfLines = Constant.DISPLAY_NAME_MAXIMUM_LINE
    }
    
    private func setupReceiver() {
        // Avatar
        receiverAvatarView.avatarShape = .circle
        receiverAvatarView.placeholder = AmityIconSet.defaultAvatar
        receiverAvatarView.actionHandler = { [weak self] in
            self?.avatarReceiverTap()
        }
        
        // Label
        #warning("temporary text")
        receiverDisplayNameLabel.text = "HubertBlaineWolfe­schlegel­stein­hausen­berger­doasdasdasadsadsa"
        receiverDisplayNameLabel.textAlignment = .center
        receiverDisplayNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        receiverDisplayNameLabel.textColor = .white
        receiverDisplayNameLabel.numberOfLines = Constant.DISPLAY_NAME_MAXIMUM_LINE
    }
    
    private func setupPost() {
        #warning("temporary text")
        contentLabel.text = "Thanks a lot for giving me regular feedback during the last 2 months. It's been very valuable for me to understand where are my growth areas. You're the manager that can deliver such constructive, yet candid feedback"
        contentLabel.numberOfLines = Constant.CONTENT_MAXIMUM_LINE
        contentLabel.font = .systemFont(ofSize: 15, weight: .regular)
        contentLabel.textColor = UIColor(hex: "292B32")
        contentLabel.setLineSpacing(8)
        contentLabel.shouldCollapse = false
        contentLabel.textReplacementType = .character
        contentLabel.isExpanded = false
    }
    
}

private extension AmityPostThumbsupTableViewCell {
    func avatarSenderTap() {
        // tap on avatar
    }
    
    func avatarReceiverTap() {
        // tap on avatar
    }
}
