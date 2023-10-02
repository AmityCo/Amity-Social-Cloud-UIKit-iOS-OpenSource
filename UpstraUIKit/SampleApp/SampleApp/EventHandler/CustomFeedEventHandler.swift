//
//  CustomFeedEventHandler.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import Foundation
import AmityUIKit

class CustomFeedEventHandler: AmityFeedEventHandler {
    override func sharePostDidTap(from source: AmityViewController, postId: String) {
        let urlString = "https://amity.co/posts/\(postId)"
        guard let url = URL(string: urlString) else { return }
        let viewController = AmityActivityController.make(activityItems: [url])
        source.present(viewController, animated: true, completion: nil)
    }
    
    override func sharePostToGroupDidTap(from source: AmityViewController, postId: String) {
    }
    
    override func sharePostToMyTimelineDidTap(from source: AmityViewController, postId: String) {
    }
}
