//
//  ContactSyncTableViewCell.swift
//  SampleApp
//
//  Created by Mono TheForestcat on 18/11/2565 BE.
//  Copyright © 2565 BE Eko. All rights reserved.
//

import UIKit
import AmityUIKit

class ContactSyncTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet weak var contactname: UILabel!
    @IBOutlet weak var contactvalue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(model: AmityContactModel) {
        contactname.text = "\(model.contact.givenName)"
        var text = ""
        for phone in model.phoneNumber {
            for number in model.contact.phoneNumbers {
                let phoneWithoutDash = number.value.stringValue.replacingOccurrences(of: "-", with: "")
                if phoneWithoutDash == phone.number {
                    text += "\(number.value.stringValue) | isChatable: \(phone.isAmity) | ssoid: \(phone.ssoid ?? "")\n"
                }
            }
        }
        contactvalue.text = text
    }
    
}
