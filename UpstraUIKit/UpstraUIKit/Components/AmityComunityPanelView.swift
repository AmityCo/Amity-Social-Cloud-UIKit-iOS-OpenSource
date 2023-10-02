//
//  AmityComunityPanelView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 31/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

class AmityComunityPanelView: UIView {
    
    static let defaultHeight: CGFloat = 80.0
    
    private let topBorderLine = UILabel(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    private let actionSwitch = UISwitch(frame: .zero)
    
    var postAsComunity: Bool {
        get {
            return actionSwitch.isOn
        }
        set {
            actionSwitch.isOn = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = AmityColorSet.backgroundColor
        topBorderLine.translatesAutoresizingMaskIntoConstraints = false
        topBorderLine.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = AmityFontSet.bodyBold
        titleLabel.numberOfLines = 1
        titleLabel.text = AmityLocalizedStringSet.postToPostAsCommunityTitle.localizedString
        titleLabel.textColor = AmityColorSet.base
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = AmityFontSet.caption
        subtitleLabel.text = AmityLocalizedStringSet.postToPostAsCommunityMessage.localizedString
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textColor = AmityColorSet.base.blend(.shade1)
        actionSwitch.translatesAutoresizingMaskIntoConstraints = false
        actionSwitch.onTintColor = AmityColorSet.primary
        actionSwitch.setContentCompressionResistancePriority(.required, for: .horizontal)
        addSubview(topBorderLine)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionSwitch)
        
        NSLayoutConstraint.activate([
            topBorderLine.topAnchor.constraint(equalTo: topAnchor),
            topBorderLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorderLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorderLine.heightAnchor.constraint(equalToConstant: 1.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionSwitch.leadingAnchor, constant: -32),
            titleLabel.topAnchor.constraint(equalTo: topBorderLine.bottomAnchor, constant: 12.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: actionSwitch.leadingAnchor, constant: -32),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.0),
            actionSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
}
