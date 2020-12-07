//
//  EkoMessageImageTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 5/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import EkoChat

class EkoMessageImageTableViewCell: EkoMessageTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageImageView.image = EkoIconSet.defaultMessageImage
    }

    private func setupView() {
        messageImageView.contentMode = .center
        messageImageView.layer.cornerRadius = 4
        let tapGesuter = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        tapGesuter.numberOfTouchesRequired = 1
        messageImageView.isUserInteractionEnabled = true
        messageImageView.addGestureRecognizer(tapGesuter)
    }
    
    override func display(message: EkoMessageModel) {
        if !message.isDeleted {
            EkoMessageMediaService.shared.download(for: message.object) { [weak self] in
                self?.messageImageView.image = EkoIconSet.defaultMessageImage
            } completion: { [weak self] (result) in
                switch result {
                case .success(let url):
                    let image = UIImage(contentsOfFile: url.absoluteString)
                    self?.messageImageView.image = image
                case .failure(let error):
                    self?.messageImageView.image = EkoIconSet.defaultMessageImage
                    self?.metadataLabel.isHidden = false
                }
            }
        }
        super.display(message: message)
    }
}

private extension EkoMessageImageTableViewCell {
    @objc
    func imageViewTap() {
        if messageImageView.image != EkoIconSet.defaultMessageImage {
            screenViewModel.action.performCellEvent(for: .imageViewer(imageView: messageImageView))
        }
    }
}
