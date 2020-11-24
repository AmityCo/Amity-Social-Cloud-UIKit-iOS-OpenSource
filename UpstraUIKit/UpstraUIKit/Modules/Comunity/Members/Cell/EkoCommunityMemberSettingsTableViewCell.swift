//
//  EkoCommunityMemberSettingsTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityMemberSettingsTableViewCell: UITableViewCell, Nibbable {

    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var optionButton: UIButton!
    
    // MARK: - Properties
    private var screenViewModel: EkoCommunityMemberScreenViewModelType!
    private var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func display(with model: EkoCommunityMembership) {
        let displayName = model.displayName == "" ? EkoLocalizedStringSet.anonymous : model.displayName
        displayNameLabel.text = displayName
    }
    
    func setViewModel(with viewModel: EkoCommunityMemberScreenViewModelType) {
        screenViewModel = viewModel
    }
    
    func setIndexPath(with _indexPath: IndexPath) {
        indexPath = _indexPath
    }
}

private extension EkoCommunityMemberSettingsTableViewCell {
    func setupView() {
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        setupAvatarView()
        setupDisplayName()
        setupOptionButton()
    }
    
    func setupAvatarView() {
        avatarView.backgroundColor = EkoColorSet.base.blend(.shade4)
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
    
    func setupDisplayName() {
        displayNameLabel.text = ""
        displayNameLabel.font = EkoFontSet.bodyBold
        displayNameLabel.textColor = EkoColorSet.base
    }
    
    func setupOptionButton() {
        optionButton.tintColor = EkoColorSet.base
    }
    
}

// MARK: - Action
private extension EkoCommunityMemberSettingsTableViewCell {
    @IBAction func optionTap() {
        screenViewModel.action.selectedItem(action: .option(indexPath: indexPath))
    }
}
