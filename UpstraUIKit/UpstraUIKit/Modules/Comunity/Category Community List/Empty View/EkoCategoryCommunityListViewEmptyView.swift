//
//  EkoCategoryCommunityListViewEmptyView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 16/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

class EkoCategoryCommunityListViewEmptyView: EkoView {
    
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
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        
        imageView.image = EkoIconSet.emptyNewsfeed
        titleLabel.text = EkoLocalizedStringSet.emptyNewsfeedTitle.localizedString
        titleLabel.textColor = EkoColorSet.base.blend(.shade2)
        titleLabel.font = EkoFontSet.headerLine
        
        subtitleLabel.text = EkoLocalizedStringSet.emptyNewsfeedSubtitle.localizedString
        subtitleLabel.textColor = EkoColorSet.base.blend(.shade2)
        subtitleLabel.font = EkoFontSet.body
    }
    
}
