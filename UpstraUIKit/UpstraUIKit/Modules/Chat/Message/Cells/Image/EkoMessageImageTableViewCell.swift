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
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var drimView: UIView!
    @IBOutlet private var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var dateLabel: UILabel!
    
    private var aspectRatioConstraint: NSLayoutConstraint? {
        didSet {
            if let oldValue = oldValue {
                oldValue.isActive = false
            }
            if let aspectRatioConstraint = aspectRatioConstraint {
                aspectRatioConstraint.isActive = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectRatioConstraint = nil
        messageImageView.image = nil
    }

    private func setupView() {
        drimView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        messageImageView.layer.cornerRadius = 4
        let tapGesuter = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        tapGesuter.numberOfTouchesRequired = 1
        messageImageView.isUserInteractionEnabled = true
        messageImageView.addGestureRecognizer(tapGesuter)
    }
    
    override func display(message: EkoMessageModel) {
        if !message.isDeleted {
            if message.isOwner {
                switch message.syncState {
                case .syncing:
                    loadingIndicatorView?.startAnimating()
                    drimView.isHidden = false
                case .synced, .default, .error:
                    loadingIndicatorView?.stopAnimating()
                    drimView.isHidden = true
                @unknown default:
                    break
                }
            }
            EkoMediaService.shared.dowloadImage(messageId: message.messageId, size: .medium) { [weak self] (image) in
                guard let strongSelf = self, let image = image else {
                    return
                }
                strongSelf.setImageWithSize(image: image, imageView: strongSelf.messageImageView)
            }
        }
        super.display(message: message)
    }
    
    override func setMetadata(message: EkoMessageModel) {
        super.setMetadata(message: message)
        if !message.isDeleted {
            let fullString = NSMutableAttributedString()
            let style: [NSAttributedString.Key : Any]? = [.foregroundColor: EkoColorSet.base.blend(.shade4),
                                                          .font: EkoFontSet.caption]
            metadataLabel.isHidden = true
            fullString.append(NSAttributedString(string: message.time, attributes: style))
            dateLabel.attributedText = fullString
        }
    }
    
    private func setImageWithSize(image: UIImage, imageView: UIImageView) {
        let aspect = image.size.width / image.size.height
        aspectRatioConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: aspect)
        messageImageView.image = image
    }
}

private extension EkoMessageImageTableViewCell {
    @objc
    func imageViewTap() {
        screenViewModel.action.performCellEvent(for: .imageViewer(imageView: messageImageView))
    }
}
