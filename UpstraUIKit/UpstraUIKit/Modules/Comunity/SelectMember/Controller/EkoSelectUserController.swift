//
//  EkoSelectUserController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit

final class EkoSelectUserController {
    
    func selectUser(searchUsers: [EkoSelectMemberModel], users: inout EkoFetchUserController.GroupUser, storeUsers: inout [EkoSelectMemberModel], at indexPath: IndexPath, isSearch: Bool) {

        var selectedUser: EkoSelectMemberModel!
        
        if isSearch {
            selectedUser = searchUsers[indexPath.row]
            users.forEach {
                if let index = $0.value.firstIndex(where: { $0 == selectedUser }) {
                    $0.value[index].isSelected = !selectedUser.isSelected
                }
            }
        } else {
            selectedUser = users[indexPath.section].value[indexPath.row]
        }
        
        if let user = storeUsers.first(where: { $0 == selectedUser}), let index = storeUsers.firstIndex(of: user) {
            storeUsers.remove(at: index)
        } else {
            storeUsers.append(selectedUser)
        }
        selectedUser.isSelected.toggle()
    }
    
    func deselect(users: inout EkoFetchUserController.GroupUser, storeUsers: inout [EkoSelectMemberModel], at indexPath: IndexPath) {
        let selectedUser = storeUsers[indexPath.item]
        users.forEach {
            if let index = $0.value.firstIndex(where: { $0 == selectedUser }) {
                $0.value[index].isSelected = false
            }
        }
        storeUsers.remove(at: indexPath.item)
    }
}
