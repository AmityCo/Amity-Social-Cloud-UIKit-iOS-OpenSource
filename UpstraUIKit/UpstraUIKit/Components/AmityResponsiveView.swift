//
//  AmityResponsiveView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

final class AmityResponsiveView: UIView {
    
    // MAKR: - Properties
    var duration: TimeInterval = 0.3
    var menuItems: [UIMenuItem] = []
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#292B32").withAlphaComponent(0.5)
        view.layer.cornerRadius = 4
        return view
    }()

    func showOverlayView() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func removeOverlayView() {
        overlayView.removeFromSuperview()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        clipsToBounds = true
        layer.masksToBounds = true
        isUserInteractionEnabled = true
        // Add a long press gesture recognizer to our responsive view
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressTap))
        longPress.minimumPressDuration = duration
        addGestureRecognizer(longPress)
        
        NotificationCenter.default.addObserver(self, selector: #selector(observeWillHide), name: UIMenuController.willHideMenuNotification, object: nil)
    }
    
    @objc
    private func observeWillHide() {
        removeOverlayView()
    }
    
    @objc
    private func longPressTap(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began,
            let senderView = sender.view,
            let superView = sender.view?.superview else {
            return
        }
        
        showOverlayView()
        
        // Make responsiveView the window's first responder
        senderView.becomeFirstResponder()

        UIMenuController.shared.menuItems = menuItems
        UIMenuController.shared.showMenu(from: superView, rect: senderView.frame)
    }
}
