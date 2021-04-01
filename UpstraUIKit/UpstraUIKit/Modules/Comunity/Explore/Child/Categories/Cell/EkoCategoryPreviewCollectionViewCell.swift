//
//  EkoCategoryPreviewCollectionViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 6/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCategoryPreviewCollectionViewCellDelegate: class {
    func cellDidTapOnAvatar(_ cell: EkoCategoryPreviewCollectionViewCell)
}

class EkoCategoryPreviewCollectionViewCell: UICollectionViewCell, Nibbable {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var categoryNameLabel: UILabel!
    
    weak var delegate: EkoCategoryPreviewCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func display(with model: EkoCommunityCategoryModel) {
        avatarView.setImage(withImageId: model.avatarFileId, placeholder: EkoIconSet.defaultCategory)
        categoryNameLabel.text = model.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
    }
}

// MARK: - Setup view
private extension EkoCategoryPreviewCollectionViewCell {
    func setupView() {
        setupAvatarView()
        setupCategoryName()
    }
    
    func setupAvatarView() {
        avatarView.placeholder = EkoIconSet.defaultCategory
        avatarView.backgroundColor = EkoColorSet.secondary.blend(.shade3)
        
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    func setupCategoryName() {
        categoryNameLabel.text = ""
        categoryNameLabel.textColor = EkoColorSet.base
        categoryNameLabel.font = EkoFontSet.bodyBold
    }
}

// MARK:- Actions
private extension EkoCategoryPreviewCollectionViewCell {
    func avatarTap() {
        delegate?.cellDidTapOnAvatar(self)
    }
}
