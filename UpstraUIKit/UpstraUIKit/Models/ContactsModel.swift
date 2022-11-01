//
//  ContactsModel.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 1/11/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import ContactsUI

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
}
