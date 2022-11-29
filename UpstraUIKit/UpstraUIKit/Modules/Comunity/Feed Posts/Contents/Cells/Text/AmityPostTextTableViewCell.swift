//
//  AmityPostTextTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/8/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public final class AmityPostTextTableViewCell: UITableViewCell, Nibbable, AmityPostProtocol {
    
    public weak var delegate: AmityPostDelegate?
    
    private enum Constant {
        static let ContentMaximumLine = 8
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var contentLabel: AmityExpandableLabel!
    
    // MARK: - Properties
    public private(set) var post: AmityPostModel?
    public private(set) var indexPath: IndexPath?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupContentLabel()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.isExpanded = false
        contentLabel.text = nil
        post = nil
    }
    
    public func display(post: AmityPostModel, indexPath: IndexPath) {
        
        self.post = post
        self.indexPath = indexPath
        
        if let liveStream = post.liveStream {
            // We picky back to render title/description for live stream post here.
            // By getting post.liveStream
            if let metadata = post.metadata, let mentionees = post.mentionees {
                let attributes = AmityMentionManager.getAttributes(fromText: post.text, withMetadata: metadata, mentionees: mentionees)
                
                contentLabel.setText(post.text, withAttributes: attributes)
            } else {
                contentLabel.text = post.text
            }
        } else {
            
            // The default render behaviour just to grab text from post.text
            if let metadata = post.metadata, let mentionees = post.mentionees {
                let attributes = AmityMentionManager.getAttributes(fromText: post.text, withMetadata: metadata, mentionees: mentionees)
                contentLabel.setText(post.text, withAttributes: attributes)
            } else {
                contentLabel.text = post.text
            }
        }
        
        contentLabel.isExpanded = post.appearance.shouldContentExpand
    }
    
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
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

// MARK: AmityExpandableLabelDelegate
extension AmityPostTextTableViewCell: AmityExpandableLabelDelegate {
    
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
