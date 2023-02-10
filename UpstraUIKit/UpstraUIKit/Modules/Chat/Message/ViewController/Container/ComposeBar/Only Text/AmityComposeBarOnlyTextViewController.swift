//
//  AmityComposeBarOnlyTextViewController.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 9/6/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityComposeBarOnlyTextViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var textComposeBarView: AmityTextComposeBarView!
    @IBOutlet private var sendMessageButton: UIButton!
    @IBOutlet private var trailingStackView: UIStackView!
    
    // MARK: - Properties
    private let screenViewModel: AmityMessageListScreenViewModelType
    let composeBarView = AmityKeyboardComposeBarViewController.make()
    
    // MARK: - View lifecycle
    private init(viewModel: AmityMessageListScreenViewModelType) {
        screenViewModel = viewModel
        super.init(nibName: "AmityComposeBarOnlyTextViewController", bundle: AmityUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    static func make(viewModel: AmityMessageListScreenViewModelType) -> AmityComposeBarOnlyTextViewController {
        return AmityComposeBarOnlyTextViewController(viewModel: viewModel)
    }
    
}

// MARK: - Action
private extension AmityComposeBarOnlyTextViewController {
    
    @IBAction func sendMessageTap() {
        screenViewModel.action.send(withText: textComposeBarView.text)
        clearText()
    }
    
}

// MARK: - Setup View
private extension AmityComposeBarOnlyTextViewController {
    
    func setupView() {
        setupTextComposeBarView()
        setupSendMessageButton()
    }
    
    func setupTextComposeBarView() {
        textComposeBarView.placeholder = AmityLocalizedStringSet.textMessagePlaceholder.localizedString
        textComposeBarView.textViewDidChanged = { [weak self] text in
            self?.screenViewModel.action.setText(withText: text)
        }
        
        textComposeBarView.textViewShouldBeginEditing = { [weak self] textView in
            self?.screenViewModel.action.toggleKeyboardVisible(visible: true)
            self?.screenViewModel.action.inputSource(for: .default)
        }
    }
    
    func setupSendMessageButton() {
        sendMessageButton.setTitle(nil, for: .normal)
        sendMessageButton.setImage(AmityIconSet.iconSendMessage, for: .normal)
        sendMessageButton.isEnabled = false
        sendMessageButton.isHidden = false
    }
    
}

extension AmityComposeBarOnlyTextViewController: AmityComposeBar {
    
    func updateViewDidTextChanged(_ text: String) {
        sendMessageButton.isEnabled = !text.isEmpty
    }
    
    func showRecordButton(show: Bool) {
        // Intentionally left empty
        // This class doesn't support showRecordButton.
    }
    
    func clearText() {
        textComposeBarView.clearText()
    }
    
    var deletingTarget: UIView? {
        get {
            nil
        }
        set {
            // Intentionally left empty
            // This class doesn't support deletingTarget
        }
    }
    
    var isTimeout: Bool {
        get {
            return false
        }
        set {
            // Intentionally left empty
            // This class doesn't support deletingTarget
        }
    }
    
    var selectedMenuHandler: ((AmityKeyboardComposeBarModel.MenuType) -> Void)? {
        get {
            composeBarView.selectedMenuHandler
        }
        set {
            composeBarView.selectedMenuHandler = newValue
        }
    }
    
    func rotateMoreButton(canRotate rotate: Bool) {
        // Intentionally left empty
        // This class doesn't support rotateMoreButton.
    }
    
    func showPopoverMessage() {
        // Intentinally left empty
        // This class doesn't support showPopoverMessage
    }
    
}

