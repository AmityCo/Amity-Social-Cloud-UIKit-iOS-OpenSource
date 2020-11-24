//
//  EkoTextComposeBarView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 6/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

extension EkoTextComposeBarView: UIKeyInput {
    var hasText: Bool { return false }
    func insertText(_ text: String) { }
    func deleteBackward() { }
}
/// TextView Compose Bar
class EkoTextComposeBarView: EkoView {
    
    // MARK: - UIInputView Implement
    var _inputView: UIView?
    override var canBecomeFirstResponder: Bool { return true }
    override var canResignFirstResponder: Bool { return true }
    override var inputView: UIView? {
        set { _inputView = newValue }
        get { return _inputView }
    }
    
    
    // MARK: - IBOutlet Properties
    @IBOutlet var textView: EkoTextView!
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var textViewDidChanged: ((String) -> Void)?
    var textViewShouldBeginEditing: ((EkoTextView) -> Void)?
    var maxHeight: CGFloat = 120

    private var defaultHeightTextView: CGFloat = 0
    
    /// Text
    var text: String? {
        get {
            return textView.text
        } set {
            textView.text = newValue
        }
    }
    
    /// Placeholder
    var placeholder: String? {
        didSet {
            textView.placeholder = placeholder
        }
    }
    
    /// Font
    var font: UIFont? {
        didSet {
            textView.font = font
        }
    }
    
    /// TextColor
    var textColor: UIColor? {
        didSet {
            textView.textColor = textColor
        }
    }
    
    /// Placeholder color
    var placeholderColor: UIColor = UIColor.gray {
        didSet {
            textView.placeholderColor = placeholderColor
        }
    }
    
    override func initial() {
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 4
        textView.customTextViewDelegate = self
        
        defaultHeightTextView = textView.frame.height
    }
    
    /// Set height of textView to default
    private func setHeightToDefault() {
        heightConstraint.constant = defaultHeightTextView
    }
    
    func clearText() {
        text = ""
        setHeightToDefault()
    }
}

extension EkoTextComposeBarView: EkoTextViewDelegate {
    
    func textView(_ textView: EkoTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else { return false }
        guard !(((currentText == "") && (text == " ")) || ((currentText == "") && (text == "\n"))) else {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: EkoTextView) {
        if !(textView.contentSize.height >= maxHeight) {
            heightConstraint.constant = textView.contentSize.height
        } else {
            heightConstraint.constant = maxHeight
        }
        
        guard let text = textView.text else { return }
        
        textViewDidChanged?(text)
    }

    func textViewShouldBeginEditing(_ textView: EkoTextView) -> Bool {
        textViewShouldBeginEditing?(textView)
        return true
    }
}
