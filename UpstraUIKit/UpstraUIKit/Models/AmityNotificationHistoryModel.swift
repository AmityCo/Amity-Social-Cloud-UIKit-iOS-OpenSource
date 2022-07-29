//
//  File.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 26/7/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

public struct NotificationHistory: Decodable {
    var lastRecordDate: Int?
    var lastRead: LastReadData?
    var data: [NotificationModel]?
}

struct LastReadData: Decodable {
    var ch_uid: String?
    var lastReadDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case ch_uid = "ch_uid"
        case lastReadDate = "lastReadDate"
    }
}

struct NotificationModel: Decodable {
    var description: String
    var networkId: String
    var userId: String
    var verb: String
    var targetId: String
    var imageUrl: String
    var targetType: String
    var hasRead: Bool
    var lastUpdate: Int
    var actors: [actorModel]
    var actorsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case networkId = "networkId"
        case userId = "userId"
        case verb = "verb"
        case targetId = "targetId"
        case imageUrl = "imageUrl"
        case targetType = "targetType"
        case hasRead = "hasRead"
        case lastUpdate = "lastUpdate"
        case actors = "actors"
        case actorsCount = "actorsCount"
    }
}

struct actorModel: Decodable {
    var name: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
}
