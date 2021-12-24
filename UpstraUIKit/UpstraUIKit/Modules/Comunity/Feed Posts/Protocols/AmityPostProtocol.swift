//
//  AmityPostProtocol.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/10/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public protocol AmityPostProtocol: UITableViewCell, AmityCellIdentifiable {
    var delegate: AmityPostDelegate? { get set }
    var post: AmityPostModel? { get }
    var indexPath: IndexPath? { get }
    func display(post: AmityPostModel, indexPath: IndexPath)
}

public protocol AmityPostDelegate: AnyObject {
    func didPerformAction(_ cell: AmityPostProtocol, action: AmityPostAction)
}

public enum AmityPostAction {
    case tapLiveStream(stream: AmityStream)
    case tapMedia(media: AmityMedia)
    case tapMediaInside(media: AmityMedia, photoViewer: AmityPhotoViewerController)
    case tapFile(file: AmityFile)
    case tapViewAll
    case tapExpandableLabel(label: AmityExpandableLabel)
    case willExpandExpandableLabel(label: AmityExpandableLabel)
    case didExpandExpandableLabel(label: AmityExpandableLabel)
    case willCollapseExpandableLabel(label: AmityExpandableLabel)
    case didCollapseExpandableLabel(label: AmityExpandableLabel)
    case submit
    case tapOnMentionWithUserId(userId: String)
}
