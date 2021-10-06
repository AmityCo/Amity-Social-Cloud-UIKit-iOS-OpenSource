//
//  EkoComposeBarOnlyTextViewController.swift
//  UpstraUIKit
//
//  Created by Nutchaphon Rewik on 9/6/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class EkoComposeBarOnlyTextViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var textComposeBarView: EkoTextComposeBarView!
    @IBOutlet private var sendMessageButton: UIButton!
    @IBOutlet private var trailingStackView: UIStackView!
    
    // MARK: - Properties
    private let screenViewModel: EkoMessageListScreenViewModelType
    let composeBarView = EkoKeyboardComposeBarViewController.make()
    
    // MARK: - View lifecycle
    private init(viewModel: EkoMessageListScreenViewModelType) {
        screenViewModel = viewModel
        super.init(nibName: "EkoComposeBarOnlyTextViewController", bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    static func make(viewModel: EkoMessageListScreenViewModelType) -> EkoComposeBarOnlyTextViewController {
        return EkoComposeBarOnlyTextViewController(viewModel: viewModel)
    }
    
}

// MARK: - Action
private extension EkoComposeBarOnlyTextViewController {
    
    @IBAction func sendMessageTap() {
        screenViewModel.action.send(withText: textComposeBarView.text)
    }
    
}

// MARK: - Setup View
private extension EkoComposeBarOnlyTextViewController {
    
    func setupView() {
        setupTextComposeBarView()
        setupSendMessageButton()
    }
    
    func setupTextComposeBarView() {
        textComposeBarView.placeholder = EkoLocalizedStringSet.textMessagePlaceholder.localizedString
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
        sendMessageButton.setImage(EkoIconSet.iconSendMessage, for: .normal)
        sendMessageButton.isEnabled = false
        sendMessageButton.isHidden = false
    }
    
}

extension EkoComposeBarOnlyTextViewController: EkoComposeBar {
    
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
    
    var selectedMenuHandler: ((EkoKeyboardComposeBarModel.MenuType) -> Void)? {
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

