//
//  AmityFetchUserController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityFetchUserController {
    
    typealias GroupUser = [(key: String, value: [AmitySelectMemberModel])]
    
    private weak var repository: AmityUserRepository?
    private var collection: AmityCollection<AmityUser>?
    private var token: AmityNotificationToken?
    
    private var users: [AmitySelectMemberModel] = []
    var storeUsers: [AmitySelectMemberModel] = []
    
    init(repository: AmityUserRepository?) {
        self.repository = repository
    }
    
    func getUser(_ completion: @escaping (Result<GroupUser, Error>) -> Void) {
        collection = repository?.getUsers(.displayName)
        
        token = collection?.observe { [weak self] (userCollection, change, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                completion(.failure(error))
            } else {
                for index in 0..<userCollection.count() {
                    guard let object = userCollection.object(at: index) else { continue }
                    let model = AmitySelectMemberModel(object: object)
                    model.isSelected = strongSelf.storeUsers.contains { $0.userId == object.userId }
                    if !strongSelf.users.contains(where: { $0.userId == object.userId }) {
                        strongSelf.users.append(model)
                    }
                }
                
                let predicate: (AmitySelectMemberModel) -> (String) = { user in
                    guard let displayName = user.displayName else { return "#" }
                    let c = String(displayName.prefix(1)).uppercased()
                    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    
                    if alphabet.contains(c) {
                        return c
                    } else {
                        return "#"
                    }
                }
                
                let groupUsers = Dictionary(grouping: strongSelf.users, by: predicate).sorted { $0.0 < $1.0 }
                completion(.success(groupUsers))
            }
        }
    }
    
    func loadmore(isSearch: Bool) -> Bool {
        if !isSearch {
            guard let collection = collection else { return false }
            switch collection.loadingStatus {
            case .loaded:
                if collection.hasNext {
                    collection.nextPage()
                    return true
                } else {
                    return false
                }
            default:
                return false
            }
        } else {
            return false
        }
    }

}

