//
//  EkoSelectMemberModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoSelectMemberModel: Equatable {
    
    static func == (lhs: EkoSelectMemberModel, rhs: EkoSelectMemberModel) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    
    var userId: String
    var displayName: String?
    var isSelect: Bool = false
    let avatarId: String
    let defaultDisplayName: String = EkoLocalizedStringSet.anonymous
    
    init(userId: String, displayName: String? = nil, isSelect: Bool = false, avatarId: String) {
        self.userId = userId
        self.displayName = displayName
        self.isSelect = isSelect
        self.avatarId = avatarId
    }
    
}
