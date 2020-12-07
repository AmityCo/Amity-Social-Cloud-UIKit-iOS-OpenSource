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
    case audioIncoming
    case audioOutgoing
    
    var identifier: String {
        switch self {
        case .textIncoming: return "textIncoming"
        case .textOutgoing: return "textOutgoing"
        case .imageIncoming: return "imageIncoming"
        case .imageOutgoing: return "imageOutgoing"
        case .audioIncoming: return "audioIncoming"
        case .audioOutgoing: return "audioOutgoing"
        }
    }
    
    var nib: UINib {
        switch self {
        case .textIncoming:
            return UINib(nibName: "EkoMessageTextIncomingTableViewCell", bundle: UpstraUIKitManager.bundle)
        case .textOutgoing:
            return UINib(nibName: "EkoMessageTextOutgoingTableViewCell", bundle: UpstraUIKitManager.bundle)
        case .imageIncoming:
            return UINib(nibName: "EkoMessageImageIncomingTableViewCell", bundle: UpstraUIKitManager.bundle)
        case .imageOutgoing:
            return UINib(nibName: "EkoMessageImageOutgoingTableViewCell", bundle: UpstraUIKitManager.bundle)
        case .audioIncoming:
            return UINib(nibName: "EkoMessageAudioIncomingTableViewCell", bundle: UpstraUIKitManager.bundle)
        case .audioOutgoing:
            return UINib(nibName: "EkoMessageAudioOutgoingTableViewCell", bundle: UpstraUIKitManager.bundle)
        }
    }
    
}
