//
//  AmitySelectMemberModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public final class AmitySelectMemberModel: Equatable {
    
    public static func == (lhs: AmitySelectMemberModel, rhs: AmitySelectMemberModel) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    public let userId: String
    public let displayName: String?
    public var email = String()
    public var isSelected: Bool = false
    public let avatarURL: String
    public let defaultDisplayName: String = AmityLocalizedStringSet.General.anonymous.localizedString
    public var isCurrnetUser: Bool {
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    
    init(object: AmityUser) {
        self.userId = object.userId
        self.displayName = object.displayName
        if let metadata = object.metadata {
            self.email = metadata["email"] as? String ?? ""
        }
        self.avatarURL = object.getAvatarInfo()?.fileURL ?? ""
    }
    
    init(object: AmityCommunityMembershipModel) {
        self.userId = object.userId
        self.displayName = object.displayName
        self.avatarURL = object.avatarURL
    }
    
    init(object: AmityChannelMembershipModel) {
        self.userId = object.userId
        self.displayName = object.displayName
        self.avatarURL = object.avatarURL
    }
}
