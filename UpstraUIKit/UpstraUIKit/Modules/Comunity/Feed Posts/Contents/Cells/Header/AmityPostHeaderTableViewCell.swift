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
        let JSONString = """
              {
                 "group_profile": [
                    {
                       "enable": false,
                       "role": "admin",
                       "profile": [
                          {
                             "badge_icon": "https://cms.dmpcdn.com/livetv/2020/09/17/dfacfdc0-f8ca-11ea-93ca-b15d54ae9c1e_original.png",
                             "badge_description_en": "Chat admins ensure that chat is up to standards by removing offensive posts and spam that detracts from conversations. Feel free to chat with our admin team!",
                             "badge_title_en": "Chat Admin",
                             "badge_title_local": "แอดมินห้องแชท",
                             "badge_description_local": "แอดมินห้องแชท ทำหน้าที่ควบคุมมาตรฐานการแชท โดยการลบโพสต์และสแปมที่ไม่เหมาะสม ทำให้ทุกคนสามารถพูดคุยกันอย่างสนุกสนานไร้กังวล"
                          }
                       ]
                    },
                    {
                       "profile": [
                          {
                             "badge_title_local": "แฟนตัวยง",
                             "badge_description_local": "รับ เครื่องหมาย แฟนตัวยง ง่ายๆ เพียงแค่คุณเป็นหนึ่งในสมาชิกที่ใช้งานอย่างสม่ำเสมอ บน live chat ของทรูไอดี ซึ่งรวมไปถึงการส่งความรู้สึกตอบสนอง หรือแม้แต่การพิมพ์ตอบข้อความสมาชิกท่านอื่น เพียงแค่มีเครื่องหมายนี้ข้อความของคุณก็จะโดดเด่นเกินใคร!",
                             "badge_description_en": "Earn a super fan badge by being one of the most active member on True ID live chat, which include reacting and replying to other users’ messages",
                             "badge_title_en": "Super Fan",
                             "badge_icon": "https://cms.dmpcdn.com/livetv/2020/09/22/cc7a2be0-fcaa-11ea-b266-63e567a949c5_original.png"
                          }
                       ],
                       "role": "beginner",
                       "enable": false
                    },
                    {
                       "enable": false,
                       "role": "general",
                       "profile": [
                          {
                             "badge_title_local": "",
                             "badge_description_local": "",
                             "badge_description_en": "",
                             "badge_title_en": "",
                             "badge_icon": ""
                          }
                       ]
                    },
                    {
                       "enable": true,
                       "role": "rising-star",
                       "profile": [
                          {
                             "badge_description_en": "This badge awarded to the user who win TrueID campaign",
                             "badge_title_en": "The Winner",
                             "badge_title_local": "ผู้ชนะเลิศ",
                             "badge_icon": "https://cms.dmpcdn.com/livetv/2020/09/17/d65999e0-f8ca-11ea-93ca-b15d54ae9c1e_original.png",
                             "badge_description_local": "สัญลักษณ์นี้สำหรับสมาชิกที่มีส่วนร่วมและชนะการแข่งขันในกิจกรรมบน TrueID!"
                          }
                       ]
                    },
                    {
                       "profile": [
                          {
                             "badge_description_local": "สัญลักษณ์นี้สำหรับสมาชิกที่มีส่วนร่วมกับกิจกรรมบน TrueID มากที่สุด!",
                             "badge_title_local": "แฟนตัวยง",
                             "badge_description_en": "This badge awarded to the user who has provide high contributions in TrueID campaign",
                             "badge_icon": "https://cms.dmpcdn.com/livetv/2020/09/17/e6f612b0-f8ca-11ea-816f-61c1bc726fdd_original.png",
                             "badge_title_en": "Super Fan"
                          }
                       ],
                       "enable": true,
                       "role": "super-fan"
                    }
                 ]
              }
              """
        let jsonData = JSONString.data(using: .utf8)!
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
