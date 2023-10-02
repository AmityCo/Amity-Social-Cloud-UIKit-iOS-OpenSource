//
//  AmityPollCreatorAddOptionTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPollCreatorAddOptionTableViewCell: UITableViewCell, Nibbable, AmityPollCreatorCellProtocol {

    weak var delegate: AmityPollCreatorCellProtocolDelegate?
    var indexPath: IndexPath?

    // MARK: - IBOutlet Properties
    @IBOutlet private var addAnswerOptionButton: UIButton!
    @IBOutlet private var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupAddButton()
    }
    
    private func setupAddButton() {
        addAnswerOptionButton.setTitle(AmityLocalizedStringSet.Poll.Create.answerButton.localizedString, for: .normal)
        addAnswerOptionButton.layer.cornerRadius = 4
        addAnswerOptionButton.layer.borderWidth = 1
        addAnswerOptionButton.layer.borderColor = AmityColorSet.base.blend(.shade3).cgColor
        addAnswerOptionButton.backgroundColor = UIColor.white
        addAnswerOptionButton.setTitleColor(AmityColorSet.base, for: .normal)
        addAnswerOptionButton.titleLabel?.font = AmityFontSet.bodyBold
        addAnswerOptionButton.setImage(AmityIconSet.iconPollOptionAdd, for: .normal)
        addAnswerOptionButton.tintColor = AmityColorSet.base
        
        lineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
    }
    
    // MARK: - Action
    @IBAction private func onAddAnswerOption() {
        delegate?.didPerformAction(self, action: .addAnswerOption)
    }
    
}
