//
//  UIViewController+PostCreateDialogue.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 26/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Call this function when the user press create post button.
    func presentCreatePostTypeSelectorDialogue() {
        
        let livestreamPost = ImageItemOption(
            title: "Livestream",
            image: UIImage(named: "icon_create_livestream_post", in: AmityUIKitManager.bundle, compatibleWith: nil),
            completion: { [weak self] in
                self?.dismiss(animated: true) {
                    self?.presentCreatePostTargetSelector(type: .livestream)
                }
        })
        
        let normalPost = ImageItemOption(
            title: "Post",
            image: UIImage(named: "icon_create_normal_post", in: AmityUIKitManager.bundle, compatibleWith: nil),
            completion: { [weak self] in
                self?.dismiss(animated: true) {
                    self?.presentCreatePostTargetSelector(type: .post)
                }
        })
        
        let pollPost = ImageItemOption(
            title: "Poll",
            image: UIImage(named: "icon_create_poll_post", in: AmityUIKitManager.bundle, compatibleWith: nil),
            completion: { [weak self] in
                self?.dismiss(animated: true) {
                    self?.presentCreatePostTargetSelector(type: .poll)
                }
        })
        
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<ImageItemOption>()
        contentView.configure(items: [livestreamPost, normalPost, pollPost], selectedItem: nil)
        
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        present(bottomSheet, animated: false, completion: nil)
        
    }
    
    private func presentCreatePostTargetSelector(type: AmityPostContentType) {
        let vc = AmityPostTargetPickerViewController.make()
        vc.postContentType = type
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true, completion: nil)
    }
    
}
