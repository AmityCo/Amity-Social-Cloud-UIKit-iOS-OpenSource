//
//  AmityGalleryCollectionViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 15/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import Photos
import UIKit
import AmitySDK

protocol AmityGalleryCollectionViewCellDelegate: AnyObject {
    func didTapCloseButton(_ cell: AmityGalleryCollectionViewCell)
}

public class AmityGalleryCollectionViewCell: UICollectionViewCell {
    
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
    @IBOutlet weak var playImageView: UIImageView!
    
    weak var delegate: AmityGalleryCollectionViewCellDelegate?
    
    private(set) var viewState: ViewState = .idle
    private var isEditable = false
    private var numberText: String?
    
    private var shouldShowPlayButton = false
    
    private var session = UUID().uuidString
    
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
        closeButton.setImage(AmityIconSet.iconClose, for: .normal)
        closeButton.tintColor = AmityColorSet.baseInverse
        closeButton.backgroundColor = AmityColorSet.secondary.withAlphaComponent(0.2)
        
        progressView.trackTintColor = AmityColorSet.baseInverse
        progressView.transform = CGAffineTransform(scaleX: 1, y: 2)
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        progressView.isHidden = true
        progressView.progress = 0
        
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        overlayView.isHidden = true
        
        exclamationImageView.image = AmityIconSet.iconExclamation
        exclamationImageView.tintColor = AmityColorSet.baseInverse
        exclamationBackgroundView.backgroundColor = AmityColorSet.secondary.withAlphaComponent(0.7)
        exclamationBackgroundView.layer.cornerRadius = 13
        exclamationBackgroundView.clipsToBounds = true
        
        playImageView.tintColor = .white
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        overlayView.isHidden = true
        session = UUID().uuidString
    }
    
    func display(media: AmityMedia?, isEditable: Bool, numberText: String?) {
        
        self.numberText = numberText
        self.isEditable = isEditable
        
        numberLabel.isHidden = numberText == nil
        numberLabel.text = numberText
        
        if numberText != nil {
            imageView.setImageColor(.lightGray)
        }
        
        if let media = media {
            shouldShowPlayButton = (media.type == .video)
            
            switch media.state {
            case .error:
                self.viewState = .error
            default:
                self.viewState = .idle
            }
            
            tryLoadMediaThumbnail(media)
        }
        
        updateViewState(viewState)
    }
    
    private func tryLoadMediaThumbnail(_ media: AmityMedia) {
        switch media.state {
        case .image(let image):
            imageView.image = image
        case .downloadableImage(let imageData, _):
            loadThumbnailImage(at: imageData.fileURL)
        case .downloadableVideo(_, let thumbnailUrl):
            if let thumbnailUrl = thumbnailUrl {
                loadThumbnailImage(at: thumbnailUrl)
            } else {
                imageView.image = AmityIconSet.videoThumbnailPlaceholder
            }
        case .localURL, .localAsset, .uploadedImage, .uploadedVideo, .none:
            media.loadImage(to: imageView, preferredSize: frame.size)
        case .uploading, .error:
            break
        }
    }
    
    private func loadThumbnailImage(at imageURL: String) {
        let _session = session
        AmityUIKitManagerInternal.shared.fileService.loadImage(imageURL: imageURL, size: .medium, optimisticLoad: true) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let image):
                // To prevent diplaying the wrong image after cell is dequeued.
                guard strongSelf.session == _session else {
                    // Cell has already dequeue.
                    return
                }
                strongSelf.imageView.image = image
            case .failure(let error):
                Log.add("Error while downloading image with file id: \(imageURL) error: \(error)")
            }
        }
    }
    
    func updateViewState(_ viewState: ViewState) {
        
        let playButtonHidden: Bool
        let closeButtonHidden: Bool
        
        closeButton.isHidden = !isEditable
        self.viewState = viewState
        switch viewState {
        case .idle:
            closeButtonHidden = false
            overlayView.isHidden = true
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
            exclamationBackgroundView.isHidden = true
            playButtonHidden = false
        case .uploading(let progress):
            closeButtonHidden = true
            overlayView.isHidden = false
            progressView.isHidden = false
            progressView.setProgress(Float(progress), animated: true)
            exclamationBackgroundView.isHidden = true
            playButtonHidden = true
        case .uploaded:
            closeButtonHidden = false
            overlayView.isHidden = true
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
            exclamationBackgroundView.isHidden = true
            playButtonHidden = false
        case .error:
            closeButtonHidden = false
            overlayView.isHidden = false
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
            exclamationBackgroundView.isHidden = false
            playButtonHidden = true
        }
        
        if !isEditable {
            closeButton.isHidden = true
        } else {
            closeButton.isHidden = closeButtonHidden
        }
        
        let hasNumberText: Bool
        if let numberText = numberText, !numberText.isEmpty {
            hasNumberText = true
        } else {
            hasNumberText = false
        }
        
        if shouldShowPlayButton, !playButtonHidden, !hasNumberText {
            playImageView.isHidden = false
        } else {
            playImageView.isHidden = true
        }
        
    }

}
