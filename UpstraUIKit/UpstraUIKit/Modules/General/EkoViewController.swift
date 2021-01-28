//
//  EkoViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 19/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

public enum EkoNavigationBarType {
    /// Style for root view controller, align-left title.
    case root
    
    /// Style for presented view controller, showing with dismiss button.
    case present
    
    /// Style for pushed view controller, showing with back button.
    case push
    
    /// For custom style of navigation bar
    case custom
}

public class EkoViewController: UIViewController {
    
    /// Navigation Style
    public var navigationBarType: EkoNavigationBarType {
        get {
            return userDefinedNavigationBarType ?? defaultNavigationBarType
        }
        set {
            userDefinedNavigationBarType = newValue
            updateNavigationBarLayout()
        }
    }
    
    private var userDefinedNavigationBarType: EkoNavigationBarType?
    private var defaultNavigationBarType: EkoNavigationBarType {
        if navigationController?.viewControllers.count ?? 0 <= 1 {
            return presentingViewController == nil ? .root : .present
        }
        return .push
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = EkoColorSet.base
        label.textAlignment = .center
        return label
    }()
    
    /// Font for title navigation bar
    var titleFont: UIFont? = EkoFontSet.headerLine {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    /// Color for title navigation bar
    var titleColor: UIColor? = EkoColorSet.base {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    /// Text for navigation bar
    public override var title: String? {
        didSet {
            titleLabel.text = title
            if navigationBarType == .root {
                navigationItem.title = nil
                titleLabel.text = title
            }
        }
    }
    
    private var leftBarButtonItem: UIBarButtonItem?
    private let fullWidthBackGestureRecognizer = UIPanGestureRecognizer()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = EkoColorSet.backgroundColor
        leftBarButtonItem = UIBarButtonItem(image: EkoIconSet.iconBack, style: .plain, target: self, action: #selector(didTapLeftBarButton))
        leftBarButtonItem?.tintColor = EkoColorSet.base
        
        // We don't support dark mode yet.
        // Override its value with light mode.
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        updateNavigationBarLayout()
        setupFullWidthBackGesture()
    }

    #if DEBUG
    @objc func titleDoubleTap() {
        navigationController?.popViewController(animated: true)
    }
    #endif
    
    private func updateNavigationBarLayout() {
        navigationController?.reset()
        navigationController?.navigationBar.barTintColor = EkoColorSet.baseInverse
        #if DEBUG
        titleLabel.isUserInteractionEnabled = true
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(titleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        titleLabel.addGestureRecognizer(doubleTapGesture)
        #endif
        switch navigationBarType {
        case .root:
            titleFont = EkoFontSet.headerLine
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
            navigationController?.setBackgroundColor(with: .white)
        case .present:
            titleFont = EkoFontSet.title
            navigationItem.titleView = titleLabel
            leftBarButtonItem?.image = EkoIconSet.iconClose
            navigationItem.leftBarButtonItem = leftBarButtonItem
        case .push:
            titleFont = EkoFontSet.title
            navigationItem.titleView = titleLabel
            leftBarButtonItem?.image = EkoIconSet.iconBack
            navigationItem.leftBarButtonItem = leftBarButtonItem
        case .custom:
            navigationItem.leftBarButtonItem = nil
            break
        }
    }
    
    private func setupFullWidthBackGesture() {
        guard let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer,
            let targets = interactivePopGestureRecognizer.value(forKey: "targets") else {
            return
        }
        fullWidthBackGestureRecognizer.setValue(targets, forKey: "targets")
        fullWidthBackGestureRecognizer.delegate = self
        view.addGestureRecognizer(fullWidthBackGestureRecognizer)
    }
    
    // To support presenting confirmation dialog before dismissing.
    // We provide `didTapLeftBarButton` to be overriden.
    // Otherwise, the default behavior is to call `generalDismiss`.
    @objc func didTapLeftBarButton() {
        generalDismiss()
    }
    
    // This function automatically select how can it be dismissed.
    // It can not be overriden. If needed, let do on `didTapLeftBarButton`.
    //
    // See example on EkoCreatePostViewController
    final func generalDismiss() {
        switch navigationBarType {
        case .root, .custom:
            // Internally left empty
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

extension EkoViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isSystemSwipeToBackEnabled = navigationController?.interactivePopGestureRecognizer?.isEnabled == true
        let isThereStackedViewControllers = navigationController?.viewControllers.count ?? 0 > 1
        return isSystemSwipeToBackEnabled && isThereStackedViewControllers
    }
    
}
