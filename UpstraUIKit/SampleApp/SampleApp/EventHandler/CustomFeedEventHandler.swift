//
//  CustomFeedEventHandler.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Eko. All rights reserved.
//

import UpstraUIKit

class CustomFeedEventHandler: EkoFeedEventHandler {
    override func sharePostDidTap(from source: EkoViewController, postId: String) {
        let urlString = "https://amity.co/posts/\(postId)"
        guard let url = URL(string: urlString) else { return }
        let viewController = EkoActivityController.make(activityItems: [url])
        source.present(viewController, animated: true, completion: nil)
    }
    
    override func sharePostToGroupDidTap(from source: EkoViewController, postId: String) {
    }
    
    override func sharePostToMyTimelineDidTap(from source: EkoViewController, postId: String) {
    }
}
