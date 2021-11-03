//
//  LiveStreamBroadcastVC+Keyboard.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 1/9/2564 BE.
//

import UIKit

extension LiveStreamBroadcastViewController {
    
    func observeKeyboardFrame() {
        
        // willShow
        let a = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {  [weak self] notification in
            guard let keyboardSize = (notification.userInfo?[UIView.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            self?.keyboardIsHidden = false
            self?.keyboardHeight = keyboardSize.height
            self?.updateUIBaseOnKeyboardFrame()
        }
        
        // willHide
        let b = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main ) {  [weak self] notification in
            self?.keyboardIsHidden = true
            self?.updateUIBaseOnKeyboardFrame()
        }
        
        // willChange
        let c = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main ) {  [weak self] notification in
            guard let keyboardSize = (notification.userInfo?[UIView.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            self?.keyboardHeight = keyboardSize.height
            self?.updateUIBaseOnKeyboardFrame()
        }
        
        keyboardObservationTokens = [a, b, c]
        
    }
    
    func unobserveKeyboardFrame() {
        keyboardObservationTokens = []
    }
    
}
