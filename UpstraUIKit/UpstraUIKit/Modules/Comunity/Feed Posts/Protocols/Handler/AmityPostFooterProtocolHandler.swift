//
//  AmityPostFooterProtocolHandler.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation
enum AmityPostFooterProtocolHandlerAction {
    case tapLike
    case tapComment
    case tapReactionDetails
}
protocol AmityPostFooterProtocolHandlerDelegate: AnyObject {
    func footerProtocolHandlerDidPerformAction(_ handler: AmityPostFooterProtocolHandler, action: AmityPostFooterProtocolHandlerAction, withPost post: AmityPostModel)
}

final class AmityPostFooterProtocolHandler: AmityPostFooterDelegate {
    weak var delegate: AmityPostFooterProtocolHandlerDelegate?
    
    private weak var viewController: AmityViewController?
    
    init(viewController: AmityViewController) {
        self.viewController = viewController
    }
    
    func didPerformAction(_ cell: AmityPostFooterProtocol, action: AmityPostFooterAction) {
        guard let post = cell.post else { return }
        switch action {
        case .tapLike:
            delegate?.footerProtocolHandlerDidPerformAction(self, action: .tapLike, withPost: post)
        case .tapReactionDetails:
            delegate?.footerProtocolHandlerDidPerformAction(self, action: .tapReactionDetails, withPost: post)
        case .tapComment:
            delegate?.footerProtocolHandlerDidPerformAction(self, action: .tapComment, withPost: post)
        case .tapShare:
            handleShareOption(post: post)
        }
    }
    
    private func handleShareOption(post: AmityPostModel) {
        guard let viewController = viewController else { return }
        let bottomSheet = BottomSheetViewController()
        
        let shareToTimeline = TextItemOption(title: AmityLocalizedStringSet.SharingType.shareToMyTimeline.localizedString)
        let shareToGroup = TextItemOption(title: AmityLocalizedStringSet.SharingType.shareToGroup.localizedString)
        let moreOptions = TextItemOption(title: AmityLocalizedStringSet.SharingType.moreOptions.localizedString)
        
        var items = [TextItemOption]()
        
        if AmityPostSharePermission.canShareToMyTimeline(post: post) {
            items.append(shareToTimeline)
        }
        
        if AmityPostSharePermission.canSharePostToGroup(post: post) {
            items.append(shareToGroup)
        }
        
        if AmityPostSharePermission.canSharePostToExternal(post: post) {
            items.append(moreOptions)
        }
        
        if items.isEmpty { return }
        
        let contentView = ItemOptionView<TextItemOption>()
        contentView.configure(items: items, selectedItem: nil)
        contentView.didSelectItem = { [weak bottomSheet] action in
            bottomSheet?.dismissBottomSheet {
                switch action {
                case shareToTimeline:
                    AmityFeedEventHandler.shared.sharePostToMyTimelineDidTap(from: viewController, postId: post.postId)
                case shareToGroup:
                    AmityFeedEventHandler.shared.sharePostToGroupDidTap(from: viewController, postId: post.postId)
                case moreOptions:
                    AmityFeedEventHandler.shared.sharePostDidTap(from: viewController, postId: post.postId)
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
