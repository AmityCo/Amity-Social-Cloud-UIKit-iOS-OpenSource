//
//  File.swift
//  AmityUIKitLiveStream
//
//  Created by Jiratin Teean on 9/5/2565 BE.
//

import Foundation

struct StreamViewerDataModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case maxPage = "max_page"
    }
    
    let count: Int
    let maxPage: String
}
