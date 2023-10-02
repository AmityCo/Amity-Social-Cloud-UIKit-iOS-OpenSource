//
//  AmityEmptyStateHeaderFooterView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 30/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

enum EmptyStateLayout {
    case label(title: String, subtitle: String?, image: UIImage?)
    case loading
    case custom(UIView)
}

class AmityEmptyStateHeaderFooterView: UITableViewHeaderFooterView {
    
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
    private let loadingIndicator = UIActivityIndicatorView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
        loadingIndicator.stopAnimating()
    }
    
    private func setupView() {
        contentView.backgroundColor = AmityColorSet.backgroundColor
        setupImageView()
        setupTitle()
        setupSubtitle()
        setupStackView()
        setupLoadingIndicator()
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
        titleLabel.text = AmityLocalizedStringSet.emptyNewsfeedTitle.localizedString
        titleLabel.font = AmityFontSet.title
        titleLabel.textColor = AmityColorSet.base.blend(.shade3)
        titleLabel.textAlignment = .center
    }
    
    private func setupSubtitle() {
        subtitleLabel.text = AmityLocalizedStringSet.emptyNewsfeedStartYourFirstPost.localizedString
        subtitleLabel.font = AmityFontSet.headerLine
        subtitleLabel.textColor = AmityColorSet.base
        subtitleLabel.textAlignment = .center
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.style = .large
        loadingIndicator.color = AmityColorSet.base.blend(.shade2)
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
    }
    
    private func setupDefaultSubviews() {
        if !stackView.arrangedSubviews.contains(imageView) {
            stackView.addArrangedSubview(imageView)
        }
        if !stackView.arrangedSubviews.contains(titleLabel) {
            stackView.addArrangedSubview(titleLabel)
        }
        if !stackView.arrangedSubviews.contains(subtitleLabel) {
            stackView.addArrangedSubview(subtitleLabel)
        }
        if !stackView.arrangedSubviews.contains(loadingIndicator) {
            stackView.addArrangedSubview(loadingIndicator)
        }
    }
    
    func setLayout(layout: EmptyStateLayout) {
        switch layout {
        case .label(let title, let subtitle, let image):
            titleLabel.text = title
            subtitleLabel.text = subtitle
            imageView.image = image
            setupDefaultSubviews()
            
            // visibility
            titleLabel.isHidden = false
            subtitleLabel.isHidden = subtitle == nil
            imageView.isHidden = image == nil
            loadingIndicator.isHidden = true
            
        case .loading:
            loadingIndicator.startAnimating()
            setupDefaultSubviews()
            
            // visibility
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            imageView.isHidden = true
            loadingIndicator.isHidden = false
            
        case .custom(let view):
            stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            stackView.addArrangedSubview(view)
        }
    }
    
}
