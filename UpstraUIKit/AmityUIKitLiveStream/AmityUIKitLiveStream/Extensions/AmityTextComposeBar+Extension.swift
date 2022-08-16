//
//  AmityTextComposeBar+Extension.swift
//  AmityUIKitLiveStream
//
//  Created by Mono TheForestcat on 13/8/2565 BE.
//

import Foundation
import UIKit
import AmityUIKit

/// The protocol help to matching uiview class and xib file as the same name
protocol NibFileOwnerLoadable: UIView {
    var contentView: UIView! { get set }
}

extension NibFileOwnerLoadable {
    
    /// Returns a `UIView` object instantiated from
    /// - Returns: `UIView`
    func instantiateFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
    /// * Load the content of the first view in the XIB.
    /// * Then add this as subview with constraints
    func loadNibContent() {
        guard let view = instantiateFromNib() else {
            fatalError("Failed to instantiate \(String(describing: Self.self)).xib")
        }
        contentView = view
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}

class AmityLiveStreamView: UIView, NibFileOwnerLoadable {
    public var contentView: UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initial()
    }
    
    func initial() { }
}

extension AmityTextComposeBarView: UIKeyInput {
    var hasText: Bool { return false }
    func insertText(_ text: String) { }
    func deleteBackward() { }
}

/// TextView Compose Bar
class AmityTextComposeBarView: AmityLiveStreamView {
    
    // MARK: - UIInputView Implement
    var _inputView: UIView?
    override var canBecomeFirstResponder: Bool { return true }
    override var canResignFirstResponder: Bool { return true }
    override var inputView: UIView? {
        set { _inputView = newValue }
        get { return _inputView }
    }
    
    
    // MARK: - IBOutlet Properties
    @IBOutlet var textView: AmityTextView!
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var textViewDidChanged: ((String) -> Void)?
    var textViewShouldBeginEditing: ((AmityTextView) -> Void)?
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
        contentView.backgroundColor = AmityColorSet.backgroundColor
        textView.backgroundColor = AmityColorSet.backgroundColor
        textView.layer.borderWidth = 1
        textView.layer.borderColor = AmityColorSet.secondary.blend(.shade4).cgColor
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
//        textView.resignFirstResponder()
    }
}

extension AmityTextComposeBarView: AmityTextViewDelegate {
    
    func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else { return false }
        guard !(((currentText == "") && (text == " ")) || ((currentText == "") && (text == "\n"))) else {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: AmityTextView) {
        if !(textView.contentSize.height >= maxHeight) {
            heightConstraint.constant = textView.contentSize.height
        } else {
            heightConstraint.constant = maxHeight
        }
        
        guard let text = textView.text else { return }
        
        textViewDidChanged?(text)
    }

    func textViewShouldBeginEditing(_ textView: AmityTextView) -> Bool {
        textViewShouldBeginEditing?(textView)
        return true
    }
}
