//
//  AmityCommentCreateController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommentCreateControllerProtocol {
    func createComment(withReferenceId postId: String, referenceType: AmityCommentReferenceType, parentId: String?, text: String, completion: ((AmityComment?, Error?) -> Void)?)
}

final class AmityCommentCreateController: AmityCommentCreateControllerProtocol {
    
    private let repository = AmityCommentRepository(client: AmityUIKitManagerInternal.shared.client)
    private var object: AmityObject<AmityComment>?
    private var token: AmityNotificationToken?
    
    func createComment(withReferenceId postId: String, referenceType: AmityCommentReferenceType, parentId: String?, text: String, completion: ((AmityComment?, Error?) -> Void)?) {
        token?.invalidate()
        object = repository.createComment(forReferenceId: postId, referenceType: referenceType, parentId: parentId, text: text)
        token = object?.observe { commentObject, error in
            completion?(commentObject.object, error)
        }
    }
}
