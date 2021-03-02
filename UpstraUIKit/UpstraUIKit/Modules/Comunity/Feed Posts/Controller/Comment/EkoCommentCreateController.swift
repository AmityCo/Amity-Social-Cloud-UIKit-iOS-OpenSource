//
//  EkoCommentCreateController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommentCreateControllerProtocol {
    func createComment(withReferenceId postId: String, referenceType: EkoCommentReferenceType, parentId: String?, text: String, completion: ((EkoComment?, Error?) -> Void)?)
}

final class EkoCommentCreateController: EkoCommentCreateControllerProtocol {
    
    private let repository = EkoCommentRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var object: EkoObject<EkoComment>?
    private var token: EkoNotificationToken?
    
    func createComment(withReferenceId postId: String, referenceType: EkoCommentReferenceType, parentId: String?, text: String, completion: ((EkoComment?, Error?) -> Void)?) {
        token?.invalidate()
        object = repository.createComment(withReferenceId: postId, referenceType: referenceType, parentId: parentId, text: text)
        token = object?.observe { commentObject, error in
            completion?(commentObject.object, error)
        }
    }
}
