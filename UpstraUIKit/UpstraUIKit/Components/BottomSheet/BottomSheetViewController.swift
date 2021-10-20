//
//  BottomSheetViewController.swift
//  AmityUIKit
//
//  Created by Nishan Niraula on 1/23/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import UIKit

/// Custom action sheet type UI for presenting any UIView
///
/// The view consists of 2 parts.
/// - `Header`: The part containing the handle & title
/// - `Content`: The part containing the content to be displayed
///
///
/// - Usage:
/// 1. Create an instance of this class BottomSheetViewController. i.e BottomSheetViewController()
/// 2. Set its  `contentview`
/// 3. Set the modalPresentationStyle to .overCurrentContext or .overFullScreen
/// 4. Present the controller using present with `animated` set to `false`.
///
public protocol BottomSheetComponent where Self: UIView {
    var componentHeight: CGFloat { get }
}

open class BottomSheetViewController: UIViewController {
    
    private var contentContainerView = UIView()
    private var headerContainerView = UIView()
    
    var sheetHandleView: BottomSheetComponent = BottomSheetHandleView()
    var sheetTitleView: BottomSheetComponent = BottomSheetTitleView()
    var sheetSeparatorView: BottomSheetComponent = BottomSheetSeparatorView()
    var sheetContentView: BottomSheetComponent!
    private var sheetTitleViewHeightConstraint: NSLayoutConstraint!
    private var containerBottomConstraint: NSLayoutConstraint!
    private var containerPadding: CGFloat = 16
    
    var isTitleHidden: Bool = false
    
    override open func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = sheetContentView else {
            fatalError("View for showing sheet contents not available")
        }
        
        view.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroundViewTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupHeaderView()
        setupContentView()
        setupContainerView()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentBottomSheet()
    }
    
    private var titleHeight: CGFloat {
        return isTitleHidden ? 0 : sheetTitleView.componentHeight
    }
    
    private func getBottomSheetHeight() -> CGFloat {
        let handleHeight = sheetHandleView.componentHeight
        let separatorHeight = sheetSeparatorView.componentHeight
        let contentHeight = sheetContentView.componentHeight
        
        let bottomSheetHeight = handleHeight + titleHeight + separatorHeight + contentHeight + containerPadding
        let maxContainerHeight = UIScreen.main.bounds.height * 0.9
        
        return min(maxContainerHeight, bottomSheetHeight)
    }
    
    // MARK:- Constraint Setup
    private func setupHeaderView() {
        setupHandleView()
        setupTitleView()
        setupSeparatorView()
        
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(headerContainerView)
        
        let height = sheetHandleView.componentHeight + titleHeight + sheetSeparatorView.componentHeight
        NSLayoutConstraint.activate([
            headerContainerView.widthAnchor.constraint(equalTo: contentContainerView.widthAnchor, constant: 0),
            headerContainerView.heightAnchor.constraint(equalToConstant: height),
            headerContainerView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 0)
        ])
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onHeaderViewSwipe))
        swipeGesture.direction = .down
        headerContainerView.addGestureRecognizer(swipeGesture)
    }
    
    private func setupHandleView() {
        
        sheetHandleView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(sheetHandleView)
        
        NSLayoutConstraint.activate([
            sheetHandleView.heightAnchor.constraint(equalToConstant: sheetHandleView.componentHeight),
            sheetHandleView.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, constant: 0),
            sheetHandleView.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 0)
        ])
    }
    
    private func setupTitleView() {
        sheetTitleView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(sheetTitleView)
        sheetTitleViewHeightConstraint = sheetTitleView.heightAnchor.constraint(equalToConstant: titleHeight)
        NSLayoutConstraint.activate([
            sheetTitleViewHeightConstraint,
            sheetTitleView.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, constant: 0),
            sheetTitleView.topAnchor.constraint(equalTo: sheetHandleView.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupSeparatorView() {
        sheetSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(sheetSeparatorView)
        
        NSLayoutConstraint.activate([
            sheetSeparatorView.heightAnchor.constraint(equalToConstant: sheetSeparatorView.componentHeight),
            sheetSeparatorView.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, constant: 0),
            sheetSeparatorView.topAnchor.constraint(equalTo: sheetTitleView.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupContentView() {
        sheetContentView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(sheetContentView)
        
        NSLayoutConstraint.activate([
            sheetContentView.heightAnchor.constraint(equalToConstant: sheetContentView.componentHeight),
            sheetContentView.widthAnchor.constraint(equalTo: contentContainerView.widthAnchor, constant: 0),
            sheetContentView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 0),
            sheetContentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -containerPadding)
        ])
    }
    
    private func setupContainerView() {
        
        view.addSubview(contentContainerView)
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomSheetHeight = getBottomSheetHeight()
        containerBottomConstraint = contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSheetHeight)
        
        NSLayoutConstraint.activate([
            contentContainerView.heightAnchor.constraint(equalToConstant: bottomSheetHeight),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerBottomConstraint
        ])
        
        contentContainerView.backgroundColor = AmityColorSet.backgroundColor
        contentContainerView.layer.cornerRadius = 6
        contentContainerView.layer.masksToBounds = true
    }
    
    // MARK:- Gesture
    @objc func onBackgroundViewTap(_ sender: UITapGestureRecognizer) {
        let tappedLocation = sender.location(in: self.view)
        let containerViewFrame = contentContainerView.frame
        
        if !containerViewFrame.contains(tappedLocation) {
            dismissBottomSheet()
        }
    }
    
    @objc func onHeaderViewSwipe(_ sender: UISwipeGestureRecognizer) {
        dismissBottomSheet()
    }
    
    // MARK:- Animation
    
    private func presentBottomSheet() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            
            self.view.alpha = 1
            self.containerBottomConstraint.constant = self.containerPadding
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    public func dismissBottomSheet(completion: (() -> Void)? = nil) {
        let sheetHeight = getBottomSheetHeight()
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
            self.containerBottomConstraint.constant = sheetHeight
            self.view.layoutIfNeeded()
        }) { (isComplete) in
            guard isComplete else { return }
            self.dismiss(animated: false, completion: completion)
        }
    }
}

