//
//  EkoSelectMemberModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoSelectMemberModel: Equatable {
    
    static func == (lhs: EkoSelectMemberModel, rhs: EkoSelectMemberModel) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    var userId: String
    var displayName: String?
    var isSelected: Bool = false
    let avatarId: String
    let defaultDisplayName: String = EkoLocalizedStringSet.anonymous
    var isCurrnetUser: Bool {
        return userId == UpstraUIKitManagerInternal.shared.client.currentUserId
    }
    
    init(object: EkoUser) {
        self.userId = object.userId
        self.displayName = object.displayName
        self.avatarId = object.avatarFileId ?? ""
    }
    
    init(object: EkoCommunityMembershipModel) {
        self.userId = object.userId
        self.displayName = object.displayName
        self.avatarId = object.avatarId
    }
}
