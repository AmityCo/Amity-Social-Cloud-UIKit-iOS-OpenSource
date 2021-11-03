//
//  AmityPollCreatorMultipleSelectionTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPollCreatorMultipleSelectionTableViewCell: UITableViewCell, Nibbable, AmityPollCreatorCellProtocol {

    weak var delegate: AmityPollCreatorCellProtocolDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet private var multipleSelectionTitleLabel: UILabel!
    @IBOutlet private var multipleSelectionDescriptionLabel: UILabel!
    @IBOutlet private var multipleSelectionSwitch: UISwitch!
    @IBOutlet private var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupTitleLabel()
        setupDescriptionLabel()
        setupSwitch()
    }
    
    private func setupTitleLabel() {
        multipleSelectionTitleLabel.text = AmityLocalizedStringSet.Poll.Create.multipleSelectionTitle.localizedString
        multipleSelectionTitleLabel.font = AmityFontSet.title
        multipleSelectionTitleLabel.textColor = AmityColorSet.base
    }
    
    private func setupDescriptionLabel() {
        multipleSelectionDescriptionLabel.text = AmityLocalizedStringSet.Poll.Create.multipleSelectionDesc.localizedString
        multipleSelectionDescriptionLabel.textColor = AmityColorSet.base.blend(.shade1)
        multipleSelectionDescriptionLabel.font = AmityFontSet.caption
        multipleSelectionDescriptionLabel.numberOfLines = 0
    }
    
    private func setupSwitch() {
        multipleSelectionSwitch.setOn(false, animated: false)
        multipleSelectionSwitch.onTintColor = AmityColorSet.primary
        multipleSelectionSwitch.tintColor = AmityColorSet.base.blend(.shade3)
        multipleSelectionSwitch.backgroundColor = AmityColorSet.base.blend(.shade3)
        multipleSelectionSwitch.layer.cornerRadius = multipleSelectionSwitch.frame.height / 2
        
        lineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
    }
    
    // MARK: - Action
    @IBAction private func onTapMultipleSelection(_ sender: UISwitch) {
        delegate?.didPerformAction(self, action: .multipleSelectionChange(isMultiple: sender.isOn))
    }
}
