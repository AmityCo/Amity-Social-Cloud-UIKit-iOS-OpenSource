//
//  AmityPendingPostsEmptyView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 21/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPendingPostsEmptyView: AmityView {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!

    override func initial() {
        loadNibContent()
        contentView.backgroundColor = AmityColorSet.backgroundColor
        setupDescriptionLabel()
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = AmityLocalizedStringSet.PendingPosts.emptyTitle.localizedString
        descriptionLabel.font = AmityFontSet.title
        descriptionLabel.textColor = AmityColorSet.base.blend(.shade3)
    }
}
