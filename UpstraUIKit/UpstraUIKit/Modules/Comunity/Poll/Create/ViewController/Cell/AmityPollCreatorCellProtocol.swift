//
//  AmityPollCreatorCellProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol AmityPollCreatorCellProtocolDelegate: AnyObject {
    func didPerformAction(_ cell: AmityPollCreatorCellProtocol, action: AmityPollCreatorCellAction)
    func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

protocol AmityPollCreatorCellProtocol {
    var delegate: AmityPollCreatorCellProtocolDelegate? { get set }
    
    /// FIXME:
    /// Don't store indexpath inside cell. We can get indexPath for cell using tableview.indexPath(for: ) method.
    var indexPath: IndexPath? { get set }
}

enum AmityPollCreatorCellAction {
    case textViewDidChange(textView: AmityTextView)
    case textViewDidChangeSelection(textView: AmityTextView)
    case multipleSelectionChange(isMultiple: Bool)
    case selectSchedule
    case addAnswerOption
    case updateAnswerOption(text: String?)
    case deleteAnswerOption
}

enum AmityPollCreatorConstant {
    static let questionMax = 500
    static let answerMax = 200
    static let optionMax = 10
}
