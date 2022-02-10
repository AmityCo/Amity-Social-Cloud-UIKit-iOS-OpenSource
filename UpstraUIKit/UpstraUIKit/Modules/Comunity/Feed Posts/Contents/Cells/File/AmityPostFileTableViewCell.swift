//
//  AmityPostFileTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/8/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public final class AmityPostFileTableViewCell: UITableViewCell, Nibbable, AmityPostProtocol {
    public weak var delegate: AmityPostDelegate?
    
    private enum Constant {
        static let ContentMaximumLine = 3
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var fileTableView: AmityFileTableView!
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    @IBOutlet private var contentLabel: AmityExpandableLabel!
    
    public private(set) var post: AmityPostModel?
    public private(set) var indexPath: IndexPath?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupFileTableView()
        setupContentLabel()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.isExpanded = false
        contentLabel.text = nil
    }
    
    public func display(post: AmityPostModel, indexPath: IndexPath) {
        self.post = post
        self.indexPath = indexPath
        fileTableView.configure(files: post.files)
        
        if let metadata = post.metadata, let mentionees = post.mentionees {
            let attributes = AmityMentionManager.getAttributes(fromText: post.text, withMetadata: metadata, mentionees: mentionees)
            contentLabel.setText(post.text, withAttributes: attributes)
        } else {
            contentLabel.text = post.text
        }
        contentLabel.isExpanded = post.appearance.shouldContentExpand
        fileTableView.isExpanded = post.appearance.shouldContentExpand
        heightConstraint.constant = AmityFileTableView.height(for: post.files.count, isEdtingMode: false, isExpanded: post.appearance.shouldContentExpand)
    }
    
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
    }
    
    private func setupFileTableView() {
        fileTableView.isExpanded = false
        fileTableView.actionDelegate = self
    }
    
    private func setupContentLabel() {
        contentLabel.font = AmityFontSet.body
        contentLabel.textColor = AmityColorSet.base
        contentLabel.shouldCollapse = false
        contentLabel.textReplacementType = .character
        contentLabel.numberOfLines = Constant.ContentMaximumLine
        contentLabel.isExpanded = false
        contentLabel.delegate = self
    }
    
    // MARK: - Perform Action
    private func performAction(action: AmityPostAction) {
        delegate?.didPerformAction(self, action: action)
    }
}

extension AmityPostFileTableViewCell: AmityFileTableViewDelegate {
    func fileTableView(_ view: AmityFileTableView, didTapAt index: Int) {
        guard 0..<fileTableView.files.count ~= index else { return }
        let file = fileTableView.files[index]
        performAction(action: .tapFile(file: file))
    }
    
    func fileTableViewDidDeleteData(_ view: AmityFileTableView, at index: Int) {
        // Do nothing
    }
    
    func fileTableViewDidUpdateData(_ view: AmityFileTableView) {
        // Do nothing
    }
    
    func fileTableViewDidTapViewAll(_ view: AmityFileTableView) {
        performAction(action: .tapViewAll)
    }
}

extension AmityPostFileTableViewCell: AmityExpandableLabelDelegate {
    
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
        performAction(action: .tapOnMentionWithUserId(userId: userId))
    }
}
