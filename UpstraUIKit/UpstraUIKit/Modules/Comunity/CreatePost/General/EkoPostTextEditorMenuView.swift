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
        static let padding: CGFloat = 24.0
        static let buttonSize: CGFloat = 32.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        topLineView.backgroundColor = EkoColorSet.base.blend(.shade4)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.setImage(EkoIconSet.iconCameraSmall, for: .normal)
        cameraButton.setTintColor(EkoColorSet.base, for: .normal)
        cameraButton.setTintColor(EkoColorSet.base.blend(.shade4), for: .disabled)
        cameraButton.addTarget(self, action: #selector(tapCamera), for: .touchUpInside)
        photoGalleryButton.translatesAutoresizingMaskIntoConstraints = false
        photoGalleryButton.setImage(EkoIconSet.iconPhoto, for: .normal)
        photoGalleryButton.setTintColor(EkoColorSet.base, for: .normal)
        photoGalleryButton.setTintColor(EkoColorSet.base.blend(.shade4), for: .disabled)
        photoGalleryButton.addTarget(self, action: #selector(tapPhoto), for: .touchUpInside)
        fileButton.translatesAutoresizingMaskIntoConstraints = false
        fileButton.setImage(EkoIconSet.iconAttach, for: .normal)
        fileButton.setTintColor(EkoColorSet.base, for: .normal)
        fileButton.setTintColor(EkoColorSet.base.blend(.shade4), for: .disabled)
        fileButton.addTarget(self, action: #selector(tapFile), for: .touchUpInside)
        addSubview(topLineView)
        addSubview(cameraButton)
        addSubview(photoGalleryButton)
        addSubview(fileButton)
        NSLayoutConstraint.activate([
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: Constant.topLineViewHeight),
            cameraButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.padding),
            cameraButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constant.topLineViewHeight),
            cameraButton.widthAnchor.constraint(equalToConstant: Constant.buttonSize),
            cameraButton.heightAnchor.constraint(equalToConstant: Constant.buttonSize),
            photoGalleryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoGalleryButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constant.topLineViewHeight),
            photoGalleryButton.widthAnchor.constraint(equalToConstant: Constant.buttonSize),
            photoGalleryButton.heightAnchor.constraint(equalToConstant: Constant.buttonSize),
            fileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.padding),
            fileButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constant.topLineViewHeight),
            fileButton.widthAnchor.constraint(equalToConstant: Constant.buttonSize),
            fileButton.heightAnchor.constraint(equalToConstant: Constant.buttonSize),
        ])
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
