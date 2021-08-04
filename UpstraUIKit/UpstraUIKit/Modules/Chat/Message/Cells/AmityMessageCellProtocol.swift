//
//  AmityMessageListCellProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public protocol AmityMessageCellProtocol: UITableViewCell {
    static var cellIdentifier: String { get }
    func display(message: AmityMessageModel)
}

public extension AmityMessageCellProtocol {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

protocol AmityMessageCellDelegate: AnyObject {
    func performEvent(_ cell: AmityMessageTableViewCell, events: AmityMessageCellEvents)
}

enum AmityMessageCellEvents {
    case edit
    case delete
    case report
    case tapImage(imageView: UIImageView)
    case audioPlaying
    case audioFinishPlaying
}

