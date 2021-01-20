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
}

class EkoPostDetailCompostView: UIView {
    
    weak var delegate: EkoPostDetailCompostViewDelegate?
    var text: String {
        return textView.text ?? ""
    }
    
    private let separtorLineView = UIView(frame: .zero)
    private let avatarView = EkoAvatarView(frame: .zero)
    private let textView = EkoTextView(frame: .zero)
    private let postButton = UIButton(frame: .zero)
    private let expandButton = UIButton(frame: .zero)
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    private enum Constant {
        static let defaultTextViewHeight: CGFloat = 40.0
        static let maxTextViewHeight: CGFloat = 120.0
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
        updateTextViewConstraint()
    }
    
    func configure(with post: EkoPostModel) {
        avatarView.placeholder = EkoIconSet.defaultAvatar
        if !post.isCommentable {
            textViewHeightConstraint.constant = 0
            isHidden = true
        }
    }
    
    private func commonInit() {
        separtorLineView.translatesAutoresizingMaskIntoConstraints = false
        separtorLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 14.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
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
        addSubview(separtorLineView)
        addSubview(avatarView)
        addSubview(textView)
        addSubview(postButton)
        addSubview(expandButton)
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: Constant.defaultTextViewHeight)
        NSLayoutConstraint.activate([
            separtorLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separtorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separtorLineView.topAnchor.constraint(equalTo: topAnchor),
            separtorLineView.heightAnchor.constraint(equalToConstant: 1.0),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0),
            avatarView.widthAnchor.constraint(equalToConstant: 28.0),
            avatarView.heightAnchor.constraint(equalToConstant: 28.0),
            textView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8.0),
            textView.trailingAnchor.constraint(equalTo: postButton.leadingAnchor, constant: -12.0),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            textViewHeightConstraint,
            postButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            postButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0),
            expandButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8.0),
            expandButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -8.0),
            expandButton.heightAnchor.constraint(equalToConstant: 24.0),
            expandButton.widthAnchor.constraint(equalToConstant: 24.0),
        ])
    }
    
    private func updateTextViewConstraint() {
        let height = textView.contentSize.height
        if height < Constant.defaultTextViewHeight {
            textViewHeightConstraint.constant = Constant.defaultTextViewHeight
        } else if height > Constant.maxTextViewHeight {
            textViewHeightConstraint.constant = Constant.maxTextViewHeight
        } else {
            textViewHeightConstraint.constant = height
        }
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
        updateTextViewConstraint()
    }
    
}
