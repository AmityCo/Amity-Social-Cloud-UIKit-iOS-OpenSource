//
//  AmityPollCreatorQusetionTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPollCreatorQusetionTableViewCell: UITableViewCell, Nibbable, AmityPollCreatorCellProtocol {

    weak var delegate: AmityPollCreatorCellProtocolDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet private var pollTitleLabel: UILabel!
    @IBOutlet private var pollLenghtLabel: UILabel!
    @IBOutlet private var pollTextView: AmityTextView!
    @IBOutlet private var lineView: UIView!
    @IBOutlet private var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupTitleLabel()
        setupLenghtLabel()
        setupPollTextView()
        setupErrorLabel()
    }
    
    private func setupTitleLabel() {
        pollTitleLabel.text = AmityLocalizedStringSet.Poll.Create.questionTitle.localizedString
        pollTitleLabel.font = AmityFontSet.title
        pollTitleLabel.textColor = AmityColorSet.base
        pollTitleLabel.markAsMandatoryField()
    }
    
    private func setupLenghtLabel() {
        pollLenghtLabel.text = "0/\(AmityPollCreatorConstant.questionMax)"
        pollLenghtLabel.textColor = AmityColorSet.base.blend(.shade1)
        pollLenghtLabel.font = AmityFontSet.caption
    }
    
    private func setupPollTextView() {
        
        pollTextView.maxLength = AmityPollCreatorConstant.questionMax
        pollTextView.textColor = AmityColorSet.base
        pollTextView.font = AmityFontSet.body
        pollTextView.placeholder = AmityLocalizedStringSet.Poll.Create.questionPlaceholder.localizedString
        pollTextView.placeholderColor = AmityColorSet.base.blend(.shade3)
        pollTextView.customTextViewDelegate = self
        pollTextView.padding = .init(top: 8, left: 0, bottom: 8, right: 0)
        pollTextView.returnKeyType = .done
        pollTextView.customTextViewDelegate = self
        pollTextView.typingAttributes = [.font: AmityFontSet.body, .foregroundColor: AmityColorSet.base]
        
        lineView.backgroundColor = AmityColorSet.base.blend(.shade4)
    }
    
    private func setupErrorLabel() {
        let format = AmityLocalizedStringSet.General.textInputLimitCharactor.localizedString
        let value = AmityPollCreatorConstant.questionMax        
        errorLabel.text = String.localizedStringWithFormat(format, "\(value)")
        errorLabel.isHidden = true
        errorLabel.textColor = AmityColorSet.alert
        errorLabel.font = AmityFontSet.caption
    }

    func getTextView()-> UITextView? {
        return pollTextView
    }
}

extension AmityPollCreatorQusetionTableViewCell: AmityTextViewDelegate {
    
    func textViewDidChange(_ textView: AmityTextView) {
        let count = textView.text?.utf16.count ?? 0
        pollLenghtLabel.text = "\(count)/\(AmityPollCreatorConstant.questionMax)"
        errorLabel.isHidden = count != AmityPollCreatorConstant.questionMax
        lineView.backgroundColor = count != AmityPollCreatorConstant.questionMax ? AmityColorSet.base.blend(.shade4) : AmityColorSet.alert
        delegate?.didPerformAction(self, action: .textViewDidChange(textView: textView))
    }
    
    func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.returnKeyType == .done, text == "\n" {
            textView.resignFirstResponder()
        }
        if textView.verifyFields(shouldChangeCharactersIn: range, replacementString: text) {
            return delegate?.textView(textView, shouldChangeTextIn: range, replacementText: text) ?? true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: AmityTextView) {
        delegate?.didPerformAction(self, action: .textViewDidChangeSelection(textView: textView))
    }
}
