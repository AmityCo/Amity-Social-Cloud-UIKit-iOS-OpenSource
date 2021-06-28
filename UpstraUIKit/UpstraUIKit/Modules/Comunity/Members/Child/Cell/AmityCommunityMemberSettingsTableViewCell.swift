//
//  AmityCommunityMemberSettingsTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityMemberSettingsTableViewCellDelegate: class {
    func didPerformAction(at indexPath: IndexPath, action: AmityCommunityMemberAction)
}

public enum AmityCommunityMemberAction {
    case tapAvatar
    case tapDisplayName
    case tapOption
}

final class AmityCommunityMemberSettingsTableViewCell: UITableViewCell, Nibbable {

    // MARK: - Delegate
    weak var delegate: AmityCommunityMemberSettingsTableViewCellDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var optionButton: UIButton!
    
    // MARK: - Properties
    
    private var indexPath: IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func display(with model: AmityCommunityMembershipModel, isJoined: Bool) {
        let displayName = model.displayName
        displayNameLabel.text = displayName
        optionButton.isHidden = model.isCurrentUser || !isJoined
    }
    
    func setIndexPath(with _indexPath: IndexPath) {
        indexPath = _indexPath
    }
}

private extension AmityCommunityMemberSettingsTableViewCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        setupAvatarView()
        setupDisplayName()
        setupOptionButton()
    }
    
    func setupAvatarView() {
        avatarView.placeholder = AmityIconSet.defaultAvatar
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    func setupDisplayName() {
        displayNameLabel.text = ""
        displayNameLabel.font = AmityFontSet.bodyBold
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayNameTap(_:)))
        displayNameLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupOptionButton() {
        optionButton.tintColor = AmityColorSet.base
    }
    
}

// MARK: - Action
private extension AmityCommunityMemberSettingsTableViewCell {
    @IBAction func optionTap() {
        delegate?.didPerformAction(at: indexPath, action: .tapOption)
    }
    
    @objc func displayNameTap(_ sender: UIGestureRecognizer) {
        delegate?.didPerformAction(at: indexPath, action: .tapDisplayName)
    }
    
    func avatarTap() {
        delegate?.didPerformAction(at: indexPath, action: .tapAvatar)
    }
}
