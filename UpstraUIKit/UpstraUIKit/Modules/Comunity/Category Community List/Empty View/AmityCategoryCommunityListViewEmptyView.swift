//
//  AmityCategoryCommunityListViewEmptyView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 16/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

class AmityCategoryCommunityListViewEmptyView: AmityView {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    // MARK: - Properties
    var exploreHandler: (() -> Void)?
    var createHandler: (() -> Void)?
    
    override func initial() {
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        
        imageView.image = AmityIconSet.emptyNewsfeed
        titleLabel.text = AmityLocalizedStringSet.emptyNewsfeedTitle.localizedString
        titleLabel.textColor = AmityColorSet.base.blend(.shade2)
        titleLabel.font = AmityFontSet.headerLine
        
        subtitleLabel.text = AmityLocalizedStringSet.emptyNewsfeedSubtitle.localizedString
        subtitleLabel.textColor = AmityColorSet.base.blend(.shade2)
        subtitleLabel.font = AmityFontSet.body
    }
    
}
