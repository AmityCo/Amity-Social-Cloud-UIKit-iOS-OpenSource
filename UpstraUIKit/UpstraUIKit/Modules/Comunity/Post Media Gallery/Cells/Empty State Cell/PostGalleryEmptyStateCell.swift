//
//  PostGalleryEmptyStateCell.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 3/10/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

class PostGalleryEmptyStateCell: UICollectionViewCell, Nibbable {

    @IBOutlet private weak var emptyImageView: UIImageView!
    @IBOutlet private weak var emptyTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(image: UIImage?, text: String) {
        emptyImageView.image = image
        emptyTextLabel.font = AmityFontSet.title
        emptyTextLabel.textColor = AmityColorSet.base.blend(.shade3)
        emptyTextLabel.text = text
    }
    
    static let height: CGFloat = 150

}
