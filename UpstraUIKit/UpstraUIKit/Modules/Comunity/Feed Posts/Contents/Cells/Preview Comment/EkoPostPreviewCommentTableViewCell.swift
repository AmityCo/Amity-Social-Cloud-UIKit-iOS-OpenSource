//
//  EkoPostPreviewCommentTableViewCell.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/9/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

public final class EkoPostPreviewCommentTableViewCell: UITableViewCell, Nibbable, EkoPostPreviewCommentProtocol {
    
    public weak var delegate: EkoPostPreviewCommentDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var commentView: EkoCommentView!
    @IBOutlet private var separatorView: UIView!
    
    // MARK: - Properties
    public private(set) var post: EkoPostModel?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public func display(post: EkoPostModel, comment: EkoCommentModel?) {
        guard let comment = comment else { return }
        self.post = post
        let shouldActionShow = post.isCommentable
        commentView.configure(with: comment, layout: .commentPreview(shouldActionShow: shouldActionShow))
        commentView.delegate = self
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        separatorView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        commentView.backgroundColor = EkoColorSet.backgroundColor
    }
    
    // MARK: - Perform Action
    
    func performAction(action: EkoPostPreviewCommentAction) {
        delegate?.didPerformAction(self, action: action)
    }
    
}

// MARK: EkoExpandableLabelDelegate
extension EkoPostPreviewCommentTableViewCell: EkoExpandableLabelDelegate {
    public func willExpandLabel(_ label: EkoExpandableLabel) {
        performAction(action: .willExpandExpandableLabel(label: label))
    }
    
    public func didExpandLabel(_ label: EkoExpandableLabel) {
        performAction(action: .didExpandExpandableLabel(label: label))
    }
    
    public func willCollapseLabel(_ label: EkoExpandableLabel) {
        performAction(action: .willCollapseExpandableLabel(label: label))
    }
    
    public func didCollapseLabel(_ label: EkoExpandableLabel) {
        performAction(action: .didCollapseExpandableLabel(label: label))
    }
    
    public func expandableLabeldidTap(_ label: EkoExpandableLabel) {
        performAction(action: .tapExpandableLabel(label: label))
    }
}

// MARK: EkoCommentViewDelegate
extension EkoPostPreviewCommentTableViewCell: EkoCommentViewDelegate {
    
    func commentView(_ view: EkoCommentView, didTapAction action: EkoCommentViewAction) {
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
