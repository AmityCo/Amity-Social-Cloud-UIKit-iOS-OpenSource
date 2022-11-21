//
//  File.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 26/7/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

public struct NotificationHistory: Decodable {
    public var lastRecordDate: Int?
    public var lastRead: LastReadData?
    public var data: [NotificationModel]?
    
    enum CodingKeys: String, CodingKey {
        case lastRecordDate = "lastRecordDate"
        case lastRead = "lastRead"
        case data = "data"
    }
}

public struct LastReadData: Decodable {
    public var netid_uid: String?
    public var lastReadDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case netid_uid = "netid_uid"
        case lastReadDate = "lastReadDate"
    }
}

public struct NotificationModel: Decodable {
    public var description: String?
    public var networkId: String?
    public var userId: String?
    public var verb: String?
    public var targetId: String?
    public var targetGroup: String?
    public var imageUrl: String?
    public var customImageUrl: String?
    public var targetType: String?
    public var hasRead: Bool = false
    public var lastUpdate: Int?
    public var actors: [actorModel]?
    public var actorsCount: Int?
    public var communityName: String?
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case networkId = "networkId"
        case userId = "userId"
        case verb = "verb"
        case targetId = "targetId"
        case targetGroup = "targetGroup"
        case imageUrl = "imageUrl"
        case customImageUrl = "customImageUrl"
        case targetType = "targetType"
        case hasRead = "hasRead"
        case lastUpdate = "lastUpdate"
        case actors = "actors"
        case actorsCount = "actorsCount"
        case communityName = "communityName"
    }
}

public struct actorModel: Decodable {
    public var name: String?
    public var id: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
}

// MARK: - Notification Unread Count
public struct NotificationUnreadCount: Codable {
    let data: DataClass
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

public struct DataClass: Codable {
    let totalUnreadCount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalUnreadCount = "totalUnreadCount"
    }
}
