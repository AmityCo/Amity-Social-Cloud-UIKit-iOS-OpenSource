//
//  ContactsModel.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 1/11/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import ContactsUI

public class AmityContactModel: NSObject {
    public let contact: CNContact
    public var phoneNumber: [PhoneNumber]
    
    public init(contact: CNContact, phoneNumber: [PhoneNumber]) {
        self.contact = contact
        self.phoneNumber = phoneNumber
    }
}

public class JsonContact: Decodable {
    public let contact: [PhoneNumber]
    
    enum CodingKeys: String, CodingKey {
        case contact = "contact"
    }
}

public class PhoneNumber: NSObject, Decodable {
    public let number: String
    public let isAmity: Bool
    public let ssoid: String?
    
    public init(number: String, isAmity: Bool, ssoid: String? = nil) {
        self.number = number
        self.isAmity = isAmity
        self.ssoid = ssoid
    }
    
    enum CodingKeys: String, CodingKey {
        case number = "phone"
        case isAmity = "isChatable"
        case ssoid = "ssoid"
    }
}

class ContactsModel : NSObject {
    let givenName: String
    let familyName: String
    let phoneNumber: [String]
    let emailAddress: String
    var identifier: String
    var image: UIImage

    init(givenName:String, familyName:String, phoneNumber:[String], emailAddress:String, identifier:String, image:UIImage) {
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.identifier = identifier
        self.image = image
    }

    class func generateModelArray() -> [ContactsModel]{
        let contactStore = CNContactStore()
        var contactsData = [ContactsModel]()
        let key = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactImageDataKey,CNContactThumbnailImageDataKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try? contactStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
            let givenName = contact.givenName
            let familyName = contact.familyName
            let emailAddress = contact.emailAddresses.first?.value ?? ""
            let phoneNumber: [String] = contact.phoneNumbers.map{ $0.value.stringValue }
            let identifier = contact.identifier
            var image = UIImage()
            contactsData.append(ContactsModel(givenName: givenName, familyName: familyName, phoneNumber: phoneNumber, emailAddress: emailAddress as String, identifier: identifier, image: image))
        })
        return contactsData
    }
    
    class func generateCNContactArray() -> [CNContact]{
        let contactStore = CNContactStore()
        var contactsData = [CNContact]()
        let key = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactImageDataKey,CNContactThumbnailImageDataKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try? contactStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
            contactsData.append(contact)
        })
        return contactsData
    }
}
