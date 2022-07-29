//
//  AmityCommunityHandler.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 26/7/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import UIKit

public class AmityCommunityHandler {
    public static var shared = AmityCommunityHandler()
    
    public init() {}
    
    // MARK: - Public function
    open func getNotificationHistory(completion: @escaping(_ postArray: NotificationHistory?) -> () ) {
        customAPIRequest.getNotificationHistory() { result in
            completion(result)
        }
    }
}
