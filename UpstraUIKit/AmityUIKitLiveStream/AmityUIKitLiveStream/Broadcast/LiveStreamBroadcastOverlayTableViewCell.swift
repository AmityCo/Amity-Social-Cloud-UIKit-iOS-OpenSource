//
//  LiveStreamBroadcastOverlayTableViewCell.swift
//  AmityUIKitLiveStream
//
//  Created by Mono TheForestcat on 10/8/2565 BE.
//

import UIKit
import AmityUIKit
import AmitySDK

protocol LiveStreamBroadcastOverlayProtocol {
    func didBadgeTap(userBadge: UserBadge.BadgeProfile) -> ()
}

class LiveStreamBroadcastOverlayTableViewCell: UITableViewCell,Nibbable {
    
    @IBOutlet var avatarView: AmityAvatarView!
    @IBOutlet var commentView: UIView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var roleImageView: UIImageView!
    
    static let height: CGFloat = 60
    
    var delegate: LiveStreamBroadcastOverlayProtocol?
    var tapAvatarDelegate: LivestreamWatchingProtocol?

    var userBadge: UserBadge?
    var currentUserBadge: UserBadge.BadgeProfile?
    var commentUserId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupRole()
        setupCell()
    }
    
    func setupCell() {
        self.backgroundColor = .clear
        
        commentView.backgroundColor = UIColor(hex: "#808080", alpha: 0.3)
        commentView.layer.cornerRadius = 10
        
        avatarView.backgroundColor = .clear
        
        displayNameLabel.font = AmityFontSet.headerLine.withSize(16)
        displayNameLabel.textColor = .white
        displayNameLabel.backgroundColor = .clear
        
        commentLabel.font = AmityFontSet.caption.withSize(14)
        commentLabel.backgroundColor = .clear
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .byTruncatingTail
        commentLabel.sizeToFit()
        commentLabel.textColor = .white
    }

    func display(comment: AmityCommentModel){
        
        if !comment.avatarCustomURL.isEmpty {
            avatarView.setImage(withCustomURL: comment.avatarCustomURL)
        } else {
            avatarView.setImage(withImageURL: comment.fileURL)
        }
        
        displayNameLabel.text = comment.displayName
        
        commentUserId = comment.userId
        
        commentLabel.text = comment.text
        
        roleImageView.isHidden = true
        
        /// Setup Role
        for role in comment.role {
            guard let profile = userBadge?.groupProfile else { return }
            for badge in profile {
                if role == badge.role {
                    if badge.enable ?? false {
                        roleImageView.isHidden = false
                        roleImageView.downloaded(from: badge.profile?.first?.badgeIcon ?? "")
                        guard let currentProfile = badge.profile else { return }
                        currentUserBadge = currentProfile.first!
                    }
                }
            }
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(roleTap(tapGestureRecognizer:)))
        roleImageView.isUserInteractionEnabled = true
        roleImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let avatarTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didAvatarInCellIsTapped))
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(avatarTapGestureRecognizer)
    }
    
    @objc func roleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let user = currentUserBadge else { return }
        delegate?.didBadgeTap(userBadge: user)
    }
    
    class func height(for comment: AmityCommentModel, boundingWidth: CGFloat) -> CGFloat {

        var height: CGFloat = 30
        var actualWidth: CGFloat = 0

        // for cell layout and calculation, please go check this pull request https://github.com/EkoCommunications/EkoMessagingSDKUIKitIOS/pull/713
        let horizontalPadding: CGFloat = 0
        actualWidth = boundingWidth - horizontalPadding

        let messageHeight = AmityExpandableLabel.height(for: comment.text, font: AmityFontSet.body, boundingWidth: actualWidth, maximumLines: 0)
        height += messageHeight
        return height

    }
    
    // MARK: - Tap avatar to show profile
    @objc func didAvatarInCellIsTapped() {
        tapAvatarDelegate?.didAvatarTap(userId: commentUserId)
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
    
}
