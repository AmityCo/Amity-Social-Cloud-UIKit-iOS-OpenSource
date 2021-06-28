//
//  AmitySearchUserController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmitySearchUserControllerError: Error {
    case textEmpty
    case unknown
}
 
final class AmitySearchUserController {
    
    private weak var repository: AmityUserRepository?
    
    private var collection: AmityCollection<AmityUser>?
    private var token: AmityNotificationToken?
    private var users: [AmitySelectMemberModel] = []
    private var searchTask: DispatchWorkItem?
    
    init(repository: AmityUserRepository?) {
        self.repository = repository
    }
    
    func search(with text: String, storeUsers: [AmitySelectMemberModel], _ completion: @escaping (Result<[AmitySelectMemberModel], AmitySearchUserControllerError>) -> Void) {
        users = []
        searchTask?.cancel()
        if text == "" {
            completion(.failure(.textEmpty))
        } else {
            let request =  DispatchWorkItem { [weak self] in
                self?.collection = self?.repository?.searchUser(text, sortBy: .displayName)
                self?.token = self?.collection?.observe { (userCollection, change, error) in
                    guard let strongSelf = self else { return }
                    if let error = error {
                        completion(.failure(.unknown))
                    } else {
                        for index in 0..<userCollection.count() {
                            guard let object = userCollection.object(at: index) else { continue }
                            let model = AmitySelectMemberModel(object: object)
                            model.isSelected = storeUsers.contains { $0.userId == object.userId }
                            if !strongSelf.users.contains(where: { $0.userId == object.userId }) {
                                strongSelf.users.append(model)
                            }
                        }
                        completion(.success(strongSelf.users))
                    }
                }
            }
            
            searchTask = request
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: request)
        }
    }
    
    func loadmore(isSearch: Bool) -> Bool {
        if isSearch {
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
