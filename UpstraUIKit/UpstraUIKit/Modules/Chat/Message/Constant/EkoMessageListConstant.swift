//
//  EkoMessageListConstant.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 5/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

public enum EkoMessageTypes: CaseIterable {
    case textIncoming
    case textOutgoing
    case imageIncoming
    case imageOutgoing
    
    var identifier: String {
        switch self {
        case .textIncoming: return "textIncoming"
        case .textOutgoing: return "textOutgoing"
        case .imageIncoming: return "imageIncoming"
        case .imageOutgoing: return "imageOutgoing"
        }
    }
    
    var nib: UINib {
        switch self {
        case .textIncoming:
            return UINib(nibName: "EkoMessageTextIncomingTableViewCell", bundle: UpstraUIKit.bundle)
        case .textOutgoing:
            return UINib(nibName: "EkoMessageTextOutgoingTableViewCell", bundle: UpstraUIKit.bundle)
        case .imageIncoming:
            return UINib(nibName: "EkoMessageImageIncomingTableViewCell", bundle: UpstraUIKit.bundle)
        case .imageOutgoing:
            return UINib(nibName: "EkoMessageImageOutgoingTableViewCell", bundle: UpstraUIKit.bundle)
        }
    }
    
}
