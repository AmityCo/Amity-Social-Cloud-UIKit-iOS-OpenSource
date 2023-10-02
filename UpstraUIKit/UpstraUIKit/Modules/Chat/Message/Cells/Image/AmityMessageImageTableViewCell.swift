//
//  AmityMessageImageTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 5/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

class AmityMessageImageTableViewCell: AmityMessageTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageImageView.image = AmityIconSet.defaultMessageImage
        messageImageView.contentMode = .center
    }

    private func setupView() {
        messageImageView.contentMode = .center
        messageImageView.layer.cornerRadius = 4
        let tapGesuter = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        tapGesuter.numberOfTouchesRequired = 1
        messageImageView.isUserInteractionEnabled = true
        messageImageView.addGestureRecognizer(tapGesuter)
    }
    
    override func display(message: AmityMessageModel) {
        if !message.isDeleted {
            let indexPath = self.indexPath
            AmityUIKitManagerInternal.shared.messageMediaService.downloadImageForMessage(message: message.object, size: .medium) { [weak self] in
                self?.messageImageView.image = AmityIconSet.defaultMessageImage
            } completion: { [weak self] result in
                switch result {
                case .success(let image):
                    // To check if the image going to assign has the correct index path.
                    if indexPath == self?.indexPath {
                        self?.messageImageView.image = image
                        self?.messageImageView.contentMode = .scaleAspectFill
                    }
                case .failure:
                    self?.messageImageView.image = AmityIconSet.defaultMessageImage
                    self?.metadataLabel.isHidden = false
                    self?.messageImageView.contentMode = .center
                }
            }
        }
        super.display(message: message)
    }
}

private extension AmityMessageImageTableViewCell {
    @objc
    func imageViewTap() {
        if messageImageView.image != AmityIconSet.defaultMessageImage {
            screenViewModel.action.performCellEvent(for: .imageViewer(indexPath: indexPath, imageView: messageImageView))
        }
    }
}
