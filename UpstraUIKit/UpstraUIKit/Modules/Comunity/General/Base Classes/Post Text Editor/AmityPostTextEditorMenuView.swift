//
//  AmityPostTextEditorMenuView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 3/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

protocol AmityPostTextEditorMenuViewDelegate: AnyObject {
    func postMenuView(_ view: AmityPostTextEditorMenuView, didTap action: AmityPostMenuActionType)
}

enum AmityPostMenuActionType {
    case camera
    case album
    case video
    case file
    case expand
}

enum AmityPostAttachmentType {
    case image
    case video
    case file
    case none
}

class AmityPostTextEditorMenuView: UIView {
    
    static let defaultHeight: CGFloat = 60
    
    private let settings: AmityPostEditorSettings
    private let stackView = UIStackView(frame: .zero)
    private let topLineView = UIView(frame: .zero)
    private let cameraButton = AmityButton(frame: .zero)
    private let albumButton = AmityButton(frame: .zero)
    private let videoButton = AmityButton(frame: .zero)
    private let fileButton = AmityButton(frame: .zero)
    private let expandButton = AmityButton(frame: .zero)
    
    weak var delegate: AmityPostTextEditorMenuViewDelegate?
    
    var attachmentType: AmityPostAttachmentType = .none {
        didSet {
            updateButtonState()
        }
    }
    
    private enum Constant {
        static let topLineViewHeight: CGFloat = 1.0
    }
    
    init(settings: AmityPostEditorSettings) {
        self.settings = settings
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = AmityColorSet.backgroundColor
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 16
        layer.borderColor = AmityColorSet.secondary.blend(.shade4).cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        topLineView.backgroundColor = .clear
        
        cameraButton.setImage(AmityIconSet.iconCameraSmall, for: .normal)
        cameraButton.addTarget(self, action: #selector(tapCamera), for: .touchUpInside)
        albumButton.setImage(AmityIconSet.iconPhoto, for: .normal)
        albumButton.addTarget(self, action: #selector(tapPhoto), for: .touchUpInside)
        videoButton.setImage(AmityIconSet.iconPlayVideo, for: .normal)
        videoButton.addTarget(self, action: #selector(tapVideo), for: .touchUpInside)
        fileButton.setImage(AmityIconSet.iconAttach, for: .normal)
        fileButton.addTarget(self, action: #selector(tapFile), for: .touchUpInside)
        expandButton.setImage(AmityIconSet.iconDownChevron, for: .normal)
        expandButton.addTarget(self, action: #selector(tapExpand), for: .touchUpInside)
        
        // setup buttons
        for button in [cameraButton, albumButton, videoButton, fileButton, expandButton] {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 32).isActive = true
            button.heightAnchor.constraint(equalToConstant: 32).isActive = true
            button.layer.cornerRadius = 16
            button.clipsToBounds = true
            button.backgroundColor = (button == expandButton) ? .clear : AmityColorSet.base.blend(.shade4)
            button.setTintColor(AmityColorSet.base, for: .normal)
            button.setTintColor(AmityColorSet.base.blend(.shade3), for: .disabled)
            stackView.addArrangedSubview(button)
        }
        
        addSubview(topLineView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: Constant.topLineViewHeight),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,  constant: -16),
            stackView.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        
        // settings
        cameraButton.isHidden = settings.shouldCameraButtonHide
        albumButton.isHidden = settings.shouldAlbumButtonHide
        fileButton.isHidden = settings.shouldFileButtonHide
    }
    
    private func updateButtonState() {
        switch attachmentType {
        case .image:
            cameraButton.isEnabled = true
            albumButton.isEnabled = true
            videoButton.isEnabled = false
            fileButton.isEnabled = false
        case .video:
            cameraButton.isEnabled = true
            albumButton.isEnabled = false
            videoButton.isEnabled = true
            fileButton.isEnabled = false
        case .file:
            cameraButton.isEnabled = false
            albumButton.isEnabled = false
            videoButton.isEnabled = false
            fileButton.isEnabled = true
        case .none:
            cameraButton.isEnabled = true
            albumButton.isEnabled = true
            videoButton.isEnabled = true
            fileButton.isEnabled = true
        }
    }
    
    // MARK: - Private function
    
    @objc private func tapCamera() {
        delegate?.postMenuView(self, didTap: .camera)
    }
    
    @objc private func tapPhoto() {
        delegate?.postMenuView(self, didTap: .album)
    }
    
    @objc private func tapVideo() {
        delegate?.postMenuView(self, didTap: .video)
    }
    
    @objc private func tapFile() {
        delegate?.postMenuView(self, didTap: .file)
    }
    
    @objc private func tapExpand() {
        delegate?.postMenuView(self, didTap: .expand)
    }

}
