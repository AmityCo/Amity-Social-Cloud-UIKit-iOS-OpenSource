//
//  PostGalleryItemCell.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 4/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

class PostGalleryItemCell: UICollectionViewCell, Nibbable {
    
    @IBOutlet private weak var darkOverlayView: UIView!
    
    @IBOutlet private weak var durationView: UIStackView!
    @IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet private weak var streamStateContainer: UIView!
    @IBOutlet private weak var streamStateLabel: UILabel!
    
    @IBOutlet private weak var mediaTitleLabel: UILabel!
    
    @IBOutlet private weak var streamEndView: UIView!
    @IBOutlet private weak var streamEndTitleLabel: UILabel!
    @IBOutlet private weak var streamEndDescriptionLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var session = UUID().uuidString
    
    static func getDurationFormatter(showHour: Bool) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = showHour ? [.hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //
        clipsToBounds = true
        layer.cornerRadius = 8
        // Image View
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AmityThemeManager.currentTheme.base.blend(.shade4)
        // Duration View
        durationView.backgroundColor = UIColor(hex: "000000", alpha: 0.7)
        durationView.clipsToBounds = true
        durationView.layer.cornerRadius = 4
        durationLabel.font = AmityFontSet.caption
        durationLabel.textColor = AmityThemeManager.currentTheme.baseInverse
        //
        streamStateContainer.clipsToBounds = true
        streamStateContainer.layer.cornerRadius = 4
        //
        streamStateLabel.font = AmityFontSet.captionBold
        streamStateLabel.textColor = .white
        //
        mediaTitleLabel.font = AmityFontSet.bodyBold
        mediaTitleLabel.textColor = .white
        //
        // This view will be shown only when we show stream item for certain states.
        streamEndView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        session = UUID().uuidString
    }
    
    func configure(with post: AmityPost) {
        
        // Properties to render
        let durationText: String?
        let streamStatus: AmityStreamStatus?
        let mediaTitle: String?
        let imageUrl: String?
        let placeholder: UIImage?
        
        // Find properties value from post.
        switch post.dataType {
        case "image":
            imageUrl = post.getImageInfo()?.fileURL
            placeholder = nil
            durationText = nil
            mediaTitle = nil
            streamStatus = nil
        case "video":
            let thumbnailInfo = post.getVideoThumbnailInfo()
            let videoInfo = post.getVideoInfo()
            imageUrl = thumbnailInfo?.fileURL
            placeholder = nil
            // Extract duration from video meta
            let duration: TimeInterval
            if let attributes = videoInfo?.attributes,
               let meta = attributes["metadata"] as? [String: Any],
               let videoMeta = meta["video"] as? [String: Any],
               let _duration = videoMeta["duration"] as? TimeInterval {
                duration = _duration
            } else {
                duration = .zero
            }
            durationText = PostGalleryItemCell.getDurationFormatter(showHour: duration >= 3600).string(from: duration)
            mediaTitle = nil
            streamStatus = nil
        case "liveStream":
            let livestreamPlaceholder = UIImage(named: "default_livestream", in: AmityUIKitManager.bundle, compatibleWith: nil)
            if let streamInfo = post.getLiveStreamInfo() {
                // We treat deleted stream as .idle
                if streamInfo.isDeleted {
                    streamStatus = .idle
                } else {
                    streamStatus = streamInfo.status
                }
                mediaTitle = streamInfo.title
                imageUrl = streamInfo.thumbnail?.fileURL
                placeholder = livestreamPlaceholder
            } else {
                streamStatus = nil
                mediaTitle = nil
                imageUrl = nil
                placeholder = livestreamPlaceholder
            }
            durationText = nil
        default:
            durationText = nil
            streamStatus = nil
            mediaTitle = nil
            imageUrl = nil
            placeholder = nil
        }
        
        // Render UI from properties above.
        
        // imageUrl, placeholder
        asyncLoadImage(urlString: imageUrl, placeholder: placeholder)
        
        // durationText
        if let durationText = durationText {
            durationView.isHidden = false
            durationLabel.text = durationText
        } else {
            durationView.isHidden = true
        }
        
        // streamEndView
        if let streamStatus = streamStatus {
            
            streamEndTitleLabel.font = AmityFontSet.title
            streamEndDescriptionLabel.font = AmityFontSet.body
            
            streamStateLabel.font = AmityFontSet.captionBold
            streamStateLabel.textColor = .white
            
            switch streamStatus {
            case .idle:
                streamEndView.isHidden = false
                streamEndTitleLabel.text = "The stream is currently unavailable."
                streamEndDescriptionLabel.text = nil
                streamEndDescriptionLabel.isHidden = true
            case .ended:
                streamEndView.isHidden = false
                streamEndTitleLabel.text = "This livestream has ended."
                streamEndDescriptionLabel.text = "Playback will be available for you to watch shortly."
                streamEndDescriptionLabel.isHidden = false
            default:
                streamEndView.isHidden = true
            }
        } else {
            streamEndView.isHidden = true
        }
        
        // streamStatus
        if let streamStatus = streamStatus {
            switch streamStatus {
            case .live:
                streamStateContainer.isHidden = false
                streamStateContainer.backgroundColor = UIColor(hex: "FF305A")
                streamStateLabel.text = "LIVE"
            case .recorded:
                streamStateContainer.isHidden = false
                streamStateContainer.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                streamStateLabel.text = "RECORDED"
            default:
                streamStateContainer.isHidden = true
            }
        } else {
            streamStateContainer.isHidden = true
        }
        
        // mediaTitle
        if let mediaTitle = mediaTitle {
            mediaTitleLabel.isHidden = false
            mediaTitleLabel.text = mediaTitle
        } else {
            mediaTitleLabel.isHidden = true
        }
        
        darkOverlayView.isHidden = (mediaTitleLabel.isHidden && streamStateContainer.isHidden)
        
    }
    
    private func asyncLoadImage(urlString: String?, placeholder: UIImage?) {
        
        guard let urlString = urlString else {
            imageView.image = placeholder
            return
        }
        
        let capturedSession = session
        
        // First set to be placeholder.
        imageView.image = placeholder
        
        AmityUIKitManagerInternal.shared.fileService.loadImage(
            imageURL: urlString,
            size: .medium,
            optimisticLoad: true,
            completion: { [weak self] result in
                guard
                    let strongSelf = self,
                    strongSelf.session == capturedSession else {
                    return
                }
                switch result {
                case .success(let image):
                    strongSelf.imageView.image = image
                case .failure:
                    strongSelf.imageView.image = placeholder
                }
            }
        )
        
    }

}
