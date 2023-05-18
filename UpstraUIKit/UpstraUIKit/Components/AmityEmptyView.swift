//
//  AmityEmptyView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 16/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

class AmityEmptyView: AmityView {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    override func initial() {
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        contentView.backgroundColor = AmityColorSet.backgroundColor
        titleLabel.text = ""
        titleLabel.font = AmityFontSet.title
        titleLabel.textColor = AmityColorSet.base.blend(.shade3)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        subtitleLabel.text = ""
        subtitleLabel.font = AmityFontSet.caption
        subtitleLabel.textColor = AmityColorSet.base.blend(.shade2)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
    }
    
    func update(title: String, subtitle: String?,  image: UIImage?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = image
        imageView.isHidden = image == nil
    }

}
