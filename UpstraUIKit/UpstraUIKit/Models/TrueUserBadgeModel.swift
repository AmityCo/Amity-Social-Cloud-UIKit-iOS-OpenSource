//
//  TrueUserBadgeModel.swift
//  AmityUIKit
//
//  Created by GuIDe'MacbookAmityHQ on 30/9/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation


public struct UserBadge: Decodable {
    public var groupProfile: [GroupProfile]?
    
    enum CodingKeys: String, CodingKey {
        case groupProfile = "group_profile"
    }
    
    public struct GroupProfile: Decodable {
        public var enable: Bool?
        public var role: String?
        public var profile: [BadgeProfile]?
        
        enum CodingKeys: String, CodingKey {
            case enable = "enable"
            case role = "role"
            case profile = "profile"
        }
    }

    public struct BadgeProfile: Decodable {
        public var badgeIcon: String?
        public var badgeDescriptionEn: String?
        public var badgeTitleEn: String?
        public var badgeTitleLocal: String?
        public var badgeDescriptionLocal: String?

        enum CodingKeys: String, CodingKey {
            case badgeIcon = "badge_icon"
            case badgeDescriptionEn = "badge_description_en"
            case badgeTitleEn = "badge_title_en"
            case badgeTitleLocal = "badge_title_local"
            case badgeDescriptionLocal = "badge_description_local"
        }
    }
}
