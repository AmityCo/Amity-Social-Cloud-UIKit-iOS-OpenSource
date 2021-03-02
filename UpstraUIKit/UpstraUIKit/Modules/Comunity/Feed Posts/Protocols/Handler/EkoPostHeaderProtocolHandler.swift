//
//  EkoPostHeaderProtocolHandler.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

enum EkoPostProtocolHeaderHandlerAction {
    case tapOption
    case tapDelete
    case tapReport
    case tapUnreport
}

protocol EkoPostHeaderProtocolHandlerDelegate: class {
    func headerProtocolHandlerDidPerformAction(_ handler: EkoPostHeaderProtocolHandler, action: EkoPostProtocolHeaderHandlerAction, withPost post: EkoPostModel)
}

final class EkoPostHeaderProtocolHandler: EkoPostHeaderDelegate {
    weak var delegate: EkoPostHeaderProtocolHandlerDelegate?
    
    private weak var viewController: EkoViewController?
    private var isReported: Bool = false
    
    init(viewController: EkoViewController) {
        self.viewController = viewController
    }
    
    func updateReportPostStatus(isReported: Bool) {
        self.isReported = isReported
    }
    
    func didPerformAction(_ cell: EkoPostHeaderProtocol, action: EkoPostHeaderAction) {
        guard let viewController = viewController, let post = cell.post else { return }
        switch action {
        case .tapAvatar, .tapDisplayName:
            EkoEventHandler.shared.userDidTap(from: viewController, userId: post.postedUserId)
        case .tapCommunityName:
            EkoEventHandler.shared.communityDidTap(from: viewController, communityId: post.communityId ?? "")
        case .tapOption:
            delegate?.headerProtocolHandlerDidPerformAction(self, action: .tapOption, withPost: post)
            handlePostOption(post: post)
        }
    }
    
    private func handlePostOption(post: EkoPostModel) {
        guard let viewController = viewController else { return }
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<TextItemOption>()
        bottomSheet.isTitleHidden = true
        bottomSheet.sheetContentView = contentView
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        if post.isOwner {
            let editOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.editPost.localizedString) {
                EkoEventHandler.shared.editPostDidTap(from: viewController, postId: post.id)
            }
            let deleteOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.deletePost.localizedString) { [weak self] in
                guard let strongSelf = self else { return }
                // delete option
                let alert = UIAlertController(title: EkoLocalizedStringSet.PostDetail.deletePostTitle.localizedString, message: EkoLocalizedStringSet.PostDetail.deletePostMessage.localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.delete.localizedString, style: .destructive, handler: { _ in
                    strongSelf.delegate?.headerProtocolHandlerDidPerformAction(strongSelf, action: .tapDelete, withPost: post)
                }))
                viewController.present(alert, animated: true, completion: nil)
            }
            
            contentView.configure(items: [editOption, deleteOption], selectedItem: nil)
            viewController.present(bottomSheet, animated: false, completion: nil)
        } else {
            if isReported {
                let unreportOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.unreportPost.localizedString) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.headerProtocolHandlerDidPerformAction(strongSelf, action: .tapUnreport, withPost: post)
                }
                contentView.configure(items: [unreportOption], selectedItem: nil)
            } else {
                let reportOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.reportPost.localizedString) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.headerProtocolHandlerDidPerformAction(strongSelf, action: .tapReport, withPost: post)
                }
                contentView.configure(items: [reportOption], selectedItem: nil)
            }
            viewController.present(bottomSheet, animated: false, completion: nil)
            
        }
    }
}
