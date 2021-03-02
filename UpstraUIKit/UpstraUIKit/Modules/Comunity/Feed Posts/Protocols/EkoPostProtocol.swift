//
//  EkoPostProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/10/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

protocol EkoPostProtocol: UITableViewCell {
    var delegate: EkoPostDelegate? { get set }
    var post: EkoPostModel? { get }
    var indexPath: IndexPath? { get }
    func display(post: EkoPostModel, shouldExpandContent: Bool, indexPath: IndexPath)
}

protocol EkoPostDelegate: class {
    func didPerformAction(_ cell: EkoPostProtocol, action: EkoPostAction)
}

enum EkoPostAction {
    case tapImage(image: EkoImage)
    case tapFile(file: EkoFile)
    case tapViewAll
    case tapExpandableLabel(label: EkoExpandableLabel)
    case willExpandExpandableLabel(label: EkoExpandableLabel)
    case didExpandExpandableLabel(label: EkoExpandableLabel)
    case willCollapseExpandableLabel(label: EkoExpandableLabel)
    case didCollapseExpandableLabel(label: EkoExpandableLabel)
}
