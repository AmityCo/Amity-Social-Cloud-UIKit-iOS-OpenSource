//
//  EkoPostFooterProtocolHandler.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import Foundation
enum EkoPostFooterProtocolHandlerAction {
    case tapLike
    case tapComment
}
protocol EkoPostFooterProtocolHandlerDelegate: class {
    func footerProtocolHandlerDidPerformAction(_ handler: EkoPostFooterProtocolHandler, action: EkoPostFooterProtocolHandlerAction, withPost post: EkoPostModel)
}

final class EkoPostFooterProtocolHandler: EkoPostFooterDelegate {
    weak var delegate: EkoPostFooterProtocolHandlerDelegate?
    
    private weak var viewController: EkoViewController?
    
    init(viewController: EkoViewController) {
        self.viewController = viewController
    }
    
    func didPerformAction(_ cell: EkoPostFooterProtocol, action: EkoPostFooterAction) {
        guard let post = cell.post else { return }
        switch action {
        case .tapLike:
            delegate?.footerProtocolHandlerDidPerformAction(self, action: .tapLike, withPost: post)
        case .tapComment:
            delegate?.footerProtocolHandlerDidPerformAction(self, action: .tapComment, withPost: post)
        case .tapShare:
            handleShareOption(post: post)
        }
    }
    
    private func handleShareOption(post: EkoPostModel) {
        guard let viewController = viewController else { return }
        let bottomSheet = BottomSheetViewController()
        
        let shareToTimeline = TextItemOption(title: EkoLocalizedStringSet.SharingType.shareToMyTimeline.localizedString)
        let shareToGroup = TextItemOption(title: EkoLocalizedStringSet.SharingType.shareToGroup.localizedString)
        let moreOptions = TextItemOption(title: EkoLocalizedStringSet.SharingType.moreOptions.localizedString)
        
        var items = [TextItemOption]()
        
        if EkoPostSharePermission.canShareToMyTimeline(post: post) {
            items.append(shareToTimeline)
        }
        
        if EkoPostSharePermission.canSharePostToGroup(post: post) {
            items.append(shareToGroup)
        }
        
        if EkoPostSharePermission.canSharePostToExternal(post: post) {
            items.append(moreOptions)
        }
        
        if items.isEmpty { return }
        
        let contentView = ItemOptionView<TextItemOption>()
        contentView.configure(items: items, selectedItem: nil)
        contentView.didSelectItem = { [weak bottomSheet] action in
            bottomSheet?.dismissBottomSheet {
                switch action {
                case shareToTimeline:
                    EkoFeedEventHandler.shared.sharePostToMyTimelineDidTap(from: viewController, postId: post.id)
                case shareToGroup:
                    EkoFeedEventHandler.shared.sharePostToGroupDidTap(from: viewController, postId: post.id)
                case moreOptions:
                    EkoFeedEventHandler.shared.sharePostDidTap(from: viewController, postId: post.id)
                default: break
                }
            }
        }
        
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        viewController.present(bottomSheet, animated: false, completion: nil)
    }
}
