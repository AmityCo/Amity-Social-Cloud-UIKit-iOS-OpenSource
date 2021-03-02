//
//  EkoPostUpdateController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoPostUpdateControllerProtocol {
    func update(withPostId postId: String, text: String, completion: EkoRequestCompletion?)
}

final class EkoPostUpdateController: EkoPostUpdateControllerProtocol {
    private let repository = EkoFeedRepository(client: UpstraUIKitManagerInternal.shared.client)
    
    func update(withPostId postId: String, text: String, completion: EkoRequestCompletion?) {
        let textBuilder = EkoTextPostBuilder()
        textBuilder.setText(text)
        repository.updatePost(withPostId: postId, builder: textBuilder, completion: completion)
    }
    
}
