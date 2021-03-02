//
//  EkoPostHeaderTableViewCell.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/5/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

/// `EkoPostHeaderTableViewCell` for providing a header of `Post`
public final class EkoPostHeaderTableViewCell: UITableViewCell, Nibbable, EkoPostHeaderProtocol {
    public weak var delegate: EkoPostHeaderDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: EkoFeedDisplayNameLabel!
    @IBOutlet private var badgeStackView: UIStackView!
    @IBOutlet private var badgeIconImageView: UIImageView!
    @IBOutlet private var badgeLabel: UILabel!
    @IBOutlet private var datetimeLabel: UILabel!
    @IBOutlet private var optionButton: UIButton!
    
    private(set) public var post: EkoPostModel?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
    
    public func display(post: EkoPostModel, shouldShowOption: Bool) {
        self.post = post
        avatarView.setImage(withImageId: post.avatarId, placeholder: EkoIconSet.defaultAvatar)
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }

        displayNameLabel.configure(displayName: post.displayName, communityName: post.communityDisplayName)
        displayNameLabel.delegate = self
        datetimeLabel.text = post.subtitle
        optionButton.isHidden = !(shouldShowOption && post.isCommentable)

        if post.isModerator {
            badgeStackView.isHidden = post.postAsModerator
        } else {
            badgeStackView.isHidden = true
        }
    }

    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = EkoColorSet.backgroundColor
        displayNameLabel.configure(displayName: "Annonymous", communityName: "None")
        
        // badge
        badgeLabel.text = EkoLocalizedStringSet.moderator.localizedString + " • "
        badgeLabel.font = EkoFontSet.captionBold
        badgeLabel.textColor = EkoColorSet.base.blend(.shade1)
        badgeIconImageView.image = EkoIconSet.iconBadgeModerator
        
        // date time
        datetimeLabel.font = EkoFontSet.caption
        datetimeLabel.textColor = EkoColorSet.base.blend(.shade1)
        datetimeLabel.text = "45 mins"
        
        // option
        optionButton.tintColor = EkoColorSet.base
        optionButton.setImage(EkoIconSet.iconOption, for: .normal)
    }
    
    // MARK: - Perform Action
    private func performAction(action: EkoPostHeaderAction) {
        delegate?.didPerformAction(self, action: action)
    }
    
}

// MARK: - Action
private extension EkoPostHeaderTableViewCell {
    
    func avatarTap() {
        performAction(action: .tapAvatar)
    }
    
    @IBAction func optionTap() {
        performAction(action: .tapOption)
    }
}

extension EkoPostHeaderTableViewCell: EkoFeedDisplayNameLabelDelegate {
    func labelDidTapUserDisplayName(_ label: EkoFeedDisplayNameLabel) {
        performAction(action: .tapDisplayName)
    }
    
    func labelDidTapCommunityName(_ label: EkoFeedDisplayNameLabel) {
        performAction(action: .tapCommunityName)
    }
}
