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
}

public struct LastReadData: Decodable {
    public var ch_uid: String?
    public var lastReadDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case ch_uid = "ch_uid"
        case lastReadDate = "lastReadDate"
    }
}

public struct NotificationModel: Decodable {
    public var description: String?
    public var networkId: String?
    public var userId: String?
    public var verb: String?
    public var targetId: String?
    public var imageUrl: String?
    public var targetType: String?
    public var hasRead: Bool?
    public var lastUpdate: Int?
    public var actors: [actorModel]?
    public var actorsCount: Int?
    
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

public struct actorModel: Decodable {
    public var name: String?
    public var id: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
}
