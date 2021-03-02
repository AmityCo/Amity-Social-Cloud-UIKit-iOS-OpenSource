//
//  EkoCommentFlaggerController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/14/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommentFlaggerControllerProtocol {
    func report(withCommentId commentId: String, completion: EkoRequestCompletion?)
    func unreport(withCommentId commentId: String, completion: EkoRequestCompletion?)
    func getReportStatus(withCommentId commentId: String, completion: @escaping (Bool) -> Void)
}

final class EkoCommentFlaggerController: EkoCommentFlaggerControllerProtocol {
    
    private var flagger: EkoCommentFlagger?
    
    func report(withCommentId commentId: String, completion: EkoRequestCompletion?) {
        flagger = EkoCommentFlagger(client: UpstraUIKitManagerInternal.shared.client, commentId: commentId)
        flagger?.flag(completion: completion)
    }
    
    func unreport(withCommentId commentId: String, completion: EkoRequestCompletion?) {
        flagger = EkoCommentFlagger(client: UpstraUIKitManagerInternal.shared.client, commentId: commentId)
        flagger?.unflag(completion: completion)
    }
    
    func getReportStatus(withCommentId commentId: String, completion: @escaping (Bool) -> Void) {
        flagger = EkoCommentFlagger(client: UpstraUIKitManagerInternal.shared.client, commentId: commentId)
        flagger?.isFlagByMe(completion: completion)
    }
}
