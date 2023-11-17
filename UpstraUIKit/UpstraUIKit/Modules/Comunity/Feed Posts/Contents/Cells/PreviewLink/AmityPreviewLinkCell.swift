//
//  AmityPreviewLinkCell.swift
//  AmityUIKit
//
//  Created by Zay Yar Htun on 10/17/23.
//  Copyright © 2023 Amity. All rights reserved.
//

import UIKit
import LinkPresentation
import UniformTypeIdentifiers

class AmityPreviewLinkCell: UITableViewCell, Nibbable {

    @IBOutlet weak var previewLinkViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewLinkView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let previewLinkWizard = AmityPreviewLinkWizard.shared
    private var urlToOpen: URL?
    
    @IBOutlet weak var previewLinkImage: UIImageView!
    @IBOutlet weak var previewLinkTitle: UILabel!
    @IBOutlet weak var previewLinkURL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(previewLinkTapped))
        previewLinkView.addGestureRecognizer(gesture)
        
        previewLinkViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.32
        previewLinkView.layer.cornerRadius = 6
        previewLinkView.layer.borderColor = UIColor.lightGray.cgColor
        previewLinkView.layer.borderWidth = 0.5
        previewLinkView.clipsToBounds = true
        previewLinkView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewLinkView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func display(post: AmityPostModel) {
        if let url = previewLinkWizard.detectLinks(input: post.text).first {
            urlToOpen = url
            
            Task { @MainActor in
                if let metadata = await previewLinkWizard.getMetadata(url: url) {
                    
                    previewLinkImage.image = AmityIconSet.Post.emptyPreviewLinkImage
                    
                    previewLinkURL.text = url.host
                    previewLinkURL.textColor = .gray
                    previewLinkURL.font = AmityFontSet.caption
                    
                    previewLinkTitle.text = metadata.title
                    previewLinkTitle.textColor = .black
                    previewLinkTitle.font = AmityFontSet.bodyBold
                    
                    metadata.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] image, error in
                        guard let self else { return }
                        
                        DispatchQueue.main.async {
                            if let image = image as? UIImage {
                                self.previewLinkImage.image = image
                            }
                        }
                    })
                } else {
                    previewLinkImage.image = AmityIconSet.Post.brokenPreviewLinkImage
                    
                    previewLinkURL.text = "Preview not available"
                    previewLinkURL.textColor = .black
                    previewLinkURL.font = AmityFontSet.bodyBold
                    
                    previewLinkTitle.text = "Please make sure the URL is correct and try again."
                    previewLinkTitle.textColor = .gray
                    previewLinkTitle.font = AmityFontSet.body
                }
                
                self.previewLinkView.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc private func previewLinkTapped() {
        guard let urlToOpen else {
            return
        }
        
        UIApplication.shared.open(urlToOpen)
    }
    
}
