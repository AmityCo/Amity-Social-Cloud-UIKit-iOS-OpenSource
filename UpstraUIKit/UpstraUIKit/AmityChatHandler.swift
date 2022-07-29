//
//  AmityChatEventHandler.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 8/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import UIKit

public class AmityChatHandler {
    public static var shared = AmityChatHandler()
    
    public init() {}
    
    // MARK: - Public function
    open func getNotiCountFromAPI(completion: @escaping(_ completion:Result<Int,Error>) -> () ) {
        customAPIRequest.getChatBadgeCount(userId: AmityUIKitManagerInternal.shared.currentUserId) { result in
            switch result {
            case .success(let badgeCount):
                completion(.success(badgeCount))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
