//
//  EkoSearchUserController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

enum EkoSearchUserControllerError: Error {
    case textEmpty
    case unknown
}
 
final class EkoSearchUserController {
    
    private weak var repository: EkoUserRepository?
    
    private var collection: EkoCollection<EkoUser>?
    private var token: EkoNotificationToken?
    private var users: [EkoSelectMemberModel] = []
    private var searchTask: DispatchWorkItem?
    
    init(repository: EkoUserRepository?) {
        self.repository = repository
    }
    
    func search(with text: String, storeUsers: [EkoSelectMemberModel], _ completion: @escaping (Result<[EkoSelectMemberModel], EkoSearchUserControllerError>) -> Void) {
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
                            let model = EkoSelectMemberModel(object: object)
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
