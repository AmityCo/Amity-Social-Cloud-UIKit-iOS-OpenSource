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
    func createComment(withReferenceId postId: String, referenceType: AmityCommentReferenceType, parentId: String?, text: String, metadata: [String: Any]?, mentionees: AmityMentioneesBuilder?, completion: ((AmityComment?, Error?) -> Void)?)
}

final class AmityCommentCreateController: AmityCommentCreateControllerProtocol {
    
    private let repository = AmityCommentRepository(client: AmityUIKitManagerInternal.shared.client)
    
    func createComment(withReferenceId postId: String, referenceType: AmityCommentReferenceType, parentId: String?, text: String, metadata: [String: Any]?, mentionees: AmityMentioneesBuilder?, completion: ((AmityComment?, Error?) -> Void)?) {
        
        let createOptions: AmityCommentCreateOptions
        if let metadata = metadata, let mentionees = mentionees {
            createOptions = AmityCommentCreateOptions(referenceId: postId, referenceType: referenceType, text: text, parentId: parentId, metadata: metadata, mentioneeBuilder: mentionees)
        } else {
            createOptions = AmityCommentCreateOptions(referenceId: postId, referenceType: referenceType, text: text, parentId: parentId)
        }
        
        repository.createComment(with: createOptions) { comment, error in
            completion?(comment, error)
        }
        
    }
}
