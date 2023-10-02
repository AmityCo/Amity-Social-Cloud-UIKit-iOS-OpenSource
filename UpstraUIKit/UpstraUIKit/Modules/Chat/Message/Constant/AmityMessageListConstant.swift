//
//  AmityMessageListConstant.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 5/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

public enum AmityMessageTypes: CaseIterable {
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
            return UINib(nibName: "AmityMessageTextIncomingTableViewCell", bundle: AmityUIKitManager.bundle)
        case .textOutgoing:
            return UINib(nibName: "AmityMessageTextOutgoingTableViewCell", bundle: AmityUIKitManager.bundle)
        case .imageIncoming:
            return UINib(nibName: "AmityMessageImageIncomingTableViewCell", bundle: AmityUIKitManager.bundle)
        case .imageOutgoing:
            return UINib(nibName: "AmityMessageImageOutgoingTableViewCell", bundle: AmityUIKitManager.bundle)
        case .audioIncoming:
            return UINib(nibName: "AmityMessageAudioIncomingTableViewCell", bundle: AmityUIKitManager.bundle)
        case .audioOutgoing:
            return UINib(nibName: "AmityMessageAudioOutgoingTableViewCell", bundle: AmityUIKitManager.bundle)
        }
    }
    
    var `class`: AmityMessageCellProtocol.Type {
        switch self {
        case .textIncoming, .textOutgoing:
            return AmityMessageTextTableViewCell.self
        case .imageIncoming:
            return AmityMessageImageIncomingTableViewCell.self
        case .imageOutgoing:
            return AmityMessageImageOutgoingTableViewCell.self
        case .audioIncoming, .audioOutgoing:
            return AmityMessageAudioTableViewCell.self
        }
    }
    
}
