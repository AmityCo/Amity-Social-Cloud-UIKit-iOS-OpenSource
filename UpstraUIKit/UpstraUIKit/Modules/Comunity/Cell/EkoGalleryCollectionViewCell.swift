//
//  EkoGalleryCollectionViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import Photos
import UIKit
import EkoChat

protocol EkoGalleryCollectionViewCellDelegate: class {
    func didTapCloseButton(_ cell: EkoGalleryCollectionViewCell)
}

public class EkoGalleryCollectionViewCell: UICollectionViewCell {
    
    enum ViewState {
        case idle
        case uploaded
        case uploading(progress: Double)
        case error
    }
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var exclamationImageView: UIImageView!
    @IBOutlet weak var exclamationBackgroundView: UIView!
    
    weak var delegate: EkoGalleryCollectionViewCellDelegate?
    private(set) var viewState: ViewState = .idle
    
    @IBAction func tapClose(_ sender: Any) {
        delegate?.didTapCloseButton(self)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel.isHidden = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        
        closeButton.clipsToBounds = true
        closeButton.layer.cornerRadius = 10
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        closeButton.setImage(EkoIconSet.iconClose, for: .normal)
        closeButton.tintColor = EkoColorSet.baseInverse
        closeButton.backgroundColor = EkoColorSet.secondary.withAlphaComponent(0.2)
        
        progressView.trackTintColor = EkoColorSet.baseInverse
        progressView.transform = CGAffineTransform(scaleX: 1, y: 2)
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        progressView.isHidden = true
        progressView.progress = 0
        
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        overlayView.isHidden = true
        
        exclamationImageView.image = EkoIconSet.iconExclamation
        exclamationImageView.tintColor = EkoColorSet.baseInverse
        exclamationBackgroundView.backgroundColor = EkoColorSet.secondary.withAlphaComponent(0.7)
        exclamationBackgroundView.layer.cornerRadius = 13
        exclamationBackgroundView.clipsToBounds = true
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        overlayView.isHidden = true
    }
    
    func config(image: EkoImage?, isEditable: Bool, numberText: String?) {
        closeButton.isHidden = !isEditable
        numberLabel.isHidden = numberText == nil
        numberLabel.text = numberText
        if numberText != nil {
            imageView.setImageColor(color: .lightGray)
        }
        
        guard let selectedImage = image else {
            return
        }
        switch selectedImage.state {
        case .image(let image):
            imageView.image = image
        case .downloadable(let fileId, let placeholder):
            imageView.setImage(withFileId: fileId, placeholder: placeholder)
        case .localAsset, .uploaded, .none:
            selectedImage.loadImage(to: imageView)
        case .uploading, .error:
            break
        }
    }
    
    func updateViewState(_ viewState: ViewState) {
        self.viewState = viewState
        switch viewState {
        case .idle:
            closeButton.isHidden = false
            overlayView.isHidden = false
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
            exclamationBackgroundView.isHidden = true
        case .uploading(let progress):
            closeButton.isHidden = true
            overlayView.isHidden = false
            progressView.isHidden = false
            progressView.setProgress(Float(progress), animated: true)
            exclamationBackgroundView.isHidden = true
        case .uploaded:
            closeButton.isHidden = false
            overlayView.isHidden = true
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
            exclamationBackgroundView.isHidden = true
        case .error:
            closeButton.isHidden = false
            overlayView.isHidden = false
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
            exclamationBackgroundView.isHidden = false
        }
    }

}
