//
//  AmityMessageListComposeBarViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

final class AmityMessageListComposeBarViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet var textComposeBarView: AmityTextComposeBarView!
    @IBOutlet var sendMessageButton: UIButton!
    @IBOutlet private var showKeyboardComposeBarButton: UIButton!
    @IBOutlet private var showAudioButton: UIButton!
    @IBOutlet private var showDefaultKeyboardButton: UIButton!
    @IBOutlet var recordButton: AmityRecordingButton!
    @IBOutlet private var trailingStackView: UIStackView!
    
    // MARK: - Properties
    private var screenViewModel: AmityMessageListScreenViewModelType!
    let composeBarView = AmityKeyboardComposeBarViewController.make()
    
    // MARK: - Settings
    private var setting = AmityMessageListViewController.Settings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    static func make(viewModel: AmityMessageListScreenViewModelType, setting: AmityMessageListViewController.Settings) -> AmityMessageListComposeBarViewController {
        let vc = AmityMessageListComposeBarViewController(
            nibName: AmityMessageListComposeBarViewController.identifier,
            bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        vc.setting = setting
        return vc
    }
    
}

// MARK: - Action
private extension AmityMessageListComposeBarViewController {
    
    @IBAction func sendMessageTap() {
        screenViewModel.action.send(withText: textComposeBarView.text)
        clearText()
    }
    
    @IBAction func showKeyboardComposeBarTap() {
        screenViewModel.action.toggleInputSource()
        showRecordButton(show: false)
    }
    
    @IBAction func toggleDefaultKeyboardAndAudioKeyboardTap(_ sender: UIButton) {
        AmityAudioRecorder.shared.requestPermission()
        screenViewModel.action.toggleShowDefaultKeyboardAndAudioKeyboard(sender)
    }
    
    // MARK: - Audio Recording
    @IBAction func touchDown(sender: AmityRecordingButton) {
        screenViewModel.action.performAudioRecordingEvents(for: .show)
    }
}

// MARK: - Setup View
private extension AmityMessageListComposeBarViewController {
    
    func setupView() {
        setupTextComposeBarView()
        setupSendMessageButton()
        setupShowKeyboardComposeBarButton()
        setupLeftItems()
        setupRecordButton()
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
        sendMessageButton.isHidden = true
    }
    
    func setupShowKeyboardComposeBarButton() {
        showKeyboardComposeBarButton.setTitle(nil, for: .normal)
        showKeyboardComposeBarButton.setImage(AmityIconSet.iconAdd, for: .normal)
        showKeyboardComposeBarButton.tintColor = AmityColorSet.base.blend(.shade1)
        showKeyboardComposeBarButton.isHidden = false
    }
    
    func setupLeftItems() {
        showAudioButton.isHidden = setting.shouldHideAudioButton
        showAudioButton.setImage(AmityIconSet.Chat.iconVoiceMessageGrey, for: .normal)
        showAudioButton.tag = 0
        
        showDefaultKeyboardButton.isHidden = true
        showDefaultKeyboardButton.setImage(AmityIconSet.Chat.iconKeyboard, for: .normal)
        showDefaultKeyboardButton.tag = 1
    }
    
    func setupRecordButton() {
        recordButton.layer.cornerRadius = 4
        recordButton.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        recordButton.titleLabel?.font = AmityFontSet.bodyBold
        recordButton.setTitleColor(AmityColorSet.base, for: .normal)
        recordButton.setImage(AmityIconSet.Chat.iconMic, for: .normal)
        recordButton.setTitle(AmityLocalizedStringSet.MessageList.holdToRecord.localizedString, for: .normal)
        recordButton.tintColor = AmityColorSet.base
        recordButton.isHidden = true
        
        recordButton.deleteHandler = { [weak self] in
            self?.screenViewModel.action.performAudioRecordingEvents(for: .delete)
        }
        
        recordButton.recordHandler = { [weak self] in
            self?.screenViewModel.action.performAudioRecordingEvents(for: .record)
        }
        
        recordButton.deletingHandler = { [weak self] in
            self?.screenViewModel.action.performAudioRecordingEvents(for: .deleting)
        }
        
        recordButton.recordingHandler = { [weak self] in
            self?.screenViewModel.action.performAudioRecordingEvents(for: .cancelingDelete)
        }
    }
}

extension AmityMessageListComposeBarViewController: AmityComposeBar {
    
    func updateViewDidTextChanged(_ text: String) {
        sendMessageButton.isEnabled = !text.isEmpty
        showKeyboardComposeBarButton.isHidden = !text.isEmpty
        sendMessageButton.isHidden = text.isEmpty
    }
    
    func showRecordButton(show: Bool) {
        if show {
            trailingStackView.isHidden = true
            textComposeBarView.isHidden = true
            recordButton.isHidden = false
            showAudioButton.isHidden = setting.shouldHideAudioButton
            showDefaultKeyboardButton.isHidden = false
            textComposeBarView.textView.resignFirstResponder()
        } else {
            trailingStackView.isHidden = false
            textComposeBarView.isHidden = false
            recordButton.isHidden = true
            showAudioButton.isHidden = setting.shouldHideAudioButton
            showDefaultKeyboardButton.isHidden = true
            if textComposeBarView.text != "" {
                sendMessageButton.isHidden = false
                showKeyboardComposeBarButton.isHidden = true
            } else {
                showKeyboardComposeBarButton.isHidden = false
                sendMessageButton.isHidden = true
            }
        }
    }
    
    func clearText() {
        textComposeBarView.clearText()
    }
    
    var deletingTarget: UIView? {
        get {
            recordButton.deletingTarget
        }
        set {
            recordButton.deletingTarget = newValue
        }
    }
    
    var isTimeout: Bool {
        get {
            recordButton.isTimeout
        }
        set {
            recordButton.isTimeout = newValue
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
        if rotate {
            // for show keyboard compose bar menu
            animationForRotation(with: CGFloat.pi * 0.25, animation: { [weak self] in
                self?.textComposeBarView.inputView = self?.composeBarView.view
                self?.textComposeBarView.reloadInputViews()
                self?.textComposeBarView.becomeFirstResponder()
            })
        } else {
            // for show keyboard default
            animationForRotation(with: 0, animation: { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.screenViewModel.dataSource.isKeyboardVisible() {
                    if strongSelf.textComposeBarView.inputView != nil {
                        strongSelf.textComposeBarView.inputView = nil
                        strongSelf.textComposeBarView.resignFirstResponder()
                    }
                    
                    if !strongSelf.textComposeBarView.becomeFirstResponder() {
                        strongSelf.textComposeBarView.textView.becomeFirstResponder()
                    }
                } else {
                    strongSelf.textComposeBarView.textView.resignFirstResponder()
                }
            })
        }
    }
    
    func animationForRotation(with angle: CGFloat, animation: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.showKeyboardComposeBarButton.transform = CGAffineTransform(rotationAngle: angle)
            animation()
        })
    }
    
    func showPopoverMessage() {
        let vc = AmityPopoverMessageViewController.make()
        vc.text = AmityLocalizedStringSet.PopoverText.popoverMessageIsTooShort.localizedString
        vc.modalPresentationStyle = .popover
        
        let popover = vc.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .down
        popover?.sourceView = recordButton
        popover?.sourceRect = recordButton.bounds
        present(vc, animated: true, completion: nil)
    }
    
}

extension AmityMessageListComposeBarViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
