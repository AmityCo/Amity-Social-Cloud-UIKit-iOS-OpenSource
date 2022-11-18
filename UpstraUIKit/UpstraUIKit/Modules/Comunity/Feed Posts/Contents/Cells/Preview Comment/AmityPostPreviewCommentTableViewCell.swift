//
//  AmityPostPreviewCommentTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/9/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

public final class AmityPostPreviewCommentTableViewCell: UITableViewCell, Nibbable, AmityPostPreviewCommentProtocol {
    
    public weak var delegate: AmityPostPreviewCommentDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var commentView: AmityCommentView!
    @IBOutlet private var separatorView: UIView!
    
    // MARK: - Properties
    public private(set) var post: AmityPostModel?
    public private(set) var comment: AmityCommentModel?
    public private(set) var isExpanded: Bool = false
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public func display(post: AmityPostModel, comment: AmityCommentModel?) {
        self.comment = comment
        self.post = post
        guard let comment = comment else { return }
        let layout = AmityCommentView.Layout(
            type: .commentPreview,
            isExpanded: isExpanded,
            shouldActionShow: post.isCommentable,
            shouldLineShow: false
        )
        commentView.configure(with: comment, layout: layout)
        commentView.delegate = self
        commentView.contentLabel.delegate = self
    }
    
    func setIsExpanded(_ isExpanded: Bool) {
        self.isExpanded = isExpanded
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        separatorView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        commentView.backgroundColor = AmityColorSet.backgroundColor
    }
    
    // MARK: - Perform Action
    
    func performAction(action: AmityPostPreviewCommentAction) {
        delegate?.didPerformAction(self, action: action)
    }
    
}

// MARK: AmityExpandableLabelDelegate
extension AmityPostPreviewCommentTableViewCell: AmityExpandableLabelDelegate {
    public func willExpandLabel(_ label: AmityExpandableLabel) {
        performAction(action: .willExpandExpandableLabel(label: label))
    }
    
    public func didExpandLabel(_ label: AmityExpandableLabel) {
        performAction(action: .didExpandExpandableLabel(label: label))
    }
    
    public func willCollapseLabel(_ label: AmityExpandableLabel) {
        performAction(action: .willCollapseExpandableLabel(label: label))
    }
    
    public func didCollapseLabel(_ label: AmityExpandableLabel) {
        performAction(action: .didCollapseExpandableLabel(label: label))
    }
    
    public func expandableLabeldidTap(_ label: AmityExpandableLabel) {
        performAction(action: .tapExpandableLabel(label: label))
    }
    
    public func didTapOnMention(_ label: AmityExpandableLabel, withUserId userId: String) {
        performAction(action: .tapOnMention(userId: userId))
    }
}

// MARK: AmityCommentViewDelegate
extension AmityPostPreviewCommentTableViewCell: AmityCommentViewDelegate {
    
    func commentView(_ view: AmityCommentView, didTapAction action: AmityCommentViewAction) {
        guard let comment = view.comment else { return }
        switch action {
        case .avatar:
            performAction(action: .tapAvatar(comment: comment))
        case .like:
            performAction(action: .tapLike(comment: comment))
        case .option:
            performAction(action: .tapOption(comment: comment))
        case .reply, .viewReply:
            performAction(action: .tapReply(comment: comment))
        }
    }
    
}
