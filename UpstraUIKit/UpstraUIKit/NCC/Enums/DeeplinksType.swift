//
//  DeeplinksType.swift
//  UpstraUIKit
//
//  Created by Khwan Siricharoenporn on 6/1/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import Foundation

public enum DeeplinksType {
    case community(id: String)
    case post(id: String, communityId: String)
    case category(id: String)
}
