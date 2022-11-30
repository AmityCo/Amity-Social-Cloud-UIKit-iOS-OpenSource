//
//  TrueRegexModel.swift
//  AmityUIKit
//
//  Created by GuIDe'MacbookAmityHQ on 24/11/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

public struct TrueRegexModel: Decodable {
    public var android: Bool = true
    public var pattern: String? = #"(\+?66[689]{1}\-?\s?|0[689]{1}\-?\s?)[0-9]\-?\s?([0-9]{3})\-?\s?([0-9]{4})"#
    public var communityFeature: [String]? = ["livestream", "comment", "post"]
    public var ios: Bool = true

    enum CodingKeys: String, CodingKey {
        case android = "android"
        case pattern = "pattern"
        case communityFeature = "community_feature"
        case ios = "ios"
    }
}
