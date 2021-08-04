//
//  AmityFollowRequestTableViewCell.swift
//  AmityUIKit
//
//  Created by Hamlet on 17.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityFollowRequestAction {
    case tapAvatar
    case tapDisplayName
    case tapAccept
    case tapDecline
}

protocol AmityFollowRequestTableViewCellDelegate: AnyObject {
    func didPerformAction(at indexPath: IndexPath, action: AmityFollowRequestAction)
}

class AmityFollowRequestTableViewCell: UITableViewCell, Nibbable {

    // MARK: - Delegate
    weak var delegate: AmityFollowRequestTableViewCellDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak private var topSeparateView: UIView!
    @IBOutlet weak private var avatarView: AmityAvatarView!
    @IBOutlet weak private var displayNameLabel: UILabel!
    @IBOutlet weak private var middleSeoarateView: UIView!
    @IBOutlet weak private var acceptButton: UIButton!
    @IBOutlet weak private var declineButton: UIButton!
    @IBOutlet weak private var bottomSeparateView: UIView!
    
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
    }
    
    func display(with model: AmityFollowRelationship) {
        guard let amityUser = model.sourceUser else { return }
        
        displayNameLabel.text = amityUser.displayName
        let user = AmityUserModel(user: amityUser)
        avatarView.setImage(withImageURL: user.avatarURL, placeholder: AmityIconSet.defaultAvatar)
    }
    
    func setIndexPath(with _indexPath: IndexPath) {
        indexPath = _indexPath
    }
}

private extension AmityFollowRequestTableViewCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        
        setupAvatarView()
        setupDisplayName()
        setupButtons()
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
    
    func setupButtons() {
        acceptButton.layer.cornerRadius = 4
        acceptButton.setBackgroundColor(color: AmityColorSet.primary, forState: .normal)
        acceptButton.titleLabel?.font = AmityFontSet.bodyBold
        acceptButton.tintColor = AmityColorSet.secondary
        acceptButton.setTitle(AmityLocalizedStringSet.Follow.accept.localizedString, for: .normal)
        
        declineButton.layer.cornerRadius = 4
        declineButton.titleLabel?.font = AmityFontSet.bodyBold
        declineButton.tintColor = AmityColorSet.secondary
        declineButton.layer.borderColor = AmityColorSet.base.blend(.shade3).cgColor
        declineButton.layer.borderWidth = 1
        declineButton.setTitle(AmityLocalizedStringSet.Follow.decline.localizedString, for: .normal)
    }
}

// MARK: - Action
private extension AmityFollowRequestTableViewCell {
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        delegate?.didPerformAction(at: indexPath, action: .tapAccept)
    }
    
    @IBAction func declineButtonAction(_ sender: UIButton) {
        delegate?.didPerformAction(at: indexPath, action: .tapDecline)
    }
    
    @objc func displayNameTap(_ sender: UIGestureRecognizer) {
        delegate?.didPerformAction(at: indexPath, action: .tapDisplayName)
    }
    
    func avatarTap() {
        delegate?.didPerformAction(at: indexPath, action: .tapAvatar)
    }
}
