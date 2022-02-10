//
//  AmityFollowerTableViewCell.swift
//  AmityUIKit
//
//  Created by Hamlet on 10.06.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityFollowerTableViewCellDelegate: AnyObject {
    func didPerformAction(at indexPath: IndexPath, action: AmityFollowerAction)
}

enum AmityFollowerAction {
    case tapAvatar
    case tapDisplayName
    case tapOption
}

final class AmityFollowerTableViewCell: UITableViewCell, Nibbable {

    // MARK: - Delegate
    weak var delegate: AmityFollowerTableViewCellDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var optionButton: UIButton!
    @IBOutlet private var bannedImageView: UIImageView!
    @IBOutlet private var bannedImageViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        displayNameLabel.text = ""
        avatarView.placeholder = AmityIconSet.defaultAvatar
        avatarView.image = nil
        bannedImageViewWidthConstraint.constant = 0
        bannedImageView.image = nil
        bannedImageView.isHidden = true
    }
    
    func display(with model: AmityUserModel) {
        displayNameLabel.text = model.displayName
        optionButton.isHidden = model.isCurrentUser
        avatarView.setImage(withImageURL: model.avatarURL, placeholder: AmityIconSet.defaultAvatar)
        
        if model.isGlobalBan {
            bannedImageView.isHidden = false
            bannedImageViewWidthConstraint.constant = 16
            bannedImageView.image = AmityIconSet.CommunitySettings.iconCommunitySettingBanned
        }
    }
    
    func setIndexPath(with _indexPath: IndexPath) {
        indexPath = _indexPath
    }
}

private extension AmityFollowerTableViewCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        setupAvatarView()
        setupDisplayName()
        setupOptionButton()
    }
    
    func setupAvatarView() {
        avatarView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
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
private extension AmityFollowerTableViewCell {
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
