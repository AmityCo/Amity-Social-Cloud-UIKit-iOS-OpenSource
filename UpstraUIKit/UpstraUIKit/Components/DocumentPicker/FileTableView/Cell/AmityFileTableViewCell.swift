//
//  AmityFileTableViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 28/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityFileTableViewCellDelegate: AnyObject {
    func didTapClose(_ cell: AmityFileTableViewCell)
}

class AmityFileTableViewCell: UITableViewCell, Nibbable {

    enum ViewState {
        case idle
        case downloadable
        case uploading(progress: Double)
        case uploaded
        case error
    }
    
    static let defaultHeight: CGFloat = 76
    
    weak var delegate: AmityFileTableViewCellDelegate?
    private(set) var viewState: ViewState = .idle

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var errorOverlayView: UIView!
    @IBOutlet weak var exclamationImageView: UIImageView!
    @IBOutlet weak var exclamationBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 4
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = AmityColorSet.secondary.blend(.shade4).cgColor
        closeButton.setImage(AmityIconSet.iconClose, for: .normal)
        closeButton.tintColor = AmityColorSet.base.blend(.shade2)
        titleLabel.font = AmityFontSet.bodyBold
        titleLabel.textColor = AmityColorSet.base
        subtitleLabel.font = AmityFontSet.caption
        subtitleLabel.textColor = AmityColorSet.base.blend(.shade1)
        progressView.transform = CGAffineTransform(scaleX: 1, y: 32)
        progressView.progressTintColor = AmityColorSet.secondary.blend(.shade4)
        progressView.trackTintColor = .clear
        progressView.progress = 0.0
        exclamationImageView.image = AmityIconSet.iconExclamation
        exclamationImageView.tintColor = AmityColorSet.baseInverse
        exclamationBackgroundView.backgroundColor = AmityColorSet.secondary.withAlphaComponent(0.7)
        exclamationBackgroundView.layer.cornerRadius = 13
        exclamationBackgroundView.clipsToBounds = true
        errorOverlayView.backgroundColor = AmityColorSet.secondary.blend(.shade4).withAlphaComponent(0.6)
        errorOverlayView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.progress = 0.0
        progress.completedUnitCount = 0
        errorOverlayView.isHidden = true
        viewState = .idle
    }
    
    private let progress = Progress(totalUnitCount: 100)
    
    func configure(with file: AmityFile, isEditingMode: Bool) {
        titleLabel.text = file.fileName
        subtitleLabel.text = file.formattedFileSize()
        closeButton.isHidden = !isEditingMode
        iconImageView.image = file.fileIcon
        
        // update view state when data is set
        switch file.state {
        case .uploaded:
            updateViewState(.uploaded)
        case .downloadable:
            isEditingMode ? updateViewState(.idle) : updateViewState(.downloadable)
        case .error(_):
            updateViewState(.error)
        default:
            updateViewState(.idle)
        }
    }
    
    func updateViewState(_ viewState: ViewState) {
        self.viewState = viewState
        switch viewState {
        case .idle:
            closeButton.isHidden = false
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
            containerView.layer.borderWidth = 1.0
            errorOverlayView.isHidden = true
        case .downloadable:
            closeButton.isHidden = true
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
            containerView.layer.borderWidth = 1.0
            errorOverlayView.isHidden = true
        case .uploading(let progress):
            closeButton.isHidden = true
            progressView.isHidden = false
            progressView.setProgress(Float(progress), animated: true)
            containerView.layer.borderWidth = 1.0
            errorOverlayView.isHidden = true
        case .uploaded:
            closeButton.isHidden = false
            progressView.isHidden = false
            progressView.setProgress(1, animated: false)
            containerView.layer.borderWidth = 0.0
            errorOverlayView.isHidden = true
        case .error:
            closeButton.isHidden = false
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
            containerView.layer.borderWidth = 0.0
            errorOverlayView.isHidden = false
        }
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        delegate?.didTapClose(self)
    }
    
}
