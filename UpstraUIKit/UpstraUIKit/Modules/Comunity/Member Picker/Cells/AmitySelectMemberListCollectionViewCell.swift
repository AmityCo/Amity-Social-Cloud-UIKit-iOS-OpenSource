//
//  AmitySelectMemberCollectionViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

final class AmitySelectMemberListCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var deleteImageView: UIImageView!
    
    // MARK: - Properties
    var indexPath: IndexPath?
    
    // MARK: - Callback handler
    var deleteHandler: ((IndexPath) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        displayNameLabel.text = ""
        avatarView.image = nil
        avatarView.placeholder = AmityIconSet.defaultAvatar
    }
    
    private func setupView() {
        avatarView.avatarShape = .circle
        avatarView.placeholder = AmityIconSet.defaultAvatar
        
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerView.backgroundColor = AmityColorSet.secondary.withAlphaComponent(0.5)
        
        deleteButton.addTarget(self, action: #selector(deleteTap(_:)), for: .touchUpInside)
        
        deleteImageView.image = AmityIconSet.iconClose
        deleteImageView.tintColor = UIColor.white
        
        displayNameLabel.text = ""
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.font = AmityFontSet.caption
    }

    func display(with user: AmitySelectMemberModel) {
        displayNameLabel.text = user.displayName ?? user.defaultDisplayName
        avatarView.setImage(withImageURL: user.avatarURL, placeholder: AmityIconSet.defaultAvatar)
    }
    
}

private extension AmitySelectMemberListCollectionViewCell {
    @objc func deleteTap(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        deleteHandler?(indexPath)
    }
}
