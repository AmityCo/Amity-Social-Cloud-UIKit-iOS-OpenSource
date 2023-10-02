//
//  AmityNewsfeedEmptyView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 24/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

final class AmityNewsfeedEmptyView: AmityView {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var exploreCommunityButton: AmityButton!
    @IBOutlet private var createCommunityButton: AmityButton!
    
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
        
        exploreCommunityButton.setTitle(AmityLocalizedStringSet.emptyNewsfeedExploreButton.localizedString, for: .normal)
        exploreCommunityButton.setTitleFont(AmityFontSet.bodyBold)
        exploreCommunityButton.setTitleColor(AmityColorSet.baseInverse, for: .normal)
        exploreCommunityButton.backgroundColor = AmityColorSet.primary
        exploreCommunityButton.setImage(AmityIconSet.iconSearch, position: .left)
        exploreCommunityButton.tintColor = AmityColorSet.baseInverse
        exploreCommunityButton.contentEdgeInsets = .init(top: 0, left: 30, bottom: 0, right: 30)
        exploreCommunityButton.layer.cornerRadius = 4
        
        createCommunityButton.setTitle(AmityLocalizedStringSet.emptyNewsfeedCreateButton.localizedString, for: .normal)
        createCommunityButton.setTitleFont(AmityFontSet.body)
        createCommunityButton.setTitleColor(AmityColorSet.primary, for: .normal)
        createCommunityButton.setTitleColor(AmityColorSet.primary.blend(.shade2), for: .disabled)
        createCommunityButton.isEnabled = Reachability.shared.isConnectedToNetwork
    }
    
    func setNeedsUpdateState() {
        createCommunityButton.isEnabled = Reachability.shared.isConnectedToNetwork
    }
    
}

// MARK: - Action
private extension AmityNewsfeedEmptyView {
    @IBAction func exploreCommunityTap() {
        exploreHandler?()
    }
    
    @IBAction func createCommunityTap() {
        createHandler?()
    }
}
