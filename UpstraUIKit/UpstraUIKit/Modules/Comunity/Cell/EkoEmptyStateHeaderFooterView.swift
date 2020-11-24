//
//  EkoEmptyStateHeaderFooterView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 30/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

enum EmptyStateLayout {
    case label(title: String, subtitle: String?, image: UIImage?)
    case custom(UIView)
}

class EkoEmptyStateHeaderFooterView: UITableViewHeaderFooterView {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.isHidden = false
        }
    }
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    private let imageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    private let stackView = UIStackView(frame: .zero)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = EkoColorSet.backgroundColor
        setupImageView()
        setupTitle()
        setupSubtitle()
        setupStackView()
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -36.0),
        ])
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
    }
    
    private func setupTitle() {
        titleLabel.text = EkoLocalizedStringSet.emptyNewsfeedTitle
        titleLabel.font = EkoFontSet.title
        titleLabel.textColor = EkoColorSet.base.blend(.shade3)
        titleLabel.textAlignment = .center
    }
    
    private func setupSubtitle() {
        subtitleLabel.text = EkoLocalizedStringSet.emptyNewsfeedStartYourFirstPost
        subtitleLabel.font = EkoFontSet.headerLine
        subtitleLabel.textColor = EkoColorSet.base.blend(.shade3)
        subtitleLabel.textColor = EkoColorSet.base
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
    
    func setLayout(layout: EmptyStateLayout) {
        switch layout {
        case .label(let title, let subtitle, let image):
            titleLabel.text = title
            subtitleLabel.text = subtitle
            imageView.image = image
            titleLabel.isHidden = false
            subtitleLabel.isHidden = subtitle == nil
            imageView.isHidden = image == nil
            break
        case .custom(let view):
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            stackView.addArrangedSubview(view)
        }
    }
    
}
