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
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var postsButton: EkoButton!
    @IBOutlet private var membersButton: EkoButton!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var actionButton: EkoButton!
    @IBOutlet private var chatButton: EkoButton!
    @IBOutlet private var actionStackView: UIStackView!
    // MARK: - Properties
    private let screenViewModel: EkoCommunityProfileScreenViewModelType
    
    // MARK: - Callback
    
    // MARK: - View lifecycle
    private init(viewModel: EkoCommunityProfileScreenViewModelType) {
        self.screenViewModel = viewModel
        super.init(nibName: EkoCommunityProfileHeaderViewController.identifier, bundle: UpstraUIKit.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
    }
    
    static func make(with viewModel: EkoCommunityProfileScreenViewModelType) -> EkoCommunityProfileHeaderViewController {
        let vc = EkoCommunityProfileHeaderViewController(viewModel: viewModel)
        return vc
    }
    
    private func setupView() {
        setupDisplayName()
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
    
    private func setupSubTitleLabel() {
        categoryLabel.text = ""
        categoryLabel.font = EkoFontSet.caption
        categoryLabel.textColor = EkoColorSet.base.blend(.shade1)
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
        chatButton.setImage(EkoIconSet.iconChat2, for: .normal)
        chatButton.tintColor = EkoColorSet.secondary
        chatButton.isHidden = true
        chatButton.layer.borderColor = EkoColorSet.base.blend(.shade3).cgColor
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
        
        displayNameLabel.setImageWithText(position: .both(imageLeft: community.isPublic ? nil:EkoIconSet.iconPrivate, imageRight: community.isOfficial ? EkoIconSet.iconBadgeCheckmark:nil))
    }
    
    
    private func updatePostsCount(with postCount: Int) {
        let value = postCount.formatUsingAbbrevation()
        let string = String.localizedStringWithFormat(EkoLocalizedStringSet.communityDetailPostCount, value)
        postsButton.attributedString.setTitle(string)
        postsButton.attributedString.setBoldText(for: [value])
        postsButton.setAttributedTitle()
    }
    
    private func updateMembersCount(with memberCount: Int) {
        let value = memberCount.formatUsingAbbrevation()
        let string = String.localizedStringWithFormat(EkoLocalizedStringSet.communityDetailMemberCount, value)
        membersButton.attributedString.setTitle(string)
        membersButton.attributedString.setBoldText(for: [value])
        membersButton.setAttributedTitle()
    }
}

private extension EkoCommunityProfileHeaderViewController {
    @objc func actionTap(_ sender: EkoButton) {
        switch screenViewModel.dataSource.currentCommunityStatus(tag: sender.tag) {
        case .notJoin:
            screenViewModel.action.join()
        case .joinNotCreator:
            break
        case .joinAndCreator:
            screenViewModel.action.route(to: .editProfile)
        }
    }
    
    @objc func chatTap() {
        //        buttonTapHandler?(.chat)
    }
    
    @objc func memberTap() {
        screenViewModel.action.route(to: .member)
    }
}

// MARK: - Binding ViewModel
private extension EkoCommunityProfileHeaderViewController {
    func bindingViewModel() {
        #warning("UI-Adjustment")
        // As the requirement has been change. I have to added temporary logic for hide some components
        // See more: https://ekoapp.atlassian.net/browse/UKT-737
        screenViewModel.dataSource.childCommunityStatus.bind { [weak self] (status) in
            guard let strongSelf = self else { return }
            switch status {
            case .notJoin:
                strongSelf.chatButton.isHidden = true
                strongSelf.actionButton.setTitle(EkoLocalizedStringSet.communityDetailJoinButton, for: .normal)
                strongSelf.actionButton.setImage(EkoIconSet.iconAdd, position: .left)
                strongSelf.actionButton.tintColor = EkoColorSet.baseInverse
                strongSelf.actionButton.backgroundColor = EkoColorSet.primary
                strongSelf.actionButton.layer.cornerRadius = 4
                strongSelf.actionButton.tag = 0
                strongSelf.actionButton.isHidden = false
            case .joinNotCreator:
                strongSelf.chatButton.isHidden = true
                strongSelf.actionButton.setTitle(EkoLocalizedStringSet.communityDetailMessageButton, for: .normal)
                strongSelf.actionButton.setImage(EkoIconSet.iconChat2, position: .left)
                strongSelf.actionButton.tintColor = EkoColorSet.secondary
                strongSelf.actionButton.backgroundColor = .white
                strongSelf.actionButton.layer.borderColor = EkoColorSet.base.blend(.shade3).cgColor
                strongSelf.actionButton.layer.borderWidth = 1
                strongSelf.actionButton.layer.cornerRadius = 4
                strongSelf.actionButton.tag = 1
                strongSelf.actionButton.isHidden = true
            case .joinAndCreator:
                strongSelf.chatButton.isHidden = true
                strongSelf.actionButton.setTitle(EkoLocalizedStringSet.communityDetailEditProfileButton, for: .normal)
                strongSelf.actionButton.setImage(EkoIconSet.iconEdit, position: .left)
                strongSelf.actionButton.tintColor = EkoColorSet.secondary
                strongSelf.actionButton.backgroundColor = .white
                strongSelf.actionButton.layer.borderColor = EkoColorSet.base.blend(.shade3).cgColor
                strongSelf.actionButton.layer.borderWidth = 1
                strongSelf.actionButton.layer.cornerRadius = 4
                strongSelf.actionButton.tag = 2
                strongSelf.actionButton.isHidden = false
            }
            strongSelf.actionStackView.isHidden = strongSelf.chatButton.isHidden && strongSelf.actionButton.isHidden
        }
    }
}
