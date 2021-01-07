//
//  EkoMessageListComposeBarViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoMessageListComposeBarViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet var textComposeBarView: EkoTextComposeBarView!
    @IBOutlet var sendMessageButton: UIButton!
    @IBOutlet private var showKeyboardComposeBarButton: UIButton!
    @IBOutlet private var showAudioButton: UIButton!
    @IBOutlet private var showDefaultKeyboardButton: UIButton!
    @IBOutlet var recordButton: EkoRecordingButton!
    @IBOutlet private var trailingStackView: UIStackView!
    
    // MARK: - Properties
    private let screenViewModel: EkoMessageListScreenViewModelType
    let composeBarView = EkoKeyboardComposeBarViewController.make()
    
    // MARK: - View lifecycle
    private init(viewModel: EkoMessageListScreenViewModelType) {
        screenViewModel = viewModel
        super.init(nibName: EkoMessageListComposeBarViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    static func make(viewModel: EkoMessageListScreenViewModelType) -> EkoMessageListComposeBarViewController {
        return EkoMessageListComposeBarViewController(viewModel: viewModel)
    }
    
}

// MARK: - Action
private extension EkoMessageListComposeBarViewController {
    @IBAction func sendMessageTap() {
        screenViewModel.action.send(withText: textComposeBarView.text)
    }
    
    @IBAction func showKeyboardComposeBarTap() {
        screenViewModel.action.toggleInputSource()
        showRecordButton(show: false)
    }
    
    @IBAction func toggleDefaultKeyboardAndAudioKeyboardTap(_ sender: UIButton) {
        EkoAudioRecorder.shared.requestPermission()
        screenViewModel.action.toggleShowDefaultKeyboardAndAudioKeyboard(sender)
    }
    
    // MARK: - Audio Recording
    @IBAction func touchDown(sender: EkoRecordingButton) {
        screenViewModel.action.performAudioRecordingEvents(for: .show)
    }
}

// MARK: - Setup View
private extension EkoMessageListComposeBarViewController {
    func setupView() {
        setupTextComposeBarView()
        setupSendMessageButton()
        setupShowKeyboardComposeBarButton()
        setupLeftItems()
        setupRecordButton()
    }
    
    func setupTextComposeBarView() {
        textComposeBarView.placeholder = EkoLocalizedStringSet.textMessagePlaceholder
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
        sendMessageButton.isHidden = true
    }
    
    func setupShowKeyboardComposeBarButton() {
        showKeyboardComposeBarButton.setTitle(nil, for: .normal)
        showKeyboardComposeBarButton.setImage(EkoIconSet.iconAdd, for: .normal)
        showKeyboardComposeBarButton.tintColor = EkoColorSet.base.blend(.shade1)
        showKeyboardComposeBarButton.isHidden = false
    }
    
    func setupLeftItems() {
        showAudioButton.isHidden = false
        showAudioButton.setImage(EkoIconSet.Chat.iconVoiceMessageGrey, for: .normal)
        showAudioButton.tag = 0
        
        showDefaultKeyboardButton.isHidden = true
        showDefaultKeyboardButton.setImage(EkoIconSet.Chat.iconKeyboard, for: .normal)
        showDefaultKeyboardButton.tag = 1
    }
    
    func setupRecordButton() {
        recordButton.layer.cornerRadius = 4
        recordButton.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        recordButton.titleLabel?.font = EkoFontSet.bodyBold
        recordButton.setTitleColor(EkoColorSet.base, for: .normal)
        recordButton.setImage(EkoIconSet.Chat.iconMic, for: .normal)
        recordButton.setTitle(EkoLocalizedStringSet.MessageList.holdToRecord, for: .normal)
        recordButton.tintColor = EkoColorSet.base
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

// MARK: - Update views
extension EkoMessageListComposeBarViewController {
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
            showAudioButton.isHidden = true
            showDefaultKeyboardButton.isHidden = false
        } else {
            trailingStackView.isHidden = false
            textComposeBarView.isHidden = false
            recordButton.isHidden = true
            showAudioButton.isHidden = false
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
}


extension EkoMessageListComposeBarViewController {
    
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
                if strongSelf.screenViewModel.dataSource.getKeyboardVisible() {
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
}

extension EkoMessageListComposeBarViewController: UIPopoverPresentationControllerDelegate {
    
    func showPopoverMessage() {
        let vc = EkoPopoverMessageViewController.make()
        vc.text = EkoLocalizedStringSet.PopoverText.popoverMessageIsTooShort
        vc.modalPresentationStyle = .popover
        
        let popover = vc.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .down
        popover?.sourceView = recordButton
        popover?.sourceRect = recordButton.bounds
        present(vc, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
