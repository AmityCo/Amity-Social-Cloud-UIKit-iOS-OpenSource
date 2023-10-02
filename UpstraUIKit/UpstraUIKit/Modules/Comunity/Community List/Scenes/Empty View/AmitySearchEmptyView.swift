//
//  AmitySearchEmptyView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmitySearchEmptyView: AmityView {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var topConstrant: NSLayoutConstraint!
    
    var topMargin: CGFloat = 20 {
        didSet {
            topConstrant.constant = topMargin
        }
    }
    
    override func initial() {
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        titleLabel.text = AmityLocalizedStringSet.searchResultNotFound.localizedString
        titleLabel.textColor = AmityColorSet.base.blend(.shade3)
        titleLabel.font = AmityFontSet.title
        titleLabel.textAlignment = .center
    }
}
