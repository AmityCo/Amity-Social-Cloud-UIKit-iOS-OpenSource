//
//  EkoNewsfeedEmptyView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 24/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoNewsfeedEmptyView: EkoView {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var exploreCommunityButton: EkoButton!
    @IBOutlet private var createCommunityButton: EkoButton!
    
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
        titleLabel.text = EkoLocalizedStringSet.emptyNewsfeedTitle
        titleLabel.textColor = EkoColorSet.base.blend(.shade2)
        titleLabel.font = EkoFontSet.headerLine
        
        subtitleLabel.text = EkoLocalizedStringSet.emptyNewsfeedSubtitle
        subtitleLabel.textColor = EkoColorSet.base.blend(.shade2)
        subtitleLabel.font = EkoFontSet.body
        
        exploreCommunityButton.setTitle(EkoLocalizedStringSet.emptyNewsfeedExploreButton, for: .normal)
        exploreCommunityButton.setTitleFont(EkoFontSet.bodyBold)
        exploreCommunityButton.setTitleColor(EkoColorSet.baseInverse, for: .normal)
        exploreCommunityButton.backgroundColor = EkoColorSet.primary
        exploreCommunityButton.setImage(EkoIconSet.iconSearch, position: .left)
        exploreCommunityButton.tintColor = EkoColorSet.baseInverse
        exploreCommunityButton.contentEdgeInsets = .init(top: 0, left: 30, bottom: 0, right: 30)
        exploreCommunityButton.layer.cornerRadius = 4
        
        createCommunityButton.setTitle(EkoLocalizedStringSet.emptyNewsfeedCreateButton, for: .normal)
        createCommunityButton.setTitleFont(EkoFontSet.body)
        createCommunityButton.setTitleColor(EkoColorSet.primary, for: .normal)
    }
    
}

// MARK: - Action
private extension EkoNewsfeedEmptyView {
    @IBAction func exploreCommunityTap() {
        exploreHandler?()
    }
    
    @IBAction func createCommunityTap() {
        createHandler?()
    }
}
