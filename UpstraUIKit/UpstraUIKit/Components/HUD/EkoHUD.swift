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
    case custom(view: UIView)
    
    var view: UIView {
        switch self {
        case .success(let message):
            return EkoHUDSuccessView(message: message)
        case .error(let message):
            return EkoHUDErrorView(message: message)
        case .loading:
            return EkoHUDLoadingView()
        case .custom(let view):
            return view
        }
    }
}
 
private class EkoAlertModalViewController: UIViewController {
    
    private let containerView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func config(subview: UIView) {
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        containerView.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: containerView.topAnchor),
            subview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
}

#warning("#HUD")
#warning("Please remove this one after refactor EkoHUDErrorView, EkoHUDSuccesView, and EkoHUDLoadingView done and keep using `EkoAlertModalViewController` instead")
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
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 18),
            contentView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -18),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func config(subview: UIView) {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
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
    private let alertModalViewController = EkoAlertModalViewController()
    private var content: HUDContentType?
    private var topViewController: UIViewController? {
        return UIApplication.topViewController()
    }
    private var isPresenting: Bool {
        return topViewController is EkoAlertViewController
            || topViewController is EkoAlertModalViewController
    }
    
    private init() {
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        alertModalViewController.modalPresentationStyle = .overFullScreen
        alertModalViewController.modalTransitionStyle = .crossDissolve
    }

    // MARK: - Public methods
    
    public static func show(_ content: HUDContentType) {
        if sharedHUD.isPresenting {
            sharedHUD.hide {
                sharedHUD.show(content)
            }
        } else {
            sharedHUD.show(content)
        }
    }
    
    public static func hide(_ completion: (() -> Void)? = nil) {
        sharedHUD.hide(completion)
    }

    // MARK: Private methods
    
    private func show(_ content: HUDContentType) {
        self.content = content
        switch content {
        case .success, .error:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                self?.hide()
            }
        case .loading:
            break
        case .custom:
            alertModalViewController.config(subview: content.view)
            topViewController?.present(alertModalViewController, animated: true, completion: nil)
            return
        }
        
        alertViewController.config(subview: content.view)
        topViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    private func hide(_ completion: (() -> Void)? = nil) {
        guard let content = content else { return }
        switch content {
        case .custom:
            alertModalViewController.dismiss(animated: true, completion: completion)
        default:
            alertViewController.dismiss(animated: true, completion: completion)
        }
        self.content = nil
    }
    
}
