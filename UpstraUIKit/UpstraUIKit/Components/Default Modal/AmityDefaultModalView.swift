//
//  AmityDefaultModalView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 16/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

/*
 * Default modal model
 */
enum AmityDefaultModalModelType {
    case vertical, horizontal
}

struct AmityDefaultModalModel {
    let image: UIImage?
    let title: String?
    let description: String?
    
    let firstAction: Action?
    let secondAction: Action?

    let layout: AmityDefaultModalModelType
    
    struct Action {
        let title: String
        let textColor: UIColor
        let font: UIFont
        let backgroundColor: UIColor
        let cornerRadius: CGFloat
        
        init(title: String, textColor: UIColor, font: UIFont = AmityFontSet.bodyBold, backgroundColor: UIColor, cornerRadius: CGFloat = 8) {
            self.title = title
            self.textColor = textColor
            self.font = font
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
        }
    }
}

final class AmityDefaultModalView: AmityView {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: AmityLabel!
    @IBOutlet private var descriptionLabel: AmityLabel!
    
    // Vertical action views
    @IBOutlet private var verticalActionStackView: UIStackView!
    @IBOutlet private var firstVerticalActionButton: UIButton!
    @IBOutlet private var secondVerticalActionButton: UIButton!
    
    // Horizontal action views
    @IBOutlet private var horizontalActionStackView: UIStackView!
    @IBOutlet private var firstHorizontalActionButton: UIButton!
    @IBOutlet private var secondHorizontalActionButton: UIButton!
    
    // MARK: - Properties
    var firstActionHandler: (() -> Void)?
    var secondActionHandler: (() -> Void)?
    var backgroundTapHandler: (() -> Void)?
    
    private var content: AmityDefaultModalModel? {
        didSet {
            updateContent()
        }
    }

    override func initial() {
        loadNibContent()
        setupViews()
    }
    
    static func make(content: AmityDefaultModalModel) -> AmityDefaultModalView {
        let view = AmityDefaultModalView(frame: UIScreen.main.bounds)
        view.content = content
        return view
    }
    
    // MARK: - Setup view
    private func setupViews() {
        
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = AmityColorSet.backgroundColor
        
        titleLabel.font = AmityFontSet.headerLine
        titleLabel.textColor = AmityColorSet.base
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = AmityLocalizedStringSet.titlePlaceholder.localizedString
        
        descriptionLabel.font = AmityFontSet.body
        descriptionLabel.textColor = AmityColorSet.base.blend(.shade1)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = AmityLocalizedStringSet.descriptionPlaceholder.localizedString
        
    }
    
    private func updateContent() {
        imageView.image = content?.image
        titleLabel.text = content?.title?.localizedString
        descriptionLabel.text = content?.description?.localizedString
        guard let layout = content?.layout else { return }
        switch layout {
        case .vertical:
            updateActionButton(firstVerticalActionButton, contentAction: content?.firstAction)
            updateActionButton(secondVerticalActionButton, contentAction: content?.secondAction)
        case .horizontal:
            updateActionButton(firstHorizontalActionButton, contentAction: content?.firstAction)
            updateActionButton(secondHorizontalActionButton, contentAction: content?.secondAction)
        
        }
        verticalActionStackView.isHidden = content?.layout == .horizontal
        horizontalActionStackView.isHidden = content?.layout == .vertical
    }
    
    private func updateActionButton(_ sender: UIButton, contentAction: AmityDefaultModalModel.Action?) {
        if let action = contentAction {
            sender.setTitle(action.title.localizedString, for: .normal)
            sender.setTitleColor(action.textColor, for: .normal)
            sender.backgroundColor = action.backgroundColor
            sender.titleLabel?.font = action.font
            sender.layer.cornerRadius = action.cornerRadius
            sender.isHidden = false
        } else {
            sender.isHidden = true
        }
    }
}

// MARK: - Action
private extension AmityDefaultModalView {
    
    @IBAction func firstActionButtonTap(_ sender: UIButton) {
        if content?.firstAction != nil {
            firstActionHandler?()
        }
    }
    
    @IBAction func secondActionButtonTap(_ sender: UIButton) {
        if content?.secondAction != nil {
            secondActionHandler?()
        }
    }
    
    @IBAction func backgroundTap() {
        backgroundTapHandler?()
    }
}
