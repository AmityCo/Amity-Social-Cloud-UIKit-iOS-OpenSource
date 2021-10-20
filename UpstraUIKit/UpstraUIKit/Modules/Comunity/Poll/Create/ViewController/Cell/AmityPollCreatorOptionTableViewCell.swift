//
//  AmityPollCreatorOptionTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPollCreatorOptionTableViewCell: UITableViewCell, Nibbable {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var answerTitleLabel: UILabel!
    @IBOutlet private var answerDescLabel: UILabel!
    @IBOutlet private var answerLenghtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupTitleLabel()
        setupLenghtLabel()
        setupDescriptionLabel()
    }
    
    func display(_ item: Int) {
        answerLenghtLabel.text = "\(item)/\(AmityPollCreatorConstant.optionMax)"
    }
    
    private func setupTitleLabel() {
        answerTitleLabel.text = AmityLocalizedStringSet.Poll.Create.answerTitle.localizedString
        answerTitleLabel.font = AmityFontSet.title
        answerTitleLabel.textColor = AmityColorSet.base
        answerTitleLabel.markAsMandatoryField()
    }
    
    private func setupLenghtLabel() {
        answerLenghtLabel.text = "0/\(AmityPollCreatorConstant.optionMax)"
        answerLenghtLabel.textColor = AmityColorSet.base.blend(.shade1)
        answerLenghtLabel.font = AmityFontSet.caption
    }
    
    private func setupDescriptionLabel() {
        answerDescLabel.text = AmityLocalizedStringSet.Poll.Create.answerDesc.localizedString
        answerDescLabel.textColor = AmityColorSet.base.blend(.shade1)
        answerDescLabel.font = AmityFontSet.caption
    }

}
