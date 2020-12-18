//
//  EkoCommunityMemberSettingsTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityMemberSettingsTableViewCellDelegate: class {
    func cellDidActionOption(at indexPath: IndexPath)
}

final class EkoCommunityMemberSettingsTableViewCell: UITableViewCell, Nibbable {

    // MARK: - Delegate
    weak var delegate: EkoCommunityMemberSettingsTableViewCellDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var optionButton: UIButton!
    
    // MARK: - Properties
    
    private var indexPath: IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func display(with model: EkoCommunityMembershipModel, community: EkoCommunityModel) {
        let displayName = model.displayName
        displayNameLabel.text = displayName
        optionButton.isHidden = model.isCurrentUser || !community.isJoined
    }
    
    func setIndexPath(with _indexPath: IndexPath) {
        indexPath = _indexPath
    }
}

private extension EkoCommunityMemberSettingsTableViewCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        setupAvatarView()
        setupDisplayName()
        setupOptionButton()
    }
    
    func setupAvatarView() {
        avatarView.backgroundColor = EkoColorSet.base.blend(.shade4)
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
    
    func setupDisplayName() {
        displayNameLabel.text = ""
        displayNameLabel.font = EkoFontSet.bodyBold
        displayNameLabel.textColor = EkoColorSet.base
    }
    
    func setupOptionButton() {
        optionButton.tintColor = EkoColorSet.base
    }
    
}

// MARK: - Action
private extension EkoCommunityMemberSettingsTableViewCell {
    @IBAction func optionTap() {
        delegate?.cellDidActionOption(at: indexPath)
    }
}
