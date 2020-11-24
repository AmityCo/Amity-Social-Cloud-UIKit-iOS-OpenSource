//
//  EkoKeyboardService.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

protocol EkoKeyboardServiceDelegate: AnyObject {
    func keyboardWillAppear(service: EkoKeyboardService)
    func keyboardWillDismiss(service: EkoKeyboardService)
    func keyboardWillChange(service: EkoKeyboardService,
                            height: CGFloat,
                            animationDuration: TimeInterval)
}

extension EkoKeyboardServiceDelegate {
    func keyboardWillAppear(service: EkoKeyboardService) {}
    func keyboardWillDismiss(service: EkoKeyboardService) {}
    func keyboardWillChange(service: EkoKeyboardService,
                            newHeight: CGFloat,
                            oldHeight: CGFloat,
                            animationDuration: TimeInterval) {}
}

final class EkoKeyboardService: NSObject {
    static var shared: EkoKeyboardService = EkoKeyboardService()

    private override init() {
        super.init()
        subscribeToKeyboardEvents()
    }

    weak var delegate: EkoKeyboardServiceDelegate?

    func subscribeToKeyboardEvents() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(_:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }

    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        delegate?.keyboardWillAppear(service: self)

        if
            let userInfo: [AnyHashable: Any] = notification.userInfo,
            let durationAny: Any = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
            let duration: TimeInterval = durationAny as? TimeInterval,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardSize.size.height
            delegate?.keyboardWillChange(service: self,
                                         height: keyboardHeight,
                                         animationDuration: duration)
        }
    }

    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        delegate?.keyboardWillDismiss(service: self)

        let duration: TimeInterval
        if
            let userInfo: [AnyHashable: Any] = notification.userInfo,
            let durationAny: Any = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
            let timeInterval: TimeInterval = durationAny as? TimeInterval {
            duration = timeInterval
        } else {
            duration = 0
        }
        delegate?.keyboardWillChange(service: self,
                                     height: 0,
                                     animationDuration: duration)
    }
}
