//
//  EkoEditUserProfileScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

class EkoEditUserProfileScreenViewModel: EkoEditUserProfileScreenViewModelType {
    
    private let userRepository = EkoUserRepository(client: UpstraUIKitManager.shared.client)
    private var userObject: EkoObject<EkoUser>?
    private var userCollectionToken: EkoNotificationToken?
    private let dispatchGroup = DispatchGroupWraper()
    
    weak var delegate: EkoEditUserProfileScreenViewModelDelegate?
    var user: EkoUserModel?
    
    init() {
        userObject = userRepository.user(forId: UpstraUIKitManager.shared.client.currentUserId!)
        userCollectionToken = userObject?.observe { [weak self] user, error in
            guard let strongSelf = self,
                let user = user.object else{ return }
            
            strongSelf.user = EkoUserModel(user: user)
            strongSelf.delegate?.screenViewModelDidUpdate(strongSelf)
        }
    }
    
    func update(displayName: String, about: String) {
        
        let completion: EkoRequestCompletion? = { [weak self] success, error in
            if success {
                self?.dispatchGroup.leave()
            } else {
                self?.dispatchGroup.leaveWithError(error)
            }
        }
        
        // Update description
        dispatchGroup.enter()
        UpstraUIKitManager.shared.client.setUserDescription(about, completion: completion)
        
        // Update display name
        dispatchGroup.enter()
        UpstraUIKitManager.shared.client.setDisplayName(displayName, completion: completion)
        
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
        UpstraUIKitManager.shared.client.setAvatar(avatar) { [weak self] success, error in
            if success {
                self?.dispatchGroup.leave()
            } else {
                self?.dispatchGroup.leaveWithError(error)
            }
            completion?(success)
        }
        
    }
    
}
