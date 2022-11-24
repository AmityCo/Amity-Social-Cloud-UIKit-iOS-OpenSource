//
//  TrueRegexModel.swift
//  AmityUIKit
//
//  Created by GuIDe'MacbookAmityHQ on 24/11/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

public struct TrueRegexModel: Decodable {
    public var android: Bool = false
    public var pattern: String?
    public var communityFeature: [String]?
    public var ios: Bool = false

    enum CodingKeys: String, CodingKey {
        case android = "android"
        case pattern = "pattern"
        case communityFeature = "community_feature"
        case ios = "ios"
    }
}
