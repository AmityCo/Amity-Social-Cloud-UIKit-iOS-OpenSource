//
//  AmityPollCreatorAnswerTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPollCreatorAnswerTableViewCell: UITableViewCell, Nibbable, AmityPollCreatorCellProtocol {
    
    weak var delegate: AmityPollCreatorCellProtocolDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet private var answerTextView: AmityTextView!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupAnswerTextView()
        setupErrorLabel()
        setupDeleteButton()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteButton.isHidden = true
        answerTextView.text = ""
    }
    
    func display(answer: String) {
        answerTextView.text = answer
        deleteButton.isHidden = answerTextView.text == ""
    }
    
    func moveInputCursorToTextView() {
        answerTextView.becomeFirstResponder()
    }
    
    private func setupAnswerTextView() {
        answerTextView.maxLength = AmityPollCreatorConstant.answerMax
        answerTextView.textColor = AmityColorSet.base
        answerTextView.font = AmityFontSet.body
        answerTextView.placeholder = AmityLocalizedStringSet.Poll.Create.answerPlaceholder.localizedString
        answerTextView.placeholderColor = AmityColorSet.base.blend(.shade3)
        answerTextView.customTextViewDelegate = self
        answerTextView.padding = .init(top: 16, left: 8, bottom: 16, right: 16 + 16 + 20)
        answerTextView.returnKeyType = .done
        answerTextView.customTextViewDelegate = self
        answerTextView.layer.cornerRadius = 4
        answerTextView.backgroundColor = AmityColorSet.base.blend(.shade4)
    }
    
    private func setupErrorLabel() {
        let format = AmityLocalizedStringSet.General.textInputLimitCharactor.localizedString
        let value = AmityPollCreatorConstant.answerMax
        errorLabel.text = String.localizedStringWithFormat(format, "\(value)")
        errorLabel.isHidden = true
        errorLabel.textColor = AmityColorSet.alert
        errorLabel.font = AmityFontSet.caption
    }
    
    private func setupDeleteButton() {
        deleteButton.isHidden = true
        deleteButton.setImage(AmityIconSet.iconCloseWithBackground, for: .normal)
        deleteButton.tintColor = AmityColorSet.base.blend(.shade2)
    }

    // MARK: - Action
    @IBAction private func onDelete()  {
        delegate?.didPerformAction(self, action: .deleteAnswerOption)
    }
}

extension AmityPollCreatorAnswerTableViewCell: AmityTextViewDelegate {
    
    func textViewDidChange(_ textView: AmityTextView) {
        let count = textView.text?.utf16.count ?? 0
        errorLabel.isHidden = count != AmityPollCreatorConstant.answerMax
        answerTextView.layer.borderColor = count != AmityPollCreatorConstant.answerMax ? AmityColorSet.base.blend(.shade4).cgColor : AmityColorSet.alert.cgColor
        answerTextView.layer.borderWidth = 1
        deleteButton.isHidden = answerTextView.text == ""
        delegate?.didPerformAction(self, action: .textViewDidChange(textView: textView))
    }
    
    func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.returnKeyType == .done, text == "\n" {
            textView.resignFirstResponder()
            delegate?.didPerformAction(self, action: .updateAnswerOption(text: textView.text))
        }
        return textView.verifyFields(shouldChangeCharactersIn: range, replacementString: text)
    }
}
 
