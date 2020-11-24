//
//  EkoMemberCollectionViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

class EkoMemberCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: EkoAvatarView!
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
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
    
    private func setupView() {
        containerView.backgroundColor = EkoColorSet.base.blend(.shade4)
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
        displayNameLabel.font = EkoFontSet.body
        displayNameLabel.textColor = EkoColorSet.base
    }
    
    private func setupDeleteButton() {
        deleteButton.addTarget(self, action: #selector(deleteTap), for: .touchUpInside)
        deleteButton.setImage(EkoIconSet.iconClose, for: .normal)
        deleteButton.tintColor = EkoColorSet.base.blend(.shade1)
    }
    
    private func setupNumberLabel() {
        numberLabel.text = ""
        numberLabel.font = EkoFontSet.body
        numberLabel.textColor = EkoColorSet.base
        numberLabel.textAlignment = .center
    }
    
    private func setupContainerAddView() {
        containerAddView.backgroundColor = EkoColorSet.base.blend(.shade4)
        containerAddView.layer.cornerRadius = containerAddView.frame.height / 2
        addButton.addTarget(self, action: #selector(addTap), for: .touchUpInside)
        addImageView.image = EkoIconSet.iconAdd
        addImageView.tintColor = EkoColorSet.base.blend(.shade1)
    }

    func display(with user: EkoSelectMemberModel) {
        displayNameLabel.text = user.displayName ?? user.defaultDisplayName
        avatarView.setImage(withImageId: user.avatarId, placeholder: EkoIconSet.defaultAvatar)
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

private extension EkoMemberCollectionViewCell {
    @objc func deleteTap(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        deleteHandler?(indexPath)
    }
    
    @objc func addTap() {
        addHandler?()
    }
}
