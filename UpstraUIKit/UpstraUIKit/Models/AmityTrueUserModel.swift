//
//  AmityTureUser.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 9/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

public struct TrueUser {
    var userId: String
    var displayName: String
    var avatarURL: String?
    
    public init(userId: String, displayname: String){
        self.userId = userId
        self.displayName = displayname
    }
}
