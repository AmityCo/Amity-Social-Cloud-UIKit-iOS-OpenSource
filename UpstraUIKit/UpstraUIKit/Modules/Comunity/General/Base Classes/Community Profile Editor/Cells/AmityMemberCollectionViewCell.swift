//
//  AmityMemberCollectionViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

class AmityMemberCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var containerAddView: UIView!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var addImageView: UIImageView!
    // MARK: - Properties
    var indexPath: IndexPath?
    
    // MARK: - Callback handler
    var deleteHandler: ((IndexPath) -> Void)?
    var addHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        displayNameLabel.text = ""
        numberLabel.isHidden = true
        containerAddView.isHidden = true
        avatarView.image = nil
        avatarView.placeholder = AmityIconSet.defaultAvatar
    }
    
    private func setupView() {
        containerView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        containerView.layer.cornerRadius = contentView.frame.height / 2
        
        setupAvatarView()
        setupDisplayNameLabel()
        setupDeleteButton()
        setupNumberLabel()
        setupContainerAddView()
    }
    
    private func setupAvatarView() {

    }
    
    
    private func setupDisplayNameLabel() {
        displayNameLabel.text = ""
        displayNameLabel.font = AmityFontSet.body
        displayNameLabel.textColor = AmityColorSet.base
    }
    
    private func setupDeleteButton() {
        deleteButton.addTarget(self, action: #selector(deleteTap), for: .touchUpInside)
        deleteButton.setImage(AmityIconSet.iconClose, for: .normal)
        deleteButton.tintColor = AmityColorSet.base.blend(.shade1)
    }
    
    private func setupNumberLabel() {
        numberLabel.text = ""
        numberLabel.font = AmityFontSet.body
        numberLabel.textColor = AmityColorSet.base
        numberLabel.textAlignment = .center
    }
    
    private func setupContainerAddView() {
        containerAddView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        containerAddView.layer.cornerRadius = containerAddView.frame.height / 2
        addButton.addTarget(self, action: #selector(addTap), for: .touchUpInside)
        addImageView.image = AmityIconSet.iconAdd
        addImageView.tintColor = AmityColorSet.base.blend(.shade1)
    }

    func display(with user: AmitySelectMemberModel) {
        displayNameLabel.text = user.displayName ?? user.defaultDisplayName
        avatarView.setImage(withImageURL: user.avatarURL, placeholder: AmityIconSet.defaultAvatar)
    }
    
    func showNumber(with number: Int) {
        numberLabel.text = "+\(number)"
        numberLabel.isHidden = false
        addImageView.isHidden = true
        containerAddView.isHidden = false
    }
    
    func hideNumber() {
        numberLabel.isHidden = true
        containerAddView.isHidden = true
    }
    
    func showUser() {
        containerView.isHidden = false
    }
    
    func hideUser() {
        containerView.isHidden = true
    }
    
    func showAddingView() {
        addImageView.isHidden = false
        numberLabel.isHidden = true
        containerAddView.isHidden = false
    }
    
    func hideAddingView() {
        addImageView.isHidden = true
        containerAddView.isHidden = true
    }
}

private extension AmityMemberCollectionViewCell {
    @objc func deleteTap(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        deleteHandler?(indexPath)
    }
    
    @objc func addTap() {
        addHandler?()
    }
}
