//
//  AmityChatEventHandler.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 8/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import UIKit
import AmitySDK
import Contacts

public class AmityChatHandler {
    public static var shared = AmityChatHandler()
    var channelsToken: AmityNotificationToken?
    var channelsCollection: AmityCollection<AmityChannel>?
    var channelRepository: AmityChannelRepository
    
    public init() {
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    // MARK: - Public function
    open func getNotiCountFromAPI(completion: @escaping(_ completion:Result<Int,Error>) -> () ) {
        customAPIRequest.getChatBadgeCount(userId: AmityUIKitManagerInternal.shared.currentUserId) { result in
            switch result {
            case .success(let badgeCount):
                completion(.success(badgeCount))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    open func getUnreadCountFromASC(completion: @escaping(_ completion:Result<Int,Error>) -> () ) {
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
        let query = AmityChannelQuery()
        query.types = [AmityChannelQueryType.conversation]
        query.filter = .userIsMember
        query.includeDeleted = false
        channelsCollection = channelRepository.getChannels(with: query)
        channelsToken?.invalidate()
        channelsToken = channelsCollection?.observe { [weak self] (collectionFromObserve, change, error) in
            if error != nil {
                completion(.failure(error!))
            }
            guard let collection = self?.channelsCollection else { return }
            var unreadCount: Int = 0
            for index in 0..<collection.count() {
                guard let channel = collection.object(at: UInt(index)) else { return }
                let model = AmityChannelModel(object: channel)
                unreadCount += model.unreadCount
            }
            
            completion(.success(unreadCount))
        }
    }
    
    open func syncContact(userId: String,  completion: @escaping(_ completion:Result<[AmityContactModel],Error>) -> () ){
        
        var contactArray = ContactsModel.generateCNContactArray()
        contactArray = contactArray.sorted { $0.givenName < $1.givenName }
        var resultArray: [AmityContactModel] = []
        
        //API can handle only 200 contact per request
        while contactArray.count > 200 {
            var batchArray: [CNContact] = []
            while batchArray.count <= 200 {
                batchArray.append(contactArray[0])
                contactArray.remove(at: 0)
            }
            
            var phoneListArray: [String] = []
            for contact in batchArray {
                for phoneNumber in contact.phoneNumbers {
                    let phoneWithoutDash = phoneNumber.value.stringValue.replacingOccurrences(of: "-", with: "")
                    phoneListArray.append(phoneWithoutDash)
                }
            }
            
            customAPIRequest.syncContact(userId: userId, phoneList: phoneListArray) { result in
                switch result {
                case .success(let phoneList):
                    for contact in contactArray {
                        let model = AmityContactModel(contact: contact, phoneNumber: [])
                        let phoneNumberArrayInContact = contact.phoneNumbers.map{ $0.value.stringValue.replacingOccurrences(of: "-", with: "") }
                        
                        for phone in phoneList {
                            if phoneNumberArrayInContact.contains(phone.number) {
                                model.phoneNumber.append(phone)
                            }
                        }
                        resultArray.append(model)
                    }
                    completion(.success(resultArray))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        }
        
        //If contactArray less than 200 | last round
        var phoneListArray: [String] = []
        for contact in contactArray {
            for phoneNumber in contact.phoneNumbers {
                let phoneWithoutDash = phoneNumber.value.stringValue.replacingOccurrences(of: "-", with: "")
                phoneListArray.append(phoneWithoutDash)
            }
        }
        
        customAPIRequest.syncContact(userId: userId, phoneList: phoneListArray) { result in
            switch result {
            case .success(let phoneList):
                for contact in contactArray {
                    let model = AmityContactModel(contact: contact, phoneNumber: [])
                    let phoneNumberArrayInContact = contact.phoneNumbers.map{ $0.value.stringValue.replacingOccurrences(of: "-", with: "") }
                    
                    for phone in phoneList {
                        if phoneNumberArrayInContact.contains(phone.number) {
                            model.phoneNumber.append(phone)
                        }
                    }
                    resultArray.append(model)
                }
                completion(.success(resultArray))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


