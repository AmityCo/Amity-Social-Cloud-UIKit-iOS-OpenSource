//
//  AmityPendingPostsHeaderView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 21/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPendingPostsHeaderView: AmityView {

    @IBOutlet private var titleLabel: UILabel!
    
    override func initial() {
        loadNibContent()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = AmityLocalizedStringSet.PendingPosts.headerTitle.localizedString
        titleLabel.font = AmityFontSet.caption
        titleLabel.textColor = AmityColorSet.base.blend(.shade1)
        titleLabel.numberOfLines = 0
    }
}
