
//
//  PTNToast.swift
//  Potioneer
//
//  Created by PrInCeInFiNiTy on 3/7/2564 BE.
//  Copyright © 2564 BE PrInCeInFiNiTy. All rights reserved.
//

import UIKit
import Foundation

class PTNToast: NSObject {
    
    static var share = PTNToast()
    private let windows = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    private var dismissTimer: Timer?
    private var durationClosePopup: TimeInterval = 2
    private var viewNotification = PTNToastView()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(recognizedTap(_:)))
        return recognizer
    }()
    
    private func initViewPopup(title:String) {
        viewNotification = UINib(nibName: "PTNToastView", bundle: AmityUIKitManager.bundle).instantiate(withOwner: nil, options: nil)[0] as! PTNToastView
        viewNotification.lblTitle.text = title
        viewNotification.frame = hidden()
        viewNotification.addGestureRecognizer(tapGestureRecognizer)
        windows?.addSubview(viewNotification)
    }
    
    private func hidden() -> CGRect {
        return CGRect(x: 0, y: windows?.frame.height ?? 0 + (windows?.safeAreaInsets.bottom ?? 0 + 55), width: windows?.frame.width ?? 0, height: 40)
    }
    
    private func show() -> CGRect {
        return CGRect(x: 0, y: (windows?.frame.height ?? 0) - ((windows?.safeAreaInsets.bottom ?? 0) + 55), width: windows?.frame.width ?? 0, height: 40)
    }
    
    public func present(title:String) {
        initViewPopup(title: title)
        UIView.animate(withDuration: 0.4) {
            self.viewNotification.frame = self.show()
        } completion: { _ in
            self.rescheduleDismissTimer()
        }
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.4) {
            self.viewNotification.frame = self.hidden()
        } completion: { _ in
            self.deleteObject()
        }
    }
    
    @objc private func recognizedTap(_ recognizer: UITapGestureRecognizer) {
        dismiss()
    }
    
    private func invalidateDismissTimerIfNeeded() {
        dismissTimer?.invalidate()
        dismissTimer = nil
    }
    
    private func rescheduleDismissTimer() {
        dismissTimer?.invalidate()
        dismissTimer = nil
        let timer = Timer(timeInterval: durationClosePopup,
                          target: self,
                          selector: #selector(dismiss),
                          userInfo: nil,
                          repeats: false)
        dismissTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func deleteObject() {
        invalidateDismissTimerIfNeeded()
        viewNotification.removeGestureRecognizer(tapGestureRecognizer)
        viewNotification.removeFromSuperview()
    }
    
}
