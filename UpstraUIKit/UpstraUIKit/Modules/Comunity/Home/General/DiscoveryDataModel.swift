//
//  DiscoveryDataModel.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 22/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

struct DiscoveryDataModel: Decodable {
    let file_url: String
    let dataType: String
    let postId: String
    let parentPostId: String
    
    enum CodingKeys: String, CodingKey {
        case file_url = "file_url"
        case dataType = "dataType"
        case postId = "postId"
        case parentPostId = "parentPostId"
    }
}
