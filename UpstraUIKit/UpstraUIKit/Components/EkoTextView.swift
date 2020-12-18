//
//  EkoTextView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 17/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

@objc protocol EkoTextViewDelegate {
    @objc optional func textViewShouldBeginEditing(_ textView: EkoTextView) -> Bool
    @objc optional func textViewShouldEndEditing(_ textView: EkoTextView) -> Bool
    @objc optional func textViewDidBeginEditing(_ textView: EkoTextView)
    @objc optional func textViewDidEndEditing(_ textView: EkoTextView)
    @objc optional func textView(_ textView: EkoTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    @objc optional func textViewDidChange(_ textView: EkoTextView)
    @objc optional func textViewDidChangeSelection(_ textView: EkoTextView)
    @objc optional func textView(_ textView: EkoTextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    @objc optional func textView(_ textView: EkoTextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

final class EkoTextView: UITextView {
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    override var bounds: CGRect {
        didSet {
            resizePlaceholder()
        }
    }
    /// The UITextView padding
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet {
            let left = padding.left == 0 ? padding.left - 3 : padding.left
            padding.left = left
            textContainerInset = padding
            resizePlaceholder()
            
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            placeholderLabel.sizeToFit()
        }
    }
    
    /// The UITextView placeholder text color
    public var placeholderColor: UIColor = UIColor.lightGray
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        let leftMargin = padding == .zero ? 0 : textContainer.lineFragmentPadding + padding.left
        let labelX = leftMargin
        let labelY = textContainerInset.top - 2
        let labelWidth = frame.width - (labelX * 2)
        let labelHeight = placeholderLabel.frame.height
        placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func setupPlaceholder() {
        placeholderLabel.sizeToFit()
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.isHidden = !text.isEmpty
        addSubview(placeholderLabel)
        resizePlaceholder()
        delegate = self
    }
    
    /// TextView Delegate
    weak var customTextViewDelegate : EkoTextViewDelegate?
    
    /// Check if text characters reach the minimum requirements.
    var isValid: Bool {
        // check if content is not blank
        guard !text.allSatisfy({ $0.isWhitespace }) else {
            return false
        }
        return text.count >= minCharacters
    }
    
    /// Maximum charactors. Default is 0, means not requires any characters.
    var maxCharacters: Int = 0
    
    /// Maximum charactors. Default is 0, means unlimited characters.
    var minCharacters: Int = 0
    
    // MARK: - Property
    
    private let placeholderLabel = UILabel()
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        textContainerInset = UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    private func commonInit() {
        delegate = self
        backgroundColor = EkoColorSet.backgroundColor
        textColor = EkoColorSet.base
        setupPlaceholder()
    }
    
    enum ValueType: Int {
        case none
        case onlyLetters
        case onlyNumbers
        case phoneNumber   // Allowed "+0123456789"
        case alphaNumeric
        case fullName       // Allowed letters and space
    }
    
    var maxLength: Int = 0 // Max character length
    var valueType: ValueType = ValueType.none // Allowed characters

    /************* Added new feature ***********************/
    // Accept only given character in string, this is case sensitive
    var allowedCharInString: String = ""

    func verifyFields(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch valueType {
        case .none:
            break // Do nothing
            
        case .onlyLetters:
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
            
        case .onlyNumbers:
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
            
        case .phoneNumber:
            let phoneNumberSet = CharacterSet(charactersIn: "+0123456789")
            if string.rangeOfCharacter(from: phoneNumberSet.inverted) != nil {
                return false
            }
            
        case .alphaNumeric:
            let alphaNumericSet = CharacterSet.alphanumerics
            if string.rangeOfCharacter(from: alphaNumericSet.inverted) != nil {
                return false
            }
            
        case .fullName:
            var characterSet = CharacterSet.letters
            print(characterSet)
            characterSet = characterSet.union(CharacterSet(charactersIn: " "))
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        }
        
        if let text = text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            if maxLength > 0, maxLength < finalText.utf16.count {
                return false
            }
        }

        // Check supported custom characters
        if !allowedCharInString.isEmpty {
            let customSet = CharacterSet(charactersIn: allowedCharInString)
            if string.rangeOfCharacter(from: customSet.inverted) != nil {
                return false
            }
        }
        
        return true
    }
}

extension EkoTextView: UITextViewDelegate {
    
    //MARK: - Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        customTextViewDelegate?.textViewDidBeginEditing?(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        customTextViewDelegate?.textViewDidEndEditing?(self)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return customTextViewDelegate?.textViewShouldBeginEditing?(self) ?? true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return customTextViewDelegate?.textViewShouldEndEditing?(self) ?? true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return customTextViewDelegate?.textView?(self, shouldChangeTextIn: range, replacementText: text) ?? (maxCharacters > 0 ? textView.text.count + (text.count - range.length) <= maxCharacters : true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !text.isEmpty
        customTextViewDelegate?.textViewDidChange?(self)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        customTextViewDelegate?.textViewDidChangeSelection?(self)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return customTextViewDelegate?.textView?(self, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return customTextViewDelegate?.textView?(self, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? false
    }
    
}
