//
//  EkoFileTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 28/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoFileTableViewCellDelegate: class {
    func didTapClose(_ cell: EkoFileTableViewCell)
}

class EkoFileTableViewCell: UITableViewCell, Nibbable {

    enum ViewState {
        case idle
        case downloadable
        case uploading(progress: Double)
        case uploaded
        case error
    }
    
    static let defaultHeight: CGFloat = 76
    
    weak var delegate: EkoFileTableViewCellDelegate?
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
        containerView.layer.borderColor = EkoColorSet.secondary.blend(.shade4).cgColor
        closeButton.setImage(EkoIconSet.iconClose, for: .normal)
        closeButton.tintColor = EkoColorSet.base.blend(.shade2)
        titleLabel.font = EkoFontSet.bodyBold
        titleLabel.textColor = EkoColorSet.base
        subtitleLabel.font = EkoFontSet.caption
        subtitleLabel.textColor = EkoColorSet.base.blend(.shade1)
        progressView.transform = CGAffineTransform(scaleX: 1, y: 32)
        progressView.progressTintColor = EkoColorSet.secondary.blend(.shade4)
        progressView.trackTintColor = .clear
        progressView.progress = 0.0
        exclamationImageView.image = EkoIconSet.iconExclamation
        exclamationImageView.tintColor = EkoColorSet.baseInverse
        exclamationBackgroundView.backgroundColor = EkoColorSet.secondary.withAlphaComponent(0.7)
        exclamationBackgroundView.layer.cornerRadius = 13
        exclamationBackgroundView.clipsToBounds = true
        errorOverlayView.backgroundColor = EkoColorSet.secondary.blend(.shade4).withAlphaComponent(0.6)
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
    
    func configure(with file: EkoFile, isEditingMode: Bool) {
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
