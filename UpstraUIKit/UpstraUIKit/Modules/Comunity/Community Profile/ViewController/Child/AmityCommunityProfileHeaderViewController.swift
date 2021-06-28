//
//  AmityCommunityProfileHeaderViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 14/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityCommunityProfileHeaderViewController: AmityViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var privateBadgeImageView: UIImageView!
    @IBOutlet private var officialBadgeImageView: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var postsButton: AmityButton!
    @IBOutlet private var membersButton: AmityButton!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var actionButton: AmityButton!
    @IBOutlet private var chatButton: AmityButton!
    @IBOutlet private var actionStackView: UIStackView!
    // MARK: - Properties
    
    private let settings: AmityCommunityProfilePageSettings
    private let screenViewModel: AmityCommunityProfileScreenViewModelType
    
    // MARK: - Callback
    
    // MARK: - View lifecycle
    private init(viewModel: AmityCommunityProfileScreenViewModelType, settings: AmityCommunityProfilePageSettings) {
        self.screenViewModel = viewModel
        self.settings = settings
        super.init(nibName: AmityCommunityProfileHeaderViewController.identifier, bundle: AmityUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    static func make(with viewModel: AmityCommunityProfileScreenViewModelType, settings: AmityCommunityProfilePageSettings) -> AmityCommunityProfileHeaderViewController {
        let vc = AmityCommunityProfileHeaderViewController(viewModel: viewModel, settings: settings)
        return vc
    }
    
    private func setupView() {
        setupDisplayName()
        setupBadgeView()
        setupSubTitleLabel()
        setupPostButton()
        setupMemberButton()
        setupDescription()
        setupActionButton()
        setupChatButton()
    }
    
    private func setupDisplayName() {
        avatarView.placeholder = AmityIconSet.defaultCommunity
        displayNameLabel.text = ""
        displayNameLabel.font = AmityFontSet.headerLine
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.numberOfLines = 0
    }
    
    private func setupBadgeView() {
        privateBadgeImageView.image = AmityIconSet.iconPrivate
        privateBadgeImageView.tintColor = AmityColorSet.base
        privateBadgeImageView.isHidden = true
        privateBadgeImageView.image = AmityIconSet.iconPrivate
        officialBadgeImageView.image = AmityIconSet.iconBadgeCheckmark
        officialBadgeImageView.tintColor = AmityColorSet.highlight
        officialBadgeImageView.isHidden = true
    }
    
    private func setupSubTitleLabel() {
        categoryLabel.text = ""
        categoryLabel.font = AmityFontSet.caption
        categoryLabel.textColor = AmityColorSet.base.blend(.shade1)
        categoryLabel.numberOfLines = 1
    }
    
    private func setupPostButton() {
        let attribute = AmityAttributedString()
        attribute.setBoldFont(for: AmityFontSet.captionBold)
        attribute.setNormalFont(for: AmityFontSet.caption)
        attribute.setColor(for: AmityColorSet.base)
        postsButton.attributedString = attribute
    }
    
    private func setupMemberButton() {
        let attribute = AmityAttributedString()
        attribute.setBoldFont(for: AmityFontSet.captionBold)
        attribute.setNormalFont(for: AmityFontSet.caption)
        attribute.setColor(for: AmityColorSet.base)
        membersButton.attributedString = attribute
        membersButton.addTarget(self, action: #selector(memberTap), for: .touchUpInside)
    }
    
    private func setupDescription() {
        descriptionLabel.text = ""
        descriptionLabel.font = AmityFontSet.body
        descriptionLabel.textColor = AmityColorSet.base
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupActionButton() {
        actionButton.setTitleShadowColor(AmityColorSet.baseInverse, for: .normal)
        actionButton.setTitleFont(AmityFontSet.bodyBold)
        actionButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
    }
    
    private func setupChatButton() {
        chatButton.setImage(AmityIconSet.iconChat, for: .normal)
        chatButton.tintColor = AmityColorSet.secondary
        chatButton.isHidden = true
        chatButton.layer.borderColor = AmityColorSet.secondary.blend(.shade3).cgColor
        chatButton.layer.borderWidth = 1
        chatButton.layer.cornerRadius = 6
        chatButton.addTarget(self, action: #selector(chatTap), for: .touchUpInside)
    }
    
    func update(with community: AmityCommunityModel) {
        avatarView.setImage(withImageURL: community.avatarURL, placeholder: AmityIconSet.defaultCommunity)
        displayNameLabel.text = community.displayName
        descriptionLabel.text = community.description
        descriptionLabel.isHidden = community.description == ""
        updatePostsCount(with: Int(community.postsCount))
        updateMembersCount(with: Int(community.membersCount))
        categoryLabel.text = community.category
        privateBadgeImageView.isHidden = community.isPublic
        officialBadgeImageView.isHidden = !community.isOfficial
        updateActionButton()
    }
    
    
    private func updatePostsCount(with postCount: Int) {
        let value = postCount.formatUsingAbbrevation()
        let string = String.localizedStringWithFormat(AmityLocalizedStringSet.communityDetailPostCount.localizedString, value)
        postsButton.attributedString.setTitle(string)
        postsButton.attributedString.setBoldText(for: [value])
        postsButton.setAttributedTitle()
    }
    
    private func updateMembersCount(with memberCount: Int) {
        let value = memberCount.formatUsingAbbrevation()
        let string = String.localizedStringWithFormat(AmityLocalizedStringSet.communityDetailMemberCount.localizedString, value)
        membersButton.attributedString.setTitle(string)
        membersButton.attributedString.setBoldText(for: [value])
        membersButton.setAttributedTitle()
    }
}

// MARK: - Action
private extension AmityCommunityProfileHeaderViewController {
    @objc func actionTap(_ sender: AmityButton) {
        switch screenViewModel.dataSource.getCommunityJoinStatus {
        case .notJoin:
            AmityHUD.show(.loading)
            screenViewModel.action.joinCommunity()
        case .joinNotCreator:
            break
        case .joinAndCreator:
            screenViewModel.action.route(.editProfile)
        }
    }
    
    @objc func chatTap() {
        AmityEventHandler.shared.communityChannelDidTap(from: self, channelId: screenViewModel.dataSource.communityId)
    }
    
    @objc func memberTap() {
        screenViewModel.action.route(.member)
    }
}

private extension AmityCommunityProfileHeaderViewController {
    func updateActionButton() {
        #warning("UI-Adjustment")
        // As the requirement has been change. I have to added temporary logic for hide some components
        // See more: https://ekoapp.atlassian.net/browse/UKT-737
        
        switch screenViewModel.dataSource.getCommunityJoinStatus {
        case .notJoin:
            chatButton.isHidden = true
            actionButton.setTitle(AmityLocalizedStringSet.communityDetailJoinButton.localizedString, for: .normal)
            actionButton.setImage(AmityIconSet.iconAdd, position: .left)
            actionButton.tintColor = AmityColorSet.baseInverse
            actionButton.backgroundColor = AmityColorSet.primary
            actionButton.layer.cornerRadius = 4
            actionButton.tag = 0
            actionButton.isHidden = false
        case .joinNotCreator:
            chatButton.isHidden = settings.shouldChatButtonHide
            actionButton.setTitle(AmityLocalizedStringSet.communityDetailMessageButton.localizedString, for: .normal)
            actionButton.setImage(AmityIconSet.iconChat, position: .left)
            actionButton.tintColor = AmityColorSet.secondary
            actionButton.backgroundColor = AmityColorSet.backgroundColor
            actionButton.layer.borderColor = AmityColorSet.secondary.blend(.shade3).cgColor
            actionButton.layer.borderWidth = 1
            actionButton.layer.cornerRadius = 4
            actionButton.tag = 1
            actionButton.isHidden = true
        case .joinAndCreator:
            chatButton.isHidden = settings.shouldChatButtonHide
            actionButton.setTitle(AmityLocalizedStringSet.communityDetailEditProfileButton.localizedString, for: .normal)
            actionButton.setImage(AmityIconSet.iconEdit, position: .left)
            actionButton.tintColor = AmityColorSet.secondary
            actionButton.backgroundColor = AmityColorSet.backgroundColor
            actionButton.layer.borderColor = AmityColorSet.secondary.blend(.shade3).cgColor
            actionButton.layer.borderWidth = 1
            actionButton.layer.cornerRadius = 4
            actionButton.tag = 2
            actionButton.isHidden = false
        }
        actionStackView.isHidden = chatButton.isHidden && actionButton.isHidden
    }
}
