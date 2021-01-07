//
//  EkoSelectMemberCollectionViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoSelectMemberListCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: EkoAvatarView!
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
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
    
    private func setupView() {
        avatarView.avatarShape = .circle
        avatarView.placeholder = EkoIconSet.defaultAvatar
        
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerView.backgroundColor = EkoColorSet.secondary.withAlphaComponent(0.5)
        
        deleteButton.addTarget(self, action: #selector(deleteTap(_:)), for: .touchUpInside)
        
        deleteImageView.image = EkoIconSet.iconClose
        deleteImageView.tintColor = UIColor.white
        
        displayNameLabel.text = ""
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.font = EkoFontSet.caption
    }

    func display(with user: EkoSelectMemberModel) {
        displayNameLabel.text = user.displayName ?? user.defaultDisplayName
        avatarView.setImage(withImageId: user.avatarId, placeholder: EkoIconSet.defaultAvatar)
    }
    
}

private extension EkoSelectMemberListCollectionViewCell {
    @objc func deleteTap(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        deleteHandler?(indexPath)
    }
}
