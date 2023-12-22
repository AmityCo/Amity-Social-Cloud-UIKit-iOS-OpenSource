//
//  AmityEditUserProfileScreenViewModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

class AmityUserProfileEditorScreenViewModel: AmityUserProfileEditorScreenViewModelType {
    
    private let userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
    private var userObject: AmityObject<AmityUser>?
    private var userCollectionToken: AmityNotificationToken?
    private let dispatchGroup = DispatchGroupWraper()
    private let amityUserUpdateBuilder = AmityUserUpdateBuilder()
    private let fileRepository = AmityFileRepository(client: AmityUIKitManagerInternal.shared.client)
    
    weak var delegate: AmityUserProfileEditorScreenViewModelDelegate?
    var user: AmityUserModel?
    
    init() {
        userObject = userRepository.getUser(AmityUIKitManagerInternal.shared.client.currentUserId!)
        userCollectionToken = userObject?.observe { [weak self] user, error in
            guard let strongSelf = self,
                let user = user.object else{ return }
            
            strongSelf.user = AmityUserModel(user: user)
            strongSelf.delegate?.screenViewModelDidUpdate(strongSelf)
        }
    }
    
    func update(displayName: String, about: String) {
        
        let completion: AmityRequestCompletion? = { [weak self] success, error in
            if success {
                self?.dispatchGroup.leave()
            } else {
                self?.dispatchGroup.leaveWithError(error)
            }
        }
        
        // Update
        dispatchGroup.enter()
        amityUserUpdateBuilder.setDisplayName(displayName)
        amityUserUpdateBuilder.setUserDescription(about)
        AmityUIKitManagerInternal.shared.client.updateUser(amityUserUpdateBuilder, completion: completion)
        
        dispatchGroup.notify(queue: DispatchQueue.main) { error in
            if let error = error {
                Log.add("Error")
            } else {
                Log.add("Success")
            }
        }
    }
    
    func update(avatar: UIImage, completion: ((Bool) -> Void)?) {
        // Update user avatar
        dispatchGroup.enter()
        fileRepository.uploadImage(avatar, progress: nil) { [weak self] (imageData, error) in
            guard let self = self else { return }
            
            let userUpdateBuilder = AmityUserUpdateBuilder()
            userUpdateBuilder.setAvatar(imageData)
            
            
            AmityUIKitManagerInternal.shared.client.updateUser(userUpdateBuilder) { [weak self] success, error in
                if success {
                    self?.dispatchGroup.leave()
                } else {
                    self?.dispatchGroup.leaveWithError(error)
                }
                completion?(success)
            }
        }
    }
}
