//
//  EkoTrendingCommunityTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 6/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoTrendingCommunityTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var metadataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        displayNameLabel.text = nil
        iconImageView.image = nil
        metadataLabel.text = nil
        numberLabel.text = nil
    }
    
    func display(with model: EkoCommunityModel) {
        avatarView.setImage(withImageId: model.avatarId, placeholder: EkoIconSet.defaultCommunity)
        displayNameLabel.text = model.displayName
        metadataLabel.text = String.localizedStringWithFormat(EkoLocalizedStringSet.trendingCommunityCategoryAndMember, model.category, model.membersCount.formatUsingAbbrevation())
        iconImageView.isHidden = !model.isOfficial
    }
    
    func displayNumber(with indexPath: IndexPath) {
        numberLabel.text = "\(indexPath.row + 1)"
    }
    
}

// MARK: - Setup View
private extension EkoTrendingCommunityTableViewCell {
    func setupView() {
        selectionStyle = .none
        setupAvatarView()
        setupNumber()
        setupDisplayName()
        setupMetadata()
    }
    
    func setupAvatarView() {
        avatarView.placeholder = EkoIconSet.defaultCommunity
        avatarView.backgroundColor = EkoColorSet.base.blend(.shade3)
    }
    
    func setupNumber() {
        numberLabel.text = ""
        numberLabel.textColor = EkoColorSet.highlight
        numberLabel.font = EkoFontSet.title
    }
    
    func setupDisplayName() {
        displayNameLabel.text = ""
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.font = EkoFontSet.title
        
        iconImageView.image = EkoIconSet.iconBadgeCheckmark
        iconImageView.isHidden = true
    }
    
    func setupMetadata() {
        metadataLabel.text = ""
        metadataLabel.textColor = EkoColorSet.base.blend(.shade1)
        metadataLabel.font = EkoFontSet.caption
    }
}
