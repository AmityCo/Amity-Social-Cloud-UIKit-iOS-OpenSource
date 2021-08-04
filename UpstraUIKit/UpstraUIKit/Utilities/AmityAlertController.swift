//
//  AmityAlertController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

/**
 * Reusable alert controller
 */
struct AmityAlertController {
    private init() { }
    enum Action {
        case ok(style: UIAlertAction.Style = .default, handler: (() -> Void)?)
        case cancel(style: UIAlertAction.Style = .default , handler: (() -> Void)?)
        case custom(title: String, style: UIAlertAction.Style, handler: (() -> Void)?)
        
        private var title: String {
            switch self {
            case .ok:
                return AmityLocalizedStringSet.General.ok.localizedString
            case .cancel:
                return AmityLocalizedStringSet.General.cancel.localizedString
            case .custom(let title, _, _):
                return title
            }
        }
        
        private var handler: (() -> Void)? {
            switch self {
            case .ok(_, let handler), .cancel(_, let handler), .custom(_, _, let handler):
                return handler
            }
        }
        
        var alertAction: UIAlertAction {
            switch self {
            case .ok(let style, let handler):
                return UIAlertAction(title: title, style: style, handler: { _ in handler?() })
            case .cancel(let style, let handler):
                return UIAlertAction(title: title, style: style, handler: { _ in handler?() })
            case .custom(_, let style, let handler):
                return UIAlertAction(title: title, style: style, handler: { _ in handler?() })
            }
            
        }
    }
    
    /**
     * Actions will add from left -> right
     */
    static func present(title: String?, message: String?, actions: [Action], from viewController: UIViewController, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction($0.alertAction) }
        viewController.present(alertController, animated: true, completion: completion)
    }
}
