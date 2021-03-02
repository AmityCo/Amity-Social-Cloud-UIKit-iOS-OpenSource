//
//  EkoPostDeleteController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoPostDeleteControllerProtocol {
    func delete(withPostId postId: String, parentId: String?, completion: EkoRequestCompletion?)
}

final class EkoPostDeleteController: EkoPostDeleteControllerProtocol {
    private let repository = EkoFeedRepository(client: UpstraUIKitManagerInternal.shared.client)
    
    func delete(withPostId postId: String, parentId: String?, completion: EkoRequestCompletion?) {
        repository.deletePost(withPostId: postId, parentId: parentId, completion: completion)
    }
}
