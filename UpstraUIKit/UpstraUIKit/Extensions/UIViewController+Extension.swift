//
//  UIViewController+Extension.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 1/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AVKit
import AmitySDK

extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    public var isModalPresentation: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    func addChild(viewController: UIViewController, at frame: CGRect? = nil) {
        addChild(viewController)
        viewController.view.frame = frame ?? view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    
    func addContainerView(_ viewController: UIViewController, to containerView: UIView) {
        addChild(viewController)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        viewController.didMove(toParent: self)
    }
    
    func presentVideoPlayer(at url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) { [weak player] in
            player?.play()
        }
    }

}
