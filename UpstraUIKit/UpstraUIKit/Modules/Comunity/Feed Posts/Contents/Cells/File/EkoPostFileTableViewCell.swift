//
//  EkoPostFileTableViewCell.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

public final class EkoPostFileTableViewCell: UITableViewCell, Nibbable, EkoPostProtocol {
    weak var delegate: EkoPostDelegate?
    
    private enum Constant {
        static let CONTENT_MAXIMUM_LINE = 8
        static let CONTENT_ATTACH_MAXIMUM_LINE = 3
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var fileTableView: EkoFileTableView!
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    @IBOutlet private var contentLabel: EkoExpandableLabel!
    
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
        fileTableView.configure(files: post.files)
        heightConstraint.constant = EkoFileTableView.height(for: post.files.count, isEdtingMode: false, isExpanded: false)
        contentLabel.text = post.text
        contentLabel.isExpanded = shouldExpandContent
        contentLabel.numberOfLines = !post.files.isEmpty ? Constant.CONTENT_ATTACH_MAXIMUM_LINE : Constant.CONTENT_MAXIMUM_LINE
    }
    
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        
        setupFileTableView()
        setupContentLabel()
    }
    
    private func setupFileTableView() {
        fileTableView.isExpanded = false
        fileTableView.actionDelegate = self
    }
    
    private func setupContentLabel() {
        contentLabel.font = EkoFontSet.body
        contentLabel.textColor = EkoColorSet.base
        contentLabel.shouldCollapse = false
        contentLabel.textReplacementType = .character
        contentLabel.numberOfLines = Constant.CONTENT_MAXIMUM_LINE
        contentLabel.isExpanded = false
        contentLabel.delegate = self
    }
    
    // MARK: - Perform Action
    private func performAction(action: EkoPostAction) {
        delegate?.didPerformAction(self, action: action)
    }
    
}

extension EkoPostFileTableViewCell: EkoFileTableViewDelegate {
    func fileTableView(_ view: EkoFileTableView, didTapAt index: Int) {
        guard 0..<fileTableView.files.count ~= index else { return }
        let file = fileTableView.files[index]
        performAction(action: .tapFile(file: file))
    }
    
    func fileTableViewDidDeleteData(_ view: EkoFileTableView, at index: Int) {
        // Do nothing
    }
    
    func fileTableViewDidUpdateData(_ view: EkoFileTableView) {
        // Do nothing
    }
    
    func fileTableViewDidTapViewAll(_ view: EkoFileTableView) {
        performAction(action: .tapViewAll)
    }
}

extension EkoPostFileTableViewCell: EkoExpandableLabelDelegate {
    
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
