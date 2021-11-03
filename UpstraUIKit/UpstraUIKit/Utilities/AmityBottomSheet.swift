//
//  AmityBottomSheet.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 20/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

/**
 * Wrapped to create the bottom sheet
 */
struct AmityBottomSheet {
    
    static func present<T: ItemOption>(options: [T],
                                       selectedItem: T? = nil,
                                       isTitleHidden: Bool = true,
                                       from viewController: UIViewController?,
                                       completion: (() -> Void)? = nil) {
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<T>()
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = isTitleHidden
        bottomSheet.modalPresentationStyle = .overFullScreen
        contentView.configure(items: options, selectedItem: selectedItem)
        viewController?.present(bottomSheet, animated: true, completion: completion)
    }
}
