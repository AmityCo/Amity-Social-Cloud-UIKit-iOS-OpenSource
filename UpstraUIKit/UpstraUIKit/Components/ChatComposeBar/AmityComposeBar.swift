//
//  AmityComposeBar.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 8/6/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

/// Since we support replacing compose bar with different styles.
/// At least all compose bar should conform to this protocol, and provide the following functions.
///
/// - Note: If your compose bar doesn't support some functionalities, just implement the function by returning the default value/ or do nothing.
///
/// Currently `AmityComposeBar`, is extracted from the existing implementation, that assume all functionalities works with `AmityMessageListViewController`.
///
/// For future improvement...
/// To properly make compose bar easily replaceable, the `AmityComposeBar` protocol and the flow  of `AmityMessageListViewController` need be refactored.
///
protocol AmityComposeBar: AnyObject {
    
    func updateViewDidTextChanged(_ text: String)
    
    func rotateMoreButton(canRotate: Bool)
    
    func showPopoverMessage()
    
    func clearText()
    
    func showRecordButton(show: Bool)
    
    var deletingTarget: UIView? { get set }
    
    var isTimeout: Bool { get set }
    
    var selectedMenuHandler: ((AmityKeyboardComposeBarModel.MenuType) -> Void)? { get set }
    
}
