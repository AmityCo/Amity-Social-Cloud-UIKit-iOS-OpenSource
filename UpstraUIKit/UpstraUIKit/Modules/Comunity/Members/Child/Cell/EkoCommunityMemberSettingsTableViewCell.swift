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
    func didPerformAction(at indexPath: IndexPath, action: EkoCommunityMemberAction)
}

public enum EkoCommunityMemberAction {
    case tapAvatar
    case tapDisplayName
    case tapOption
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
    
    func display(with model: EkoCommunityMembershipModel, isJoined: Bool) {
        let displayName = model.displayName
        displayNameLabel.text = displayName
        optionButton.isHidden = model.isCurrentUser || !isJoined
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
        avatarView.placeholder = EkoIconSet.defaultAvatar
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    func setupDisplayName() {
        displayNameLabel.text = ""
        displayNameLabel.font = EkoFontSet.bodyBold
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayNameTap(_:)))
        displayNameLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupOptionButton() {
        optionButton.tintColor = EkoColorSet.base
    }
    
}

// MARK: - Action
private extension EkoCommunityMemberSettingsTableViewCell {
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
