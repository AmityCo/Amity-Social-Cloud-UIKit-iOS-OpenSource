//
//  AmityPostUpdateController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityPostUpdateControllerProtocol {
    func update(withPostId postId: String, text: String, completion: AmityPostRequestCompletion?)
}

final class AmityPostUpdateController: AmityPostUpdateControllerProtocol {
    private let repository = AmityPostRepository(client: AmityUIKitManagerInternal.shared.client)
    
    func update(withPostId postId: String, text: String, completion: AmityPostRequestCompletion?) {
        let textBuilder = AmityTextPostBuilder()
        textBuilder.setText(text)
        repository.updatePost(withId: postId, builder: textBuilder, completion: completion)
    }
    
}
