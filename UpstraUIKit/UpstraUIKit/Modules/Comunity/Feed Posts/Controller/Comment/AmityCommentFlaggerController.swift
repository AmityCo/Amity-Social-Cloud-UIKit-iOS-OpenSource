//
//  AmityCommentFlaggerController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/14/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommentFlaggerControllerProtocol {
    func report(withCommentId commentId: String, completion: AmityRequestCompletion?)
    func unreport(withCommentId commentId: String, completion: AmityRequestCompletion?)
    func getReportStatus(withCommentId commentId: String, completion: ((Bool) -> Void)?)
}

final class AmityCommentFlaggerController: AmityCommentFlaggerControllerProtocol {
    
    private var flagger: AmityCommentFlagger?
    
    func report(withCommentId commentId: String, completion: AmityRequestCompletion?) {
        flagger = AmityCommentFlagger(client: AmityUIKitManagerInternal.shared.client, commentId: commentId)
        flagger?.flag(completion: completion)
    }
    
    func unreport(withCommentId commentId: String, completion: AmityRequestCompletion?) {
        flagger = AmityCommentFlagger(client: AmityUIKitManagerInternal.shared.client, commentId: commentId)
        flagger?.unflag(completion: completion)
    }
    
    func getReportStatus(withCommentId commentId: String, completion: ((Bool) -> Void)?) {
        flagger = AmityCommentFlagger(client: AmityUIKitManagerInternal.shared.client, commentId: commentId)
        flagger?.isFlaggedByMe { flag in
            completion?(flag)
        }
    }
}
