//
//  EkoHUD.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 8/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

enum HUDContentType {
    case success(message: String)
    case error(message: String)
    case loading
}

class EkoAlertViewController: UIViewController {
    
    let contentView = UIView()
    private let dismissButton = UIButton()
    var dismissHandler: ((UIViewController) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(contentView)
        view.addSubview(dismissButton)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor) ])
    }
    
    func config(subview: UIView) {
        if !contentView.subviews.isEmpty {
            for subview in contentView.subviews {
                subview.removeFromSuperview()
            }
        }
        contentView.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subview.topAnchor.constraint(equalTo: contentView.topAnchor),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc func dismissTap() {
        dismissHandler?(self)
    }
    
}

class EkoHUD {
    
    private static let sharedHUD = EkoHUD()
    private let alertViewController = EkoAlertViewController()
    private var topViewController: UIViewController? {
        return UIApplication.topViewController()
    }
    
    private init() {
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
    }

    // MARK: - Public methods
    
    public static func show(_ content: HUDContentType) {
        sharedHUD.show(content)
    }
    
    public static func hide(_ completion: (() -> Void)? = nil) {
        sharedHUD.hide(completion)
    }

    // MARK: Private methods
    
    private func show(_ content: HUDContentType) {
        let subview = contentView(content)
        
        switch content {
        case .success, .error:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                self?.hide()
            }
        case .loading:
            break
        }
        
        alertViewController.config(subview: subview)
        topViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    private func hide(_ completion: (() -> Void)? = nil) {
        alertViewController.dismiss(animated: true, completion: completion)
    }
        
    private func contentView(_ contentType: HUDContentType) -> UIView {
        switch contentType {
        case .success(let message):
            return EkoHUDSuccessView(message: message)
        case .error(let message):
            return EkoHUDErrorView(message: message)
        case .loading:
            return EkoHUDLoadingView()
        }
    }
    
}
