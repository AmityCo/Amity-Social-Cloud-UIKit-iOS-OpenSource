//
//  EkoPostDetailCompostView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 14/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import EkoChat
import UIKit

protocol EkoPostDetailCompostViewDelegate: class {
    func composeView(_ view: EkoPostDetailCompostView, didPostText text: String)
    func composeViewDidTapExpand(_ view: EkoPostDetailCompostView)
    func composeViewDidTapReplyDismiss(_ view: EkoPostDetailCompostView)
}

class EkoPostDetailCompostView: UIView {
    
    weak var delegate: EkoPostDetailCompostViewDelegate?
    var text: String {
        return textView.text ?? ""
    }
    
    var replyingUsername: String? {
        didSet {
            if let _replyingUsername = replyingUsername {
                replyLabel.text = String.localizedStringWithFormat(EkoLocalizedStringSet.PostDetail.replyingTo.localizedString, _replyingUsername)
                replyContainerView.isHidden = false
            } else {
                replyContainerView.isHidden = true
            }
        }
    }
    
    private let stackView = UIStackView(frame: .zero)
    private let replyLabel = UILabel(frame: .zero)
    private let dismissButton = UIButton(frame: .zero)
    private let avatarView = EkoAvatarView(frame: .zero)
    private let textView = EkoTextView(frame: .zero)
    private let postButton = UIButton(frame: .zero)
    private let expandButton = UIButton(frame: .zero)
    private let replyContainerView = UIView(frame: .zero)
    private let separtorLineView = UIView(frame: .zero)
    private let textContainerView = UIView(frame: .zero)
    
    private enum Constant {
        static let defaultTextViewHeight: CGFloat = 40.0
        static let maxTextViewHeight: CGFloat = 120.0
    }
    
    private var isOversized = false {
        didSet {
            guard oldValue != isOversized else {
                return
            }
            textView.isScrollEnabled = isOversized
            textView.setNeedsUpdateConstraints()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    func resetState() {
        textView.text = ""
        postButton.isEnabled = false
    }
    
    func configure(with post: EkoPostModel) {
        avatarView.placeholder = EkoIconSet.defaultAvatar
        if !post.isCommentable {
            isHidden = true
        }
    }
    
    private func commonInit() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        addSubview(stackView)
        
        // Reply view
        replyLabel.translatesAutoresizingMaskIntoConstraints = false
        replyLabel.textColor = EkoColorSet.base.blend(.shade1)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(EkoIconSet.iconClose, for: .normal)
        dismissButton.tintColor = EkoColorSet.base.blend(.shade2)
        dismissButton.addTarget(self, action: #selector(dismissButtonTap), for: .touchUpInside)
        replyContainerView.isHidden = true
        replyContainerView.addSubview(replyLabel)
        replyContainerView.addSubview(dismissButton)
        replyContainerView.backgroundColor = EkoColorSet.base.blend(.shade4)
        stackView.addArrangedSubview(replyContainerView)
        
        // Separater view
        separtorLineView.translatesAutoresizingMaskIntoConstraints = false
        separtorLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        stackView.addArrangedSubview(separtorLineView)
        
        // Text composer view
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 14.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        textView.isScrollEnabled = false
        textView.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 40)
        textView.placeholder = EkoLocalizedStringSet.PostDetail.textPlaceholder.localizedString
        textView.customTextViewDelegate = self
        textView.font = EkoFontSet.body
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.setTitle(EkoLocalizedStringSet.post.localizedString, for: .normal)
        postButton.setTitleColor(EkoColorSet.primary, for: .normal)
        postButton.setTitleColor(EkoColorSet.primary.blend(.shade2), for: .disabled)
        postButton.addTarget(self, action: #selector(postButtonTap), for: .touchUpInside)
        postButton.isEnabled = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.setImage(EkoIconSet.iconExpand, for: .normal)
        expandButton.tintColor = EkoColorSet.base.blend(.shade3)
        expandButton.addTarget(self, action: #selector(expandButtonTap), for: .touchUpInside)
        textContainerView.addSubview(textView)
        textContainerView.addSubview(postButton)
        textContainerView.addSubview(expandButton)
        textContainerView.addSubview(avatarView)
        stackView.addArrangedSubview(textContainerView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            replyContainerView.heightAnchor.constraint(equalToConstant: 40.0),
            replyLabel.centerYAnchor.constraint(equalTo: replyContainerView.centerYAnchor),
            replyLabel.leadingAnchor.constraint(equalTo: replyContainerView.leadingAnchor, constant: 16.0),
            replyLabel.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: -8.0),
            dismissButton.centerYAnchor.constraint(equalTo: replyContainerView.centerYAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: replyContainerView.trailingAnchor, constant: -16.0),
            dismissButton.widthAnchor.constraint(equalToConstant: 16.0),
            dismissButton.heightAnchor.constraint(equalToConstant: 16.0),
            
            separtorLineView.heightAnchor.constraint(equalToConstant: 1.0),
            avatarView.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor, constant: 16.0),
            avatarView.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: -12.0),
            avatarView.widthAnchor.constraint(equalToConstant: 28.0),
            avatarView.heightAnchor.constraint(equalToConstant: 28.0),
            textView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8.0),
            textView.trailingAnchor.constraint(equalTo: postButton.leadingAnchor, constant: -12.0),
            textView.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: -8.0),
            textView.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: 8.0),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constant.defaultTextViewHeight),
            textView.heightAnchor.constraint(lessThanOrEqualToConstant: Constant.maxTextViewHeight),
            postButton.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: -16.0),
            postButton.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: -12.0),
            expandButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8.0),
            expandButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -8.0),
            expandButton.heightAnchor.constraint(equalToConstant: 24.0),
            expandButton.widthAnchor.constraint(equalToConstant: 24.0),
        ])
    }
    
    @objc private func dismissButtonTap() {
        delegate?.composeViewDidTapReplyDismiss(self)
    }
    
    @objc private func postButtonTap() {
        delegate?.composeView(self, didPostText: textView.text ?? "")
    }
    
    @objc private func expandButtonTap() {
        delegate?.composeViewDidTapExpand(self)
    }
    
}

extension EkoPostDetailCompostView: EkoTextViewDelegate {
    
    func textView(_ textView: EkoTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else { return false }
        if currentText.isEmpty {
            return !text.allSatisfy({ $0.isNewline || $0.isWhitespace })
        }
        return true
    }
    
    func textViewDidChange(_ textView: EkoTextView) {
        postButton.isEnabled = !text.isEmpty
        isOversized = textView.contentSize.height >= Constant.maxTextViewHeight
    }
    
}
