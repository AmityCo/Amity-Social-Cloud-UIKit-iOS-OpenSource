//
//  AmityIconView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityIconView: AmityView {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - Properties
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var backgroundIcon: UIColor? = AmityColorSet.base.blend(.shade4) {
        didSet {
            containerView.backgroundColor = backgroundIcon
        }
    }
    
    override func initial() {
        loadNibContent()
        setupView()
    }
    
    // MARK: - Setup view
    private func setupView() {
        containerView.backgroundColor = backgroundIcon
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
    }

}
