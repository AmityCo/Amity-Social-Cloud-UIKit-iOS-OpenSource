//
//  AmityPollCreatorTimeframeView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPollCreatorTimeframeView: AmityView {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var cancelButton: UIButton!
    @IBOutlet private var daysLabel: UILabel!
    
    // MARK: - Properties
    private var numDays: [Int] = []
    private var selecteditem: Int = 1
    var didSelectDayHandler: ((Int?) -> Void)?
    
    override func initial() {
        loadNibContent()
        prepareData()
        setupViews()
    }
    
    private func prepareData() {
        for item in 1...30 {
            numDays.append(item)
        }
    }
    
    // MARK: - Setup views
    func setupViews() {
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupContainerView()
        setupTitleLabel()
        setupPickerView()
        setupSaveButton()
        setupCancelButton()
        setupDaysLabel()
    }
    
    private func setupContainerView() {
        containerView.layer.cornerRadius = 8
    }
    
    private func setupTitleLabel() {
        titleLabel.text = AmityLocalizedStringSet.Poll.Create.chooseTimeFrameTitle.localizedString
        titleLabel.font = AmityFontSet.headerLine
        titleLabel.textColor = AmityColorSet.base
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupSaveButton() {
        saveButton.setTitle(AmityLocalizedStringSet.General.save.localizedString, for: .normal)
        saveButton.setTitleColor(AmityColorSet.baseInverse, for: .normal)
        saveButton.titleLabel?.font = AmityFontSet.bodyBold
        saveButton.backgroundColor = AmityColorSet.primary
        saveButton.layer.cornerRadius = 4
    }
    
    private func setupCancelButton() {
        cancelButton.setTitle(AmityLocalizedStringSet.General.cancel.localizedString, for: .normal)
        cancelButton.setTitleColor(AmityColorSet.primary, for: .normal)
        cancelButton.titleLabel?.font = AmityFontSet.body
        cancelButton.backgroundColor = UIColor.clear
    }
    
    private func setupDaysLabel() {
        daysLabel.font = AmityFontSet.title
        daysLabel.textColor = AmityColorSet.base
    }
    
    func selectRow(_ row: Int) {
        let row = row == 0 ? row : row - 1
        pickerView.selectRow(row, inComponent: 0, animated: false)
        updateDaysLabel(row)
        
    }
    
    private func updateDaysLabel(_ row: Int) {
        if row >= 1 {
            daysLabel.text = AmityLocalizedStringSet.General.days.localizedString
        } else {
            daysLabel.text = AmityLocalizedStringSet.General.day.localizedString
        }
    }
    
    // MARK: - Action
    @IBAction private func onTapSave()  {
        hide { [weak self] in
            self?.didSelectDayHandler?(self?.selecteditem)
        }
    }
    
    @IBAction private func onTapCancel() {
        hide()
    }
    
    func hide(_ completion: (() -> Void)? = nil) {
        removeFromSuperview()
        completion?()
    }
}

extension AmityPollCreatorTimeframeView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selecteditem = numDays[row]
        updateDaysLabel(row)
    }
    
}


extension AmityPollCreatorTimeframeView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numDays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numDays[row])"
    }
}
