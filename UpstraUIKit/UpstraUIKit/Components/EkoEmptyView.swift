//
//  EkoEmptyView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 16/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

class EkoEmptyView: EkoView {

    // MARK: - IBOutlet Properties
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    override func initial() {
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        titleLabel.text = ""
        titleLabel.font = EkoFontSet.title
        titleLabel.textColor = EkoColorSet.base.blend(.shade3)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        subtitleLabel.text = ""
        subtitleLabel.font = EkoFontSet.headerLine
        subtitleLabel.textColor = EkoColorSet.base
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
