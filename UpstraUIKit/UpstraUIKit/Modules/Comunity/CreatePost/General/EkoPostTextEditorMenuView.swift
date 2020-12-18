//
//  EkoPostTextEditorMenuView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 3/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

protocol EkoPostTextEditorMenuViewDelegate: class {
    func postMenuView(_ view: EkoPostTextEditorMenuView, didTap action: EkoPostMenuActionType)
}

enum EkoPostMenuActionType {
    case camera
    case photo
    case file
}

class EkoPostTextEditorMenuView: UIView {
    
    static let defaultHeight: CGFloat = 41
    
    private let settings: EkoPostEditorSettings
    private let stackView = UIStackView(frame: .zero)
    private let topLineView = UIView(frame: .zero)
    private let cameraButton = EkoButton(frame: .zero)
    private let photoGalleryButton = EkoButton(frame: .zero)
    private let fileButton = EkoButton(frame: .zero)
    
    weak var delegate: EkoPostTextEditorMenuViewDelegate?
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
    
    init(settings: EkoPostEditorSettings) {
        self.settings = settings
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = EkoColorSet.backgroundColor
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.addArrangedSubview(cameraButton)
        stackView.addArrangedSubview(photoGalleryButton)
        stackView.addArrangedSubview(fileButton)
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        topLineView.backgroundColor = EkoColorSet.base.blend(.shade4)
        
        cameraButton.setImage(EkoIconSet.iconCameraSmall, for: .normal)
        cameraButton.setTintColor(EkoColorSet.base, for: .normal)
        cameraButton.setTintColor(EkoColorSet.base.blend(.shade4), for: .disabled)
        cameraButton.addTarget(self, action: #selector(tapCamera), for: .touchUpInside)
        
        photoGalleryButton.setImage(EkoIconSet.iconPhoto, for: .normal)
        photoGalleryButton.setTintColor(EkoColorSet.base, for: .normal)
        photoGalleryButton.setTintColor(EkoColorSet.base.blend(.shade4), for: .disabled)
        photoGalleryButton.addTarget(self, action: #selector(tapPhoto), for: .touchUpInside)
        
        fileButton.setImage(EkoIconSet.iconAttach, for: .normal)
        fileButton.setTintColor(EkoColorSet.base, for: .normal)
        fileButton.setTintColor(EkoColorSet.base.blend(.shade4), for: .disabled)
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
