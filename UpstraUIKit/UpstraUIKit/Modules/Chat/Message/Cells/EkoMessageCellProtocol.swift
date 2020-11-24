//
//  EkoMessageListCellProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import EkoChat

public protocol EkoMessageCellProtocol: UITableViewCell {
    static var cellIdentifier: String { get }
    func display(message: EkoMessageModel)
}

public extension EkoMessageCellProtocol {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

protocol EkoMessageCellDelegate: class {
    func didAction(_ cell: EkoMessageTableViewCell, action: EkoMessageCellAction)
}

enum EkoMessageCellAction {
    case edit
    case delete
    case report
    case tapImage(imageView: UIImageView)
}

