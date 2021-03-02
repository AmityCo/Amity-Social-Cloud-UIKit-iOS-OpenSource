//
//  EkoPostTextTableViewCell.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

public final class EkoPostTextTableViewCell: UITableViewCell, Nibbable, EkoPostProtocol {
    
    weak var delegate: EkoPostDelegate?
    
    private enum Constant {
        static let CONTENT_MAXIMUM_LINE = 8
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var contentLabel: EkoExpandableLabel!
    
    // MARK: - Properties
    private(set) var post: EkoPostModel?
    private(set) var indexPath: IndexPath?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.isExpanded = false
        contentLabel.text = nil
    }
    
    func display(post: EkoPostModel, shouldExpandContent: Bool, indexPath: IndexPath) {
        self.post = post
        self.indexPath = indexPath
        
        contentLabel.text = post.text
        contentLabel.isExpanded = shouldExpandContent
    }
    
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        setupContentLabel()
    }
    
    private func setupContentLabel() {
        contentLabel.font = EkoFontSet.body
        contentLabel.textColor = EkoColorSet.base
        contentLabel.shouldCollapse = false
        contentLabel.textReplacementType = .character
        contentLabel.numberOfLines = Constant.CONTENT_MAXIMUM_LINE
        contentLabel.isExpanded = false
    }
    
    // MARK: - Perform Action
    private func performAction(action: EkoPostAction) {
        delegate?.didPerformAction(self, action: action)
    }
}

// MARK: EkoExpandableLabelDelegate
extension EkoPostTextTableViewCell: EkoExpandableLabelDelegate {
    
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
