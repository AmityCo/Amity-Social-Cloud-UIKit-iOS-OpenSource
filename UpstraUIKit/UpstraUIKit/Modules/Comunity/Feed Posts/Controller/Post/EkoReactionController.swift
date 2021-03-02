//
//  EkoReactionController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

enum EkoReactionType: String {
    case like
}

protocol EkoReactionControllerProtocol {
    func addReaction(withReaction reaction: EkoReactionType, referanceId: String, referenceType: EkoReactionReferenceType, completion: EkoRequestCompletion?)
    func removeReaction(withReaction reaction: EkoReactionType, referanceId: String, referenceType: EkoReactionReferenceType, completion: EkoRequestCompletion?)
}

final class EkoReactionController: EkoReactionControllerProtocol {
    
    private let repository = EkoReactionRepository(client: UpstraUIKitManagerInternal.shared.client)

    func addReaction(withReaction reaction: EkoReactionType, referanceId: String, referenceType: EkoReactionReferenceType, completion: EkoRequestCompletion?) {
        repository.addReaction(reaction.rawValue, referenceId: referanceId, referenceType: referenceType, completion: completion)
    }
    
    func removeReaction(withReaction reaction: EkoReactionType, referanceId: String, referenceType: EkoReactionReferenceType, completion: EkoRequestCompletion?) {
        repository.removeReaction(reaction.rawValue, referenceId: referanceId, referenceType: referenceType, completion: completion)
    }
}
