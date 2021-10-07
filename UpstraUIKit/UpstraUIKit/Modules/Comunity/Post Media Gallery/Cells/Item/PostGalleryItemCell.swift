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
    
    @IBOutlet private weak var durationView: UIStackView!
    @IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var session = UUID().uuidString
    
    static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    } ()
    
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        session = UUID().uuidString
    }
    
    func configure(with post: AmityPost) {
        
        let durationText: String?
        
        switch post.dataType {
        case "image":
            asyncLoadImage(
                urlString: post.getImageInfo()?.fileURL,
                placeholder: nil
            )
            durationText = nil
        case "video":
            let thumbnailInfo = post.getVideoThumbnailInfo()
            let videoInfo = post.getVideoInfo(for: .original)
            asyncLoadImage(
                urlString: thumbnailInfo?.fileURL,
                placeholder: nil
            )
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
            durationText = PostGalleryItemCell.durationFormatter.string(from: duration)
        default:
            imageView.image = nil
            durationText = nil
        }
        
        if let durationText = durationText {
            durationView.isHidden = false
            durationLabel.text = durationText
        } else {
            durationView.isHidden = true
        }
        
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
