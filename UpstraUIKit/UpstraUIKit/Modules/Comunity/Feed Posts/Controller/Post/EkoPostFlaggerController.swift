//
//  EkoPostFlaggerController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/14/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoPostFlaggerControllerProtocol {
    func report(withPostId postId: String, completion: EkoRequestCompletion?)
    func unreport(withPostId postId: String, completion: EkoRequestCompletion?)
    func getReportStatus(withPostId postId: String, completion: @escaping (Bool) -> Void)
}

final class EkoPostFlaggerController: EkoPostFlaggerControllerProtocol {
    private var flagger: EkoPostFlagger?
    
    func report(withPostId postId: String, completion: EkoRequestCompletion?) {
        flagger = EkoPostFlagger(client: UpstraUIKitManagerInternal.shared.client, postId: postId)
        flagger?.flagPost(completion: completion)
    }
    
    func unreport(withPostId postId: String, completion: EkoRequestCompletion?) {
        flagger = EkoPostFlagger(client: UpstraUIKitManagerInternal.shared.client, postId: postId)
        flagger?.unflagPost(completion: completion)
    }
    
    func getReportStatus(withPostId postId: String, completion: @escaping (Bool) -> Void) {
        flagger = EkoPostFlagger(client: UpstraUIKitManagerInternal.shared.client, postId: postId)
        flagger?.isPostFlaggedByMe(completion: completion)
    }
}
