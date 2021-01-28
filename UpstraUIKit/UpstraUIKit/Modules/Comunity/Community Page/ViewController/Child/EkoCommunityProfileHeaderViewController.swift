//
//  EkoCommunityProfileHeaderViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 14/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityProfileHeaderViewController: EkoViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var badgeImageView: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var postsButton: EkoButton!
    @IBOutlet private var membersButton: EkoButton!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var actionButton: EkoButton!
    @IBOutlet private var chatButton: EkoButton!
    @IBOutlet private var actionStackView: UIStackView!
    // MARK: - Properties
    
    private let settings: EkoCommunityProfilePageSettings
    private let screenViewModel: EkoCommunityProfileScreenViewModelType
    
    // MARK: - Callback
    
    // MARK: - View lifecycle
    private init(viewModel: EkoCommunityProfileScreenViewModelType, settings: EkoCommunityProfilePageSettings) {
        self.screenViewModel = viewModel
        self.settings = settings
        super.init(nibName: EkoCommunityProfileHeaderViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    static func make(with viewModel: EkoCommunityProfileScreenViewModelType, settings: EkoCommunityProfilePageSettings) -> EkoCommunityProfileHeaderViewController {
        let vc = EkoCommunityProfileHeaderViewController(viewModel: viewModel, settings: settings)
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
        avatarView.placeholder = EkoIconSet.defaultCommunity
        displayNameLabel.text = ""
        displayNameLabel.font = EkoFontSet.headerLine
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.numberOfLines = 0
    }
    
    private func setupBadgeView() {
        badgeImageView.image = EkoIconSet.iconBadgeCheckmark
        badgeImageView.tintColor = EkoColorSet.highlight
    }
    
    private func setupSubTitleLabel() {
        categoryLabel.text = ""
        categoryLabel.font = EkoFontSet.caption
        categoryLabel.textColor = EkoColorSet.base.blend(.shade1)
        categoryLabel.numberOfLines = 1
    }
    
    private func setupPostButton() {
        let attribute = EkoAttributedString()
        attribute.setBoldFont(for: EkoFontSet.captionBold)
        attribute.setNormalFont(for: EkoFontSet.caption)
        attribute.setColor(for: EkoColorSet.base)
        postsButton.attributedString = attribute
    }
    
    private func setupMemberButton() {
        let attribute = EkoAttributedString()
        attribute.setBoldFont(for: EkoFontSet.captionBold)
        attribute.setNormalFont(for: EkoFontSet.caption)
        attribute.setColor(for: EkoColorSet.base)
        membersButton.attributedString = attribute
        membersButton.addTarget(self, action: #selector(memberTap), for: .touchUpInside)
    }
    
    private func setupDescription() {
        descriptionLabel.text = ""
        descriptionLabel.font = EkoFontSet.body
        descriptionLabel.textColor = EkoColorSet.base
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupActionButton() {
        actionButton.setTitleShadowColor(EkoColorSet.baseInverse, for: .normal)
        actionButton.setTitleFont(EkoFontSet.bodyBold)
        actionButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
    }
    
    private func setupChatButton() {
        chatButton.setImage(EkoIconSet.iconChat, for: .normal)
        chatButton.tintColor = EkoColorSet.secondary
        chatButton.isHidden = true
        chatButton.layer.borderColor = EkoColorSet.secondary.blend(.shade3).cgColor
        chatButton.layer.borderWidth = 1
        chatButton.layer.cornerRadius = 6
        chatButton.addTarget(self, action: #selector(chatTap), for: .touchUpInside)
    }
    
    func update(with community: EkoCommunityModel) {
        avatarView.setImage(withImageId: community.avatarId, placeholder: EkoIconSet.defaultCommunity)
        displayNameLabel.text = community.displayName
        descriptionLabel.text = community.description
        descriptionLabel.isHidden = community.description == ""
        updatePostsCount(with: Int(community.postsCount))
        updateMembersCount(with: Int(community.membersCount))
        categoryLabel.text = community.category
        badgeImageView.isHidden = !community.isOfficial
        updateActionButton()
    }
    
    
    private func updatePostsCount(with postCount: Int) {
        let value = postCount.formatUsingAbbrevation()
        let string = String.localizedStringWithFormat(EkoLocalizedStringSet.communityDetailPostCount.localizedString, value)
        postsButton.attributedString.setTitle(string)
        postsButton.attributedString.setBoldText(for: [value])
        postsButton.setAttributedTitle()
    }
    
    private func updateMembersCount(with memberCount: Int) {
        let value = memberCount.formatUsingAbbrevation()
        let string = String.localizedStringWithFormat(EkoLocalizedStringSet.communityDetailMemberCount.localizedString, value)
        membersButton.attributedString.setTitle(string)
        membersButton.attributedString.setBoldText(for: [value])
        membersButton.setAttributedTitle()
    }
}

// MARK: - Action
private extension EkoCommunityProfileHeaderViewController {
    @objc func actionTap(_ sender: EkoButton) {
        switch screenViewModel.dataSource.getCommunityJoinStatus {
        case .notJoin:
            EkoHUD.show(.loading)
            screenViewModel.action.joinCommunity()
        case .joinNotCreator:
            break
        case .joinAndCreator:
            screenViewModel.action.route(.editProfile)
        }
    }
    
    @objc func chatTap() {
        EkoEventHandler.shared.communityChannelDidTap(from: self, channelId: screenViewModel.dataSource.communityId)
    }
    
    @objc func memberTap() {
        screenViewModel.action.route(.member)
    }
}

private extension EkoCommunityProfileHeaderViewController {
    func updateActionButton() {
        #warning("UI-Adjustment")
        // As the requirement has been change. I have to added temporary logic for hide some components
        // See more: https://ekoapp.atlassian.net/browse/UKT-737
        
        switch screenViewModel.dataSource.getCommunityJoinStatus {
        case .notJoin:
            chatButton.isHidden = true
            actionButton.setTitle(EkoLocalizedStringSet.communityDetailJoinButton.localizedString, for: .normal)
            actionButton.setImage(EkoIconSet.iconAdd, position: .left)
            actionButton.tintColor = EkoColorSet.baseInverse
            actionButton.backgroundColor = EkoColorSet.primary
            actionButton.layer.cornerRadius = 4
            actionButton.tag = 0
            actionButton.isHidden = false
        case .joinNotCreator:
            chatButton.isHidden = settings.shouldChatButtonHide
            actionButton.setTitle(EkoLocalizedStringSet.communityDetailMessageButton.localizedString, for: .normal)
            actionButton.setImage(EkoIconSet.iconChat, position: .left)
            actionButton.tintColor = EkoColorSet.secondary
            actionButton.backgroundColor = EkoColorSet.backgroundColor
            actionButton.layer.borderColor = EkoColorSet.secondary.blend(.shade3).cgColor
            actionButton.layer.borderWidth = 1
            actionButton.layer.cornerRadius = 4
            actionButton.tag = 1
            actionButton.isHidden = true
        case .joinAndCreator:
            chatButton.isHidden = settings.shouldChatButtonHide
            actionButton.setTitle(EkoLocalizedStringSet.communityDetailEditProfileButton.localizedString, for: .normal)
            actionButton.setImage(EkoIconSet.iconEdit, position: .left)
            actionButton.tintColor = EkoColorSet.secondary
            actionButton.backgroundColor = EkoColorSet.backgroundColor
            actionButton.layer.borderColor = EkoColorSet.secondary.blend(.shade3).cgColor
            actionButton.layer.borderWidth = 1
            actionButton.layer.cornerRadius = 4
            actionButton.tag = 2
            actionButton.isHidden = false
        }
        actionStackView.isHidden = chatButton.isHidden && actionButton.isHidden
    }
}
