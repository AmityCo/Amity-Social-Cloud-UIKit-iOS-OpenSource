//
//  AmityImageView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 18/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK
import UIKit

public enum AmityImageViewState {
    case idle
    case loading
}

public class AmityImageView: AmityView {

    @IBOutlet internal weak var imageView: UIImageView!
    @IBOutlet internal weak var placeHolderImageView: UIImageView!
    @IBOutlet internal weak var overlayView: UIView!
    @IBOutlet internal weak var activityIndicator: UIActivityIndicatorView!
    
    private var session = UUID().uuidString
    
    public var actionHandler: (() -> Void)?
    public var state: AmityImageViewState = .idle {
        didSet {
            updateState()
        }
    }
    
    /// The image displayed in the image view
    public var image: UIImage? {
        get {
            return imageView.image
        } set {
            imageView.image = newValue
            placeHolderImageView.isHidden = image != nil
            overlayView.isHidden = true
        }
    }
    
    public var placeholder: UIImage? = AmityIconSet.defaultAvatar {
        didSet {
            placeHolderImageView.image = placeholder
        }
    }
    
    public override var contentMode: UIView.ContentMode {
        didSet {
            imageView?.contentMode = contentMode
            placeHolderImageView?.contentMode = contentMode
        }
    }
    
    // MARK: - View lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        setupTapGesture()
        setupImageView()
        setupOverlayView()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarViewTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
    }
    
    private func setupOverlayView() {
//        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        overlayView.backgroundColor = .red
        overlayView.isHidden = true
        activityIndicator.style = .medium
    }
    
    private func updateState() {
        if state == .loading {
            overlayView.isHidden = false
            activityIndicator.startAnimating()
        } else {
            overlayView.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Action
    @objc private func avatarViewTap(_ sender: UIGestureRecognizer) {
        actionHandler?()
    }
    
    public func setImage(withImageURL imageURL: String?,
                         size: AmityMediaSize = .small,
                         placeholder: UIImage? = AmityIconSet.defaultAvatar,
                         completion: (() -> Void)? = nil) {
        image = nil
        self.placeholder = placeholder
        session = UUID().uuidString

        guard let imageURL = imageURL, !imageURL.isEmpty else { return }
        let _session = session

        // Wrap our request in a work item
        AmityUIKitManagerInternal.shared.fileService.loadImage(imageURL: imageURL, size: size) { [weak self] result in
            switch result {
            case .success(let image):
                // To prevent diplaying the wrong image after cell is dequeued.
                guard self?.session == _session else {
                    // Cell has already dequeue.
                    return
                }
                self?.image = image
                completion?()
            case .failure:
                self?.image = nil
                break
            }
        }
    }

}
