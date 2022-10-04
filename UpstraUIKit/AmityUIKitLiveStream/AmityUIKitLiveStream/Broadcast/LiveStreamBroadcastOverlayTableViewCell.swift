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

    var userBadge: UserBadge?
    var currentUserBadge: UserBadge.BadgeProfile?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupRole()
    }

    func display(comment: AmityCommentModel){
        
        self.backgroundColor = .clear
        
        commentView.backgroundColor = UIColor(hex: "#808080", alpha: 0.3)
        commentView.layer.cornerRadius = 10
        
        avatarView.backgroundColor = .clear
        
        if !comment.avatarCustomURL.isEmpty {
            avatarView.setImage(withCustomURL: comment.avatarCustomURL)
        } else {
            avatarView.setImage(withImageURL: comment.fileURL)
        }
        
        displayNameLabel.text = comment.displayName
        displayNameLabel.font = AmityFontSet.headerLine.withSize(16)
        displayNameLabel.textColor = .white
        displayNameLabel.backgroundColor = .clear
        
        commentLabel.text = comment.text
        commentLabel.font = AmityFontSet.caption.withSize(14)
        commentLabel.backgroundColor = .clear
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .byTruncatingTail
        commentLabel.sizeToFit()
        commentLabel.textColor = .white
        
        /// Setup Role
        for role in comment.role {
            guard let profile = userBadge?.groupProfile else { return }
            for badge in profile {
                if role == badge.role {
                    if badge.enable ?? false {
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
                          {}
                       ]
                    },
                    {
                       "enable": true,
                       "role": "rising-star",
                       "profile": [
                          {
                             "badge_description_en": "Earn a Rising Star badge by being an active member on True ID live chat, which include reacting and replying to other users’ messages",
                             "badge_title_en": "Rising Star",
                             "badge_title_local": "ดาวรุ่งพุ่งแรง",
                             "badge_icon": "https://cms.dmpcdn.com/livetv/2020/09/17/d65999e0-f8ca-11ea-93ca-b15d54ae9c1e_original.png",
                             "badge_description_local": "รับ เครื่องหมาย ดาวรุ่งพุ่งแรง ง่ายๆ เพียงแค่คุณเป็นหนึ่งในสมาชิกที่ใช้งานอย่างสม่ำเสมอ บน live chat ของทรูไอดี ซึ่งรวมไปถึงการส่งความรู้สึกตอบสนอง หรือแม้แต่การพิมพ์ตอบข้อความสมาชิกท่านอื่น เพียงแค่มีเครื่องหมายนี้ข้อความของคุณก็จะโดดเด่นเกินใคร!"
                          }
                       ]
                    },
                    {
                       "profile": [
                          {
                             "badge_description_local": "สัญลักษณ์แฟนตัวยง เป็นสัญลักษณ์แสดงความขอบคุณจาก True ID สำหรับลูกค้าที่มีส่วนร่วมมากที่สุดใน live chat ไม่ว่าจะเป็น การกดถูกใจ การตอบสนองต่อข้อความ การเริ่มต้นการสนทนา การแสดงความคิดเห็น เพียงแค่มีส่วนร่วมอย่างสม่ำเสมอเท่านั้น!",
                             "badge_title_local": "แฟนตัวยง",
                             "badge_description_en": "Super Fan badge are awarded to those who are most active and engaged, including reacting to content, replying to messages, and initiating conversations, on True ID live chat. Start earning your badge today!",
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
    
}
