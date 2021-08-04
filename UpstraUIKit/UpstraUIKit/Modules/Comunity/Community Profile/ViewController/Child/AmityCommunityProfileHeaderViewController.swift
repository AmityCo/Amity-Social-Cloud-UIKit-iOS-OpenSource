//
//  AmityCommunityProfileHeaderViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 20/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
//import AmitySDK

final class AmityCommunityProfileHeaderViewController: UIViewController {

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
    
    @IBOutlet private var pendingPostsStatusView: UIView!
    @IBOutlet private var pendingPostsContainerView: UIView!
    @IBOutlet private var pendingPostsTitleLabel: UILabel!
    @IBOutlet private var pendingPostsDescriptionLabel: UILabel!
    
    // MARK: - Properties
    private var settings: AmityCommunityProfilePageSettings!
    private var screenViewModel: AmityCommunityProfileScreenViewModelType!
    private weak var rootViewController: AmityCommunityProfilePageViewController?
    
    // MARK: - Callback
    var didUpdatePostBanner: (() -> Void)?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDisplayName()
        setupBadgeView()
        setupSubTitleLabel()
        setupPostButton()
        setupMemberButton()
        setupDescription()
        setupActionButton()
        setupPendingPosts()
    }
    
    static func make(rootViewController: AmityCommunityProfilePageViewController?, viewModel: AmityCommunityProfileScreenViewModelType, settings: AmityCommunityProfilePageSettings) -> AmityCommunityProfileHeaderViewController {
        let vc = AmityCommunityProfileHeaderViewController(nibName: AmityCommunityProfileHeaderViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.rootViewController = rootViewController
        vc.screenViewModel = viewModel
        vc.settings = settings
        return vc
    }
    
    // MARK: - Setup views
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
        let title = String.localizedStringWithFormat(AmityLocalizedStringSet.Unit.commentPlural.localizedString, "0")
        let attribute = AmityAttributedString()
        attribute.setBoldFont(for: AmityFontSet.captionBold)
        attribute.setNormalFont(for: AmityFontSet.caption)
        attribute.setColor(for: AmityColorSet.base)
        attribute.setTitle(title)
        postsButton.attributedString = attribute
        postsButton.setAttributedTitle()
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
        actionButton.isHidden = true
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
    
    private func setupPendingPosts() {
        pendingPostsContainerView.isHidden = true
        pendingPostsContainerView.layer.cornerRadius = 4
        pendingPostsContainerView.backgroundColor = AmityColorSet.base.blend(.shade4)
        
        pendingPostsStatusView.backgroundColor = AmityColorSet.primary
        pendingPostsStatusView.layer.cornerRadius = pendingPostsStatusView.frame.height / 2
        
        pendingPostsTitleLabel.text = AmityLocalizedStringSet.PendingPosts.statusTitle.localizedString
        pendingPostsTitleLabel.font = AmityFontSet.bodyBold
        pendingPostsTitleLabel.textColor = AmityColorSet.base
        
        pendingPostsDescriptionLabel.font = AmityFontSet.caption
        pendingPostsDescriptionLabel.textColor = AmityColorSet.base.blend(.shade1)
    }
    
    // MARK: - Update views
    func updateView() {

        guard let community = screenViewModel.dataSource.community else { return }
        avatarView.setImage(withImageURL: community.avatarURL, placeholder: AmityIconSet.defaultCommunity)
        displayNameLabel.text = community.displayName
        descriptionLabel.text = community.description
        descriptionLabel.isHidden = community.description == ""
        updateMembersCount(with: Int(community.membersCount))
        categoryLabel.text = community.category
        privateBadgeImageView.isHidden = community.isPublic
        officialBadgeImageView.isHidden = !community.isOfficial
        updateActionButton()
        shouldShowPendingsPostBanner()
    }
    
    func updatePostsCount() {
        let postCount = screenViewModel.dataSource.postCount
        let format = postCount == 1 ? AmityLocalizedStringSet.Unit.postSingular.localizedString : AmityLocalizedStringSet.Unit.postPlural.localizedString
        let value = postCount.formatUsingAbbrevation()
        let string = String.localizedStringWithFormat(format, value)
        postsButton.attributedString.setTitle(string)
        postsButton.attributedString.setBoldText(for: [value])
        postsButton.setAttributedTitle()
    }
    
    private func updateMembersCount(with memberCount: Int) {
        let format = memberCount == 1 ? AmityLocalizedStringSet.Unit.memberSingular.localizedString : AmityLocalizedStringSet.Unit.memberPlural.localizedString
        let value = memberCount.formatUsingAbbrevation()
        let string = String.localizedStringWithFormat(format, value)
        membersButton.attributedString.setTitle(string)
        membersButton.attributedString.setBoldText(for: [value])
        membersButton.setAttributedTitle()
    }
    
    private func updateActionButton() {
        switch screenViewModel.dataSource.memberStatusCommunity {
        case .guest:
            chatButton.isHidden = true
            actionButton.setTitle(AmityLocalizedStringSet.communityDetailJoinButton.localizedString, for: .normal)
            actionButton.setImage(AmityIconSet.iconAdd, position: .left)
            actionButton.tintColor = AmityColorSet.baseInverse
            actionButton.backgroundColor = AmityColorSet.primary
            actionButton.layer.cornerRadius = 4
            actionButton.tag = 0
            actionButton.isHidden = false
        case .member:
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
        case .admin:
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
    
    private func shouldShowPendingsPostBanner() {
        switch screenViewModel.dataSource.memberStatusCommunity {
        case .guest:
            pendingPostsContainerView.isHidden = true
        case .member:
            screenViewModel.dataSource.shouldShowPendingPostBannerForMember { [weak self] shouldShowPendingPostBanner in
                self?.pendingPostsContainerView.isHidden = !shouldShowPendingPostBanner
                self?.pendingPostsDescriptionLabel.text = AmityLocalizedStringSet.PendingPosts.statusMemberDesc.localizedString
                self?.didUpdatePostBanner?()
            }
        case .admin:
            let pendingPostCount = screenViewModel.dataSource.pendingPostCountForAdmin
            pendingPostsContainerView.isHidden = pendingPostCount == 0
            pendingPostsDescriptionLabel.text = String.localizedStringWithFormat(AmityLocalizedStringSet.PendingPosts.statusAdminDesc.localizedString, pendingPostCount)
            didUpdatePostBanner?()
        }
    }
    
}

// MARK: - Action
private extension AmityCommunityProfileHeaderViewController {
    
    @objc func actionTap(_ sender: AmityButton) {
        switch screenViewModel.dataSource.memberStatusCommunity {
        case .guest:
            AmityHUD.show(.loading)
            screenViewModel.action.joinCommunity()
        case .member:
            break
        case .admin:
            screenViewModel.action.route(.editProfile)
        }
    }
    
    @objc func chatTap() {
        guard let rootViewController = rootViewController else { return }
        AmityEventHandler.shared.communityChannelDidTap(from: rootViewController, channelId: screenViewModel.dataSource.communityId)
    }
    
    @objc func memberTap() {
        screenViewModel.action.route(.member)
    }
    
    @IBAction func pendingPostsTap() {
        screenViewModel.action.route(.pendingPosts)
    }
}
