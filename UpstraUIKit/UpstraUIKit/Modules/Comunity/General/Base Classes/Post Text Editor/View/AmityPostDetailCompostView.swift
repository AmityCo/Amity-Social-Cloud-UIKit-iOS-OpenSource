//
//  AmityPostDetailCompostView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 14/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import AmitySDK
import UIKit

protocol AmityPostDetailCompostViewDelegate: AnyObject {
    func composeView(_ view: AmityPostDetailCompostView, didPostText text: String)
    func composeViewDidTapExpand(_ view: AmityPostDetailCompostView)
    func composeViewDidTapReplyDismiss(_ view: AmityPostDetailCompostView)
    func composeView(_ view: AmityPostDetailCompostView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    func composeViewDidChangeSelection(_ view: AmityPostDetailCompostView)
}

class AmityPostDetailCompostView: UIView {
    
    weak var delegate: AmityPostDetailCompostViewDelegate?
    var text: String {
        return textView.text ?? ""
    }
    
    var replyingUsername: String? {
        didSet {
            if let _replyingUsername = replyingUsername {
                replyLabel.text = String.localizedStringWithFormat(AmityLocalizedStringSet.PostDetail.replyingTo.localizedString, _replyingUsername)
                replyContainerView.isHidden = false
            } else {
                replyContainerView.isHidden = true
            }
        }
    }
    
    private let stackView = UIStackView(frame: .zero)
    private let replyLabel = UILabel(frame: .zero)
    private let dismissButton = UIButton(frame: .zero)
    private let avatarView = AmityAvatarView(frame: .zero)
    let textView = AmityTextView(frame: .zero)
    private let postButton = UIButton(frame: .zero)
    private let expandButton = UIButton(frame: .zero)
    private let replyContainerView = UIView(frame: .zero)
    private let separtorLineView = UIView(frame: .zero)
    private let textContainerView = UIView(frame: .zero)
    
    private enum Constant {
        static let defaultTextViewHeight: CGFloat = 40.0
        static let maxTextViewHeight: CGFloat = 120.0
        static let textViewTopPadding: CGFloat = 10.0
        static let textViewBottomPadding: CGFloat = 10.0
        static let textViewLeftPadding: CGFloat = 8.0
        static let textViewRightPadding: CGFloat = 40.0
    }
    
    private var resizingRequires: Bool = false
    
    private var isOversized = false {
        didSet {
            guard oldValue != isOversized else {
                return
            }
            textView.isScrollEnabled = isOversized
            textView.setNeedsUpdateConstraints()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if resizingRequires {
            isOversized = textView.contentSize.height >= Constant.maxTextViewHeight
            resizingRequires = false
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
        super.becomeFirstResponder()
        return textView.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textView.resignFirstResponder()
    }
    
    func resetState() {
        textView.text = ""
        textView.attributedText = nil
        textView.textColor = AmityColorSet.base
        postButton.isEnabled = false
        isOversized = false
        textView.resignFirstResponder()
    }
    
    func configure(with post: AmityPostModel) {
        avatarView.setImage(withImageURL: AmityUIKitManagerInternal.shared.client.currentUser?.object?.getAvatarInfo()?.fileURL,
                            placeholder: AmityIconSet.defaultAvatar)
        isHidden = !post.isCommentable
        textContainerView.isHidden = !post.isCommentable
    }
    
    private func commonInit() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        addSubview(stackView)
        
        // Reply view
        replyLabel.translatesAutoresizingMaskIntoConstraints = false
        replyLabel.textColor = AmityColorSet.base.blend(.shade1)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(AmityIconSet.iconClose, for: .normal)
        dismissButton.tintColor = AmityColorSet.base.blend(.shade2)
        dismissButton.addTarget(self, action: #selector(dismissButtonTap), for: .touchUpInside)
        replyContainerView.isHidden = true
        replyContainerView.addSubview(replyLabel)
        replyContainerView.addSubview(dismissButton)
        replyContainerView.backgroundColor = AmityColorSet.base.blend(.shade4)
        stackView.addArrangedSubview(replyContainerView)
        
        // Separater view
        separtorLineView.translatesAutoresizingMaskIntoConstraints = false
        separtorLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        stackView.addArrangedSubview(separtorLineView)
        
        // Text composer view
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 14.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        textView.isScrollEnabled = false
        textView.padding = UIEdgeInsets(top: Constant.textViewTopPadding,
                                        left: Constant.textViewLeftPadding,
                                        bottom: Constant.textViewBottomPadding,
                                        right: Constant.textViewRightPadding)
        textView.layer.cornerRadius = Constant.defaultTextViewHeight / 2
        textView.clipsToBounds = true
        textView.placeholder = AmityLocalizedStringSet.PostDetail.textPlaceholder.localizedString
        textView.customTextViewDelegate = self
        textView.font = AmityFontSet.body
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.setTitle(AmityLocalizedStringSet.General.post.localizedString, for: .normal)
        postButton.setTitleColor(AmityColorSet.primary, for: .normal)
        postButton.setTitleColor(AmityColorSet.primary.blend(.shade2), for: .disabled)
        postButton.addTarget(self, action: #selector(postButtonTap), for: .touchUpInside)
        postButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        postButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        postButton.isEnabled = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.setImage(AmityIconSet.iconExpand, for: .normal)
        expandButton.tintColor = AmityColorSet.base.blend(.shade3)
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
            
            replyContainerView.heightAnchor.constraint(equalToConstant: Constant.defaultTextViewHeight),
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

extension AmityPostDetailCompostView: AmityTextViewDelegate {
    
    func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return delegate?.composeView(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textViewDidChange(_ textView: AmityTextView) {
        postButton.isEnabled = !text.isEmpty
        
        let height = textView.text.height(withConstrainedWidth: textView.contentSize.width, font: textView.font ?? AmityFontSet.body)
        let verticalPadding = Constant.textViewTopPadding + Constant.textViewBottomPadding
        if textView.contentSize.height - height < verticalPadding {
            // invalid height because of pasting a very long text.
            // re-calculate a height and mark resizing as required.
            textView.frame = CGRect(origin: textView.frame.origin, size: CGSize(width: textView.frame.width, height: height))
            resizingRequires = true
        } else {
            isOversized = textView.contentSize.height >= Constant.maxTextViewHeight
        }
    }
    
    func textViewDidChangeSelection(_ textView: AmityTextView) {
        delegate?.composeViewDidChangeSelection(self)
    }
}
