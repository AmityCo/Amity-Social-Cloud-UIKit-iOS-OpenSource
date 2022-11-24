//
//  AmityPostHeaderTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/5/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

/// `AmityPostHeaderTableViewCell` for providing a header of `Post`
public final class AmityPostHeaderTableViewCell: UITableViewCell, Nibbable, AmityPostHeaderProtocol {
    public weak var delegate: AmityPostHeaderDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: AmityFeedDisplayNameLabel!
    @IBOutlet private var badgeStackView: UIStackView!
    @IBOutlet private var badgeIconImageView: UIImageView!
    @IBOutlet private var badgeLabel: UILabel!
    @IBOutlet private var datetimeLabel: UILabel!
    @IBOutlet private var optionButton: UIButton!
    @IBOutlet private var pinIconImageView: UIImageView!

    private(set) public var post: AmityPostModel?
    private var userBadge: UserBadge?
    private(set) public var currentUserBadge: UserBadge.BadgeProfile?
    
    private var badgeIcon: UIImage? = nil
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupRole()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.placeholder = AmityIconSet.defaultAvatar
        badgeIcon = nil
    }
    
    public func display(post: AmityPostModel) {
        self.post = post
//        avatarView.setImage(withImageURL: post.postedUser?.avatarURL, placeholder: AmityIconSet.defaultAvatar)
        
        /// Setup Role
        for role in post.postUserRole {
            guard let profile = userBadge?.groupProfile else { return }
            for badge in profile {
                if role == badge.role {
                    if badge.enable ?? false {
                        loadImage(with: badge.profile?.first?.badgeIcon ?? "", placeholder: UIImage())
                        guard let currentProfile = badge.profile else { return }
                        currentUserBadge = currentProfile.first!
                    }
                }
            }
        }
        
        if !( (post.postedUser?.customAvatarURL ?? "").isEmpty) {
            avatarView.setImage(withCustomURL: post.postedUser?.customAvatarURL,
                                         placeholder: AmityIconSet.defaultAvatar)
        } else {
            avatarView.setImage(withImageURL: post.postedUser?.avatarURL,
                                         placeholder: AmityIconSet.defaultAvatar)
        }
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }

        displayNameLabel.configure(displayName: post.displayName,
                                   communityName: post.targetCommunity?.displayName,
                                   isOfficial: post.targetCommunity?.isOfficial ?? false,
                                   shouldShowCommunityName: post.appearance.shouldShowCommunityName, shouldShowBannedSymbol: post.postedUser?.isGlobalBan ?? false, badgeIcon: badgeIcon)
        displayNameLabel.delegate = self
        datetimeLabel.text = post.subtitle

        switch post.feedType {
        case .reviewing:
            optionButton.isHidden = !post.isOwner
        default:
            optionButton.isHidden = !(post.appearance.shouldShowOption && post.isCommentable)
        }
        
        if post.isModerator {
            badgeStackView.isHidden = post.postAsModerator
        } else {
            badgeStackView.isHidden = true
        }
        
        displayNameLabel.delegate = self
        datetimeLabel.text = post.subtitle
        
        if post.isPin {
            pinIconImageView.isHidden = false
        } else {
            pinIconImageView.isHidden = true
        }
        
    }

    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = AmityColorSet.backgroundColor
        displayNameLabel.configure(displayName: AmityLocalizedStringSet.General.anonymous.localizedString, communityName: nil, isOfficial: false, shouldShowCommunityName: false, shouldShowBannedSymbol: false, badgeIcon: UIImage())
        
        // badge
        badgeLabel.text = AmityLocalizedStringSet.General.moderator.localizedString + " • "
        badgeLabel.font = AmityFontSet.captionBold
        badgeLabel.textColor = AmityColorSet.base.blend(.shade1)
        badgeIconImageView.image = AmityIconSet.iconBadgeModerator
        
        // date time
        datetimeLabel.font = AmityFontSet.caption
        datetimeLabel.textColor = AmityColorSet.base.blend(.shade1)
        datetimeLabel.text = "45 mins"
        
        // option
        optionButton.tintColor = AmityColorSet.base
        optionButton.setImage(AmityIconSet.iconOption, for: .normal)
    }
    
    // MARK: - Perform Action
    private func performAction(action: AmityPostHeaderAction) {
        delegate?.didPerformAction(self, action: action)
    }
    
    // MARK: - Setup Role Data
    private func setupRole() {
        let jsonData = AmityUIKitManager.jsonBadgeUser.data(using: .utf8)!
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(UserBadge.self, from: jsonData)
            userBadge = data
        }
        catch {
        }
    }
    
    func loadImage(with url: String, placeholder: UIImage?, optimisticLoad: Bool = false) {
        if let placeholder = placeholder {
            self.badgeIcon = placeholder
        }
        AmityUIKitManagerInternal.shared.fileService.loadImage(imageURL: url, size: .small, optimisticLoad: optimisticLoad) { [weak self] result in
            switch result {
            case .success(let image):
                self?.badgeIcon = image
            case .failure(let error):
                Log.add("Error while downloading image with file id: \(url) error: \(error)")
            }
        }
        
    }
    
}

// MARK: - Action
private extension AmityPostHeaderTableViewCell {
    
    func avatarTap() {
        performAction(action: .tapAvatar)
    }
    
    @IBAction func optionTap() {
        performAction(action: .tapOption)
    }
}

extension AmityPostHeaderTableViewCell: AmityFeedDisplayNameLabelDelegate {
    func labelDidTapBadgeIcon(_ label: AmityFeedDisplayNameLabel) {
        performAction(action: .tapRole)
    }
    
    func labelDidTapUserDisplayName(_ label: AmityFeedDisplayNameLabel) {
        performAction(action: .tapDisplayName)
    }
    
    func labelDidTapCommunityName(_ label: AmityFeedDisplayNameLabel) {
        performAction(action: .tapCommunityName)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
