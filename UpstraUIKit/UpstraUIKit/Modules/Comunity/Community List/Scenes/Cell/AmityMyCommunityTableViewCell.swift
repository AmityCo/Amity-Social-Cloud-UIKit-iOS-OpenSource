//
//  AmityMyCommunityTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityMyCommunityTableViewCellDelegate: AnyObject {
    func cellDidTapOnAvatar(_ cell: AmityMyCommunityTableViewCell)
}

final class AmityMyCommunityTableViewCell: UITableViewCell, Nibbable {
    
//    static let defaultHeight: CGFloat = 56.0
    
    weak var delegate: AmityMyCommunityTableViewCellDelegate?
    
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var privateBadgeImageView: UIImageView!
    @IBOutlet private var badgeImageView: UIImageView!
    @IBOutlet private var joinButton: UIButton! {
        didSet {
            joinButton.addTarget(self, action: #selector(didJoinButton(_:)), for: .touchDown)
        }
    }
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    
    /* Closure Properties */
    var didTappedJoinButton: ((AmityCommunityModel) -> Void)?
    
    /* Common Properties */
    var community: AmityCommunityModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupJoinButton()
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        setupAvatarView()
        setupDescription()
        setupMember()
        displayNameLabel.font = AmityFontSet.bodyBold
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.text = ""
        privateBadgeImageView.image = AmityIconSet.iconPrivate
        privateBadgeImageView.tintColor = AmityColorSet.base
        badgeImageView.image = AmityIconSet.iconBadgeCheckmark
        badgeImageView.tintColor = AmityColorSet.highlight
    }
    
    private func setupDescription() {
        lblDescription.font = AmityFontSet.body
        lblDescription.textColor = AmityColorSet.base
        lblDescription.text = ""
    }
    
    private func setupMember() {
        lblMember.text = ""
        lblMember.font = AmityFontSet.caption
        lblMember.textColor = AmityColorSet.base.blend(.shade1)
    }
    
    func setupAvatarView() {
        avatarView.placeholderPostion = .fullSize
        avatarView.placeholder = AmityIconSet.defaultCommunity
        avatarView.contentMode = .scaleAspectFill
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.placeholder = AmityIconSet.defaultCommunity
        displayNameLabel.text = ""
        avatarView.image = nil
        badgeImageView.isHidden = true
        privateBadgeImageView.isHidden = true
    }
    
    func setupJoinButton() {
        joinButton.setTitle("", for: .normal)
        joinButton.layer.cornerRadius = joinButton.frame.height / 2
        joinButton.layer.masksToBounds = true
        joinButton.sizeToFit()
        joinButton.titleLabel?.font = AmityFontSet.bodyBold
    }
    
    func display(with community: AmityCommunityModel) {
        self.community = community
        avatarView.setImage(withImageURL: community.avatarURL, placeholder: AmityIconSet.defaultCommunity)
        displayNameLabel.text = community.displayName
        badgeImageView.isHidden = !community.isOfficial
        privateBadgeImageView.isHidden = community.isPublic
        
        lblDescription.text = community.description
        lblMember.text = String.localizedStringWithFormat(("%@ \(AmityLocalizedStringSet.CommunitySettings.itemTitleMembers.localizedString)"), community.membersCount.formatUsingAbbrevation())
        
        let joinButtonTitle = community.isJoined ? AmityLocalizedStringSet.communityDetailJoinedButton.localizedString : AmityLocalizedStringSet.communityDetailJoinButton.localizedString

        if community.isJoined {
            joinButton.setTitle(joinButtonTitle, for: .normal)
            joinButton.setTitleColor(AmityColorSet.primary, for: .normal)
            joinButton.setBackgroundColor(color: .white, forState: .normal)
            joinButton.layer.borderWidth = 1.0
            joinButton.layer.borderColor = AmityColorSet.primary.cgColor
        } else {
            joinButton.setTitle(joinButtonTitle, for: .normal)
            joinButton.setTitleColor(.white, for: .normal)
            joinButton.setBackgroundColor(color: AmityColorSet.primary, forState: .normal)
            joinButton.layer.borderWidth = 1.0
            joinButton.layer.borderColor = AmityColorSet.primary.cgColor
        }
    }
}

// MARK:- Actions
private extension AmityMyCommunityTableViewCell {
    func avatarTap() {
        delegate?.cellDidTapOnAvatar(self)
    }
    
    @objc func didJoinButton(_ sender: UIButton) {
        guard let community = community else { return }
        didTappedJoinButton?(community)
    }
}
