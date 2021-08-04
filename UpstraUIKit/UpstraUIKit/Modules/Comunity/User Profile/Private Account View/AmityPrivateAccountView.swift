//
//  AmityPrivateAccountView.swift
//  AmityUIKit
//
//  Created by Hamlet on 07.06.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

class AmityPrivateAccountView: UIView {
    private let imageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    private let stackView = UIStackView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = AmityColorSet.backgroundColor
        setupImageView()
        setupTitle()
        setupSubtitle()
        setupStackView()
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -36.0),
        ])
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = AmityIconSet.privateUserFeed
    }
    
    private func setupTitle() {
        titleLabel.text = AmityLocalizedStringSet.privateUserFeedTitle.localizedString
        titleLabel.font = AmityFontSet.headerLine
        titleLabel.textColor = AmityColorSet.base
        titleLabel.textAlignment = .center
    }
    
    private func setupSubtitle() {
        subtitleLabel.text = AmityLocalizedStringSet.privateUserFeedSubtitle.localizedString
        subtitleLabel.font = AmityFontSet.title
        subtitleLabel.textColor = AmityColorSet.base.blend(.shade3)
        subtitleLabel.textAlignment = .center
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
}
