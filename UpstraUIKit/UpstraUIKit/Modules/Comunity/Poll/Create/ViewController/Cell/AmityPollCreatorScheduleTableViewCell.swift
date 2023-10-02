//
//  AmityPollCreatorScheduleTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPollCreatorScheduleTableViewCell: UITableViewCell, Nibbable, AmityPollCreatorCellProtocol {

    weak var delegate: AmityPollCreatorCellProtocolDelegate?
    var indexPath: IndexPath?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var scheduleTitleLabel: UILabel!
    @IBOutlet private var scheduleDescriptionLabel: UILabel!
    @IBOutlet private var lineView: UIView!
    @IBOutlet private var placeholderLabel: UILabel!
    @IBOutlet private var dropdownImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        setupTitleLabel()
        setupDescriptionLabel()
        setupPlaceholderLabel()
    }
    
    func display(_ day: Int) {
        guard day != 0 else { return }
        if day > 1 {
            placeholderLabel.text = "\(day) " + AmityLocalizedStringSet.General.days.localizedString
        } else {
            placeholderLabel.text = "\(day) " + AmityLocalizedStringSet.General.day.localizedString
        }
        
        placeholderLabel.textColor = AmityColorSet.base
    }
    
    private func setupTitleLabel() {
        scheduleTitleLabel.text = AmityLocalizedStringSet.Poll.Create.scheduleTitle.localizedString
        scheduleTitleLabel.font = AmityFontSet.title
        scheduleTitleLabel.textColor = AmityColorSet.base
    }
    
    private func setupDescriptionLabel() {
        scheduleDescriptionLabel.text = AmityLocalizedStringSet.Poll.Create.scheduleDesc.localizedString
        scheduleDescriptionLabel.textColor = AmityColorSet.base.blend(.shade1)
        scheduleDescriptionLabel.font = AmityFontSet.caption
        scheduleDescriptionLabel.numberOfLines = 0
    }
    
    private func setupPlaceholderLabel() {
        placeholderLabel.text = AmityLocalizedStringSet.Poll.Create.chooseTimeFrameTitle.localizedString
        placeholderLabel.font = AmityFontSet.body
        placeholderLabel.textColor = AmityColorSet.base.blend(.shade3)
        
        dropdownImageView.image = AmityIconSet.iconDropdown
        
        lineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
    }

    // MARK: - Action
    @IBAction private func onTapChooseTimeFrame() {
        delegate?.didPerformAction(self, action: .selectSchedule)
    }
}
