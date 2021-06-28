//
//  AmityPostTextEditorMenuView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 3/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

protocol AmityPostTextEditorMenuViewDelegate: class {
    func postMenuView(_ view: AmityPostTextEditorMenuView, didTap action: AmityPostMenuActionType)
}

enum AmityPostMenuActionType {
    case camera
    case photo
    case file
}

class AmityPostTextEditorMenuView: UIView {
    
    static let defaultHeight: CGFloat = 41
    
    private let settings: AmityPostEditorSettings
    private let stackView = UIStackView(frame: .zero)
    private let topLineView = UIView(frame: .zero)
    private let cameraButton = AmityButton(frame: .zero)
    private let photoGalleryButton = AmityButton(frame: .zero)
    private let fileButton = AmityButton(frame: .zero)
    
    weak var delegate: AmityPostTextEditorMenuViewDelegate?
    var isCameraButtonEnabled: Bool {
        get {
            return cameraButton.isEnabled
        }
        set {
            cameraButton.isEnabled = newValue
        }
    }
    
    var isPhotoButtonEnabled: Bool {
        get {
            return photoGalleryButton.isEnabled
        }
        set {
            photoGalleryButton.isEnabled = newValue
        }
    }
    
    var isFileButtonEnabled: Bool {
        get {
            return fileButton.isEnabled
        }
        set {
            fileButton.isEnabled = newValue
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
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.addArrangedSubview(cameraButton)
        stackView.addArrangedSubview(photoGalleryButton)
        stackView.addArrangedSubview(fileButton)
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        topLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        
        cameraButton.setImage(AmityIconSet.iconCameraSmall, for: .normal)
        cameraButton.setTintColor(AmityColorSet.base, for: .normal)
        cameraButton.setTintColor(AmityColorSet.base.blend(.shade4), for: .disabled)
        cameraButton.addTarget(self, action: #selector(tapCamera), for: .touchUpInside)
        
        photoGalleryButton.setImage(AmityIconSet.iconPhoto, for: .normal)
        photoGalleryButton.setTintColor(AmityColorSet.base, for: .normal)
        photoGalleryButton.setTintColor(AmityColorSet.base.blend(.shade4), for: .disabled)
        photoGalleryButton.addTarget(self, action: #selector(tapPhoto), for: .touchUpInside)
        
        fileButton.setImage(AmityIconSet.iconAttach, for: .normal)
        fileButton.setTintColor(AmityColorSet.base, for: .normal)
        fileButton.setTintColor(AmityColorSet.base.blend(.shade4), for: .disabled)
        fileButton.addTarget(self, action: #selector(tapFile), for: .touchUpInside)
        
        addSubview(topLineView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: Constant.topLineViewHeight),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topLineView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        // settings
        cameraButton.isHidden = settings.shouldCameraButtonHide
        photoGalleryButton.isHidden = settings.shouldPhotoButtonHide
        fileButton.isHidden = settings.shouldFileButtonHide
    }
    
    // MARK: - Private function
    
    @objc private func tapCamera() {
        delegate?.postMenuView(self, didTap: .camera)
    }
    
    @objc private func tapPhoto() {
        delegate?.postMenuView(self, didTap: .photo)
    }
    
    @objc private func tapFile() {
        delegate?.postMenuView(self, didTap: .file)
    }

}
