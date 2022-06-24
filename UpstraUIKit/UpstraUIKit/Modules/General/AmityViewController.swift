//
//  AmityViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 19/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

public enum AmityNavigationBarType {
    /// Style for root view controller, align-left title.
    case root
    
    /// Style for presented view controller, showing with dismiss button.
    case present
    
    /// Style for pushed view controller, showing with back button.
    case push
    
    /// For custom style of navigation bar
    case custom
}

open class AmityViewController: UIViewController {
    
    /// Navigation Style
    open var navigationBarType: AmityNavigationBarType {
        get {
            return userDefinedNavigationBarType ?? defaultNavigationBarType
        }
        set {
            userDefinedNavigationBarType = newValue
            updateNavigationBarLayout()
        }
    }
    
    private var userDefinedNavigationBarType: AmityNavigationBarType?
    private var defaultNavigationBarType: AmityNavigationBarType {
        if navigationController?.viewControllers.count ?? 0 <= 1 {
            return presentingViewController == nil ? .root : .present
        }
        return .push
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AmityColorSet.base
        label.textAlignment = .center
        return label
    }()
    
    /// Font for title navigation bar
    var titleFont: UIFont? = AmityFontSet.headerLine {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    /// Color for title navigation bar
    var titleColor: UIColor? = AmityColorSet.base {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    /// Text for navigation bar
    open override var title: String? {
        didSet {
            titleLabel.text = title
            if navigationBarType == .root {
                navigationItem.title = nil
                titleLabel.text = title
            }
            titleLabel.sizeToFit()
        }
    }
    
    private var leftBarButtonItem: UIBarButtonItem?
    private let fullWidthBackGestureRecognizer = UIPanGestureRecognizer()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AmityColorSet.backgroundColor
        leftBarButtonItem = UIBarButtonItem(image: AmityIconSet.iconBack, style: .plain, target: self, action: #selector(didTapLeftBarButton))
        leftBarButtonItem?.tintColor = AmityColorSet.base
        
        // We don't support dark mode yet.
        // Override its value with light mode.
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        updateNavigationBarLayout()
        setupFullWidthBackGesture()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarLayout()
    }

    #if DEBUG
    @objc func titleDoubleTap() {
        navigationController?.popViewController(animated: true)
    }
    #endif
    
    private func updateNavigationBarLayout() {
        navigationController?.reset()
        navigationController?.navigationBar.barTintColor = AmityColorSet.baseInverse
        #if DEBUG
        titleLabel.isUserInteractionEnabled = true
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(titleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        titleLabel.addGestureRecognizer(doubleTapGesture)
        #endif
        switch navigationBarType {
        case .root:
            titleFont = AmityFontSet.headerLine
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
            navigationController?.setBackgroundColor(with: .white)
        case .present:
            titleFont = AmityFontSet.title
            navigationItem.titleView = titleLabel
            leftBarButtonItem?.image = AmityIconSet.iconClose
            navigationItem.leftBarButtonItem = leftBarButtonItem
        case .push:
            titleFont = AmityFontSet.title
            navigationItem.titleView = titleLabel
            leftBarButtonItem?.image = AmityIconSet.iconBack
            navigationItem.leftBarButtonItem = leftBarButtonItem
        case .custom:
            //It call after setup navi in MessageList, so I comment it.
//            navigationItem.leftBarButtonItem = nil
            break
        }
    }

    // To support swipe back gesture
    // setup swipe back gesture
    func setupFullWidthBackGesture() {
        guard let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer,
            let targets = interactivePopGestureRecognizer.value(forKey: "targets") else {
            return
        }
        fullWidthBackGestureRecognizer.setValue(targets, forKey: "targets")
        fullWidthBackGestureRecognizer.delegate = self
        view.addGestureRecognizer(fullWidthBackGestureRecognizer)
    }
    
    // This function is to disable swipe to back functionality
    // after it gets called, the view controller will no longer reflect swipe to back action.
    public func removeSwipeBackGesture() {
        view.removeGestureRecognizer(fullWidthBackGestureRecognizer)
    }

    // To support presenting confirmation dialog before dismissing.
    // We provide `didTapLeftBarButton` to be overriden.
    // Otherwise, the default behavior is to call `generalDismiss`.
    @objc open func didTapLeftBarButton() {
        generalDismiss()
    }
    
    // This function automatically select how can it be dismissed.
    // It can not be overriden. If needed, let do on `didTapLeftBarButton`.
    //
    // See example on AmityCreatePostViewController
    public final func generalDismiss() {
        switch navigationBarType {
        case .root, .custom:
            // Intentionally left empty
            break
        case .present:
            dismiss(animated: true, completion: nil)
        case .push:
            navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Dismiss keyboard
    @objc private func dismissKeyboardOnTouchView() {
        view.endEditing(true)
    }
    
    func dismissKeyboardFromVC() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTouchView))
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
}

extension AmityViewController: UIGestureRecognizerDelegate {
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isSystemSwipeToBackEnabled = navigationController?.interactivePopGestureRecognizer?.isEnabled == false
        let isThereStackedViewControllers = navigationController?.viewControllers.count ?? 0 > 1
        return isSystemSwipeToBackEnabled && isThereStackedViewControllers
    }
    
}
