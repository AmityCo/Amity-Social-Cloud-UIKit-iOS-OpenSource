//
//  AmitySelectUserController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 21/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit

final class AmitySelectUserController {
    
    func selectUser(searchUsers: [AmitySelectMemberModel], users: inout AmityFetchUserController.GroupUser, storeUsers: inout [AmitySelectMemberModel], at indexPath: IndexPath, isSearch: Bool) {

        var selectedUser: AmitySelectMemberModel!
        
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
    
    func deselect(users: inout AmityFetchUserController.GroupUser, storeUsers: inout [AmitySelectMemberModel], at indexPath: IndexPath) {
        let selectedUser = storeUsers[indexPath.item]
        users.forEach {
            if let index = $0.value.firstIndex(where: { $0 == selectedUser }) {
                $0.value[index].isSelected = false
            }
        }
        storeUsers.remove(at: indexPath.item)
    }
}
