//
//  RecentMessageModel.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 1/3/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

public struct AmityRecentMessageModel: Decodable {
    let userId: String?
    let asReceiverMessageTH: String?
    let asOwnerMessageTH: String?
    let asReceiverMessageEN: String?
    let asOwnerMessageEN: String?
    let tag: [String]?
    let createAt: String?
    let type: String?
    let channelSegment: Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case asReceiverMessageTH = "asReceiverMessageTH"
        case asOwnerMessageTH = "asOwnerMessageTH"
        case asReceiverMessageEN = "asReceiverMessageEN"
        case asOwnerMessageEN = "asOwnerMessageEN"
        case tag = "tag"
        case createAt = "createAt"
        case type = "type"
        case channelSegment = "channelSegment"
    }
}
